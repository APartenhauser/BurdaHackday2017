//
//  NetworkingManager.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

public protocol ResponseConvertible {
    init(responseData: Dictionary<String, Any>)
}

public protocol ResponseCollectionConvertible {
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Self]
}

public protocol URLStringConvertible {
    static var urlRoute: String { get }
}

public enum RestMethod: String {
    case POST
    case GET
}

public enum Authentication {
    case none, configured(String, String)
    
    public static func defaultAuth() -> Authentication {
        guard let user = NetworkManager.shared.userName, let passwd = NetworkManager.shared.password else {
            return .none
        }
        return .configured(user, passwd)
    }
}

public protocol ResponseDeserializer {
    associatedtype T: ResponseConvertible, ResponseCollectionConvertible
    var objects: [T]? { get set }
    var error: String? { get set }
    
    static func deserialize(_ responseData: Data?) -> Self
}

open class BaseResponseDeserializer<T: ResponseCollectionConvertible & ResponseConvertible> : ResponseDeserializer {
    open var objects: [T]?
    open var error: String?
    //    open var metaData: JSONAPIMetaObject?
    //    open var includes = Array<CommonNetworkObject>()
    
    public init() {
    }
    
    open class func deserialize(_ responseData: Data?) -> Self {
        fatalError()
    }
    //    open class func deserialize(_ responseData: Data?, completion: (BaseResponseDeserializer<T>) -> Void) {
    //        fatalError("This is an abstract class to enrich with it's fields. Implment this method by your own")
    //    }
}

/**
 This is the Networking layer for the whole widget SDK. The NetworkManager is the class which does the requests internally. This is not supposed to be used from outside of the SDK for now. It is built on a basic NSURLSession.
 Requesting resources works via the `request`method. It is a generic method that uses `ResponseConvertible` and `URLStringConvertible` classes to do request generation and response serialization.
 - SeeAlso: `ResponseConvertible`, `URLStringConvertible`, `Response`
 */
open class NetworkManager: NSObject {
    open class var shared: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    fileprivate var session: URLSession {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        return urlSession
    }
    
    open var baseRequestUrl: String?
    open var userName: String?
    open var password: String?
    
    /**
     This method builds the URL and uses the the Dictionary extension to pack and encode the parameters passed.
     With help of the generic Response class the server data is already mapped to a Data object.
     There are multiple points of failure which - for now - only forward an error message.
     On successful Response and Mapping the completion handler is called on the main thread, so the UI can update properly.
     - Parameters:
     - routingType: Defaults to the Type of the generic. Prerequesite is the conformance to `ResponseConvertible` and `URLStringConvertible`
     */
    
    // routingType: T.Type = T.self,
    open func requestAll<T: URLStringConvertible>(_ parameters: Dictionary<String, String> = [:], serializer: BaseResponseDeserializer<T>.Type = BaseResponseDeserializer<T>.self, route: String = T.urlRoute, baseURL: String? = NetworkManager.shared.baseRequestUrl, method: RestMethod = .GET, authenticate: Authentication = Authentication.defaultAuth(), completion: @escaping (_ response: BaseResponseDeserializer<T>?, _ error: String?) -> Void) {
        guard let url = baseURL else {
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, "No baseUrl specified. Please set baseRequestUrl on NetworkManager or pass an url")
            })
            return
        }
        guard let request = parameters.request(forBaseUrlString: url + route, method: method, authentication: authenticate) else {
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, "Can not request for host: " + url + " with route: " + route + " and parameter: " + parameters.description)
            })
            return
        }
        session.dataTask(with: request) { (responseData, response, error) -> Void in
            if let err = error {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, err.localizedDescription)
                })
                return
            }
            // Handle HTTP Error Codes here
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode != 200 {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                })
                return
            }
            let response = serializer.deserialize(responseData)
            DispatchQueue.main.async(execute: { () -> Void in
                completion(response, response.error)
            })
            }.resume()
    }
}

extension Dictionary {
    /**
     Calls requestParameterData and encodes the data as base64 string.
     - Returns: A Base 64 String that represents the Parameters.
     */
    func requestParameterEncoded(_ mehtod: RestMethod = .GET) -> Data? {
        if let data = requestParameterData(mehtod) {
            return data.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0))
        }
        return nil
    }
    
    static func requestParameterDataDecoded(_ data: Data) -> Dictionary<String, String>? {
        guard let decodedData = Data(base64Encoded: data, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            print("Error in decoding data")
            return nil
        }
        guard let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return Dictionary.requestParameterDecode(encodedString: decodedString as String)
    }
    
    /**
     Serializes the Dictionary to a http url parameter encoded string.
     - Returns: A NSData object with the serialized dictionary as content.
     */
    func requestParameterData(_ mehtod: RestMethod = .POST) -> Data? {
        let encodedParameter: String = ""
        let simplified = self.map { return "\($0)=\($1)" }.joined(separator: "&")
        
        guard let data = (encodedParameter + simplified).data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error in Parameter encoding")
            return nil
        }
        return data
    }
    
    var TimeoutInterval: TimeInterval {
        return 15
    }
    
    /**
     Build a request out of a dictionary that represents all parameters.
     - Parameters:
     - urlString: The full qualified url including the route as String.
     - method: The request method, to specify the HTTP method and decide how to add the parameter
     */
    func request(forBaseUrlString urlString: String, method: RestMethod = .GET, authentication: Authentication = .none) -> URLRequest? {
        switch method {
        case .GET:
            // Create encoded Parameters
            let simplified = keys.count > 0 ? "?" + self.map { return "\($0)=\($1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! }.joined(separator: "&") : ""
            guard let url = URL(string: urlString + simplified) else {
                return nil
            }
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeoutInterval)
            request.httpMethod = method.rawValue
            switch authentication {
            case .configured(let user, let passwd):
                request.addHeaderFields(user, password: passwd)
            case .none:
                break
            }
            return request
        case .POST:
            guard let url = URL(string: urlString) else {
                return nil
            }
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeoutInterval)
            request.httpMethod = method.rawValue
            request.httpBody = requestParameterData(method)
            return request
        }
    }
    
    // Only needed to Test parameter encoding/decoding
    static func requestParameterDecode(encodedString string: String) -> Dictionary<String, String>? {
        guard let decodedData = Data(base64Encoded: string, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            print("Error in Parameter decoding")
            return nil
        }
        let decodedString = String(data: decodedData, encoding: String.Encoding.utf8)!
        let prefixRemovedString = decodedString.replacingOccurrences(of: "/?", with: "")
        let splittedParameters = prefixRemovedString.components(separatedBy: "&")
        var finalDict = Dictionary<String, String>()
        splittedParameters.forEach { (concatenated) -> () in
            let parts = concatenated.components(separatedBy: "=")
            finalDict[parts[0]] = parts[1]
        }
        
        return finalDict
    }
}

extension URLRequest {
    /**
     Adds all needed header fields to a mutable request.
     */
    mutating func addHeaderFields(_ username: String, password: String) {
        let authStr = "\(username):\(password)";
        if let authData = authStr.data(using: String.Encoding.utf8) {
            let authValue = "Basic \(authData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))"
            addValue(authValue, forHTTPHeaderField: "Authorization")
        }
    }
}
