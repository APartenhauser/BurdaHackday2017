//
//  NokiaApiDeserializer.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

class NokiaApiDeserializer<T>: BaseResponseDeserializer<T> where T: ResponseCollectionConvertible & ResponseConvertible {
    override static func deserialize(_ responseData: Data?) -> NokiaApiDeserializer<T> {
        let deserializer = NokiaApiDeserializer<T>()
        
        guard let data = responseData else {
            deserializer.error = "No Data returned"
            return deserializer
        }
        do {
            guard let responseObjects = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> else {
                deserializer.error = "Wrong data format"
                return deserializer
            }
            if let responseCollection = responseObjects["data"] as? Array<Dictionary<String, Any>> {
                deserializer.objects = T.collection(responseCollection)
            }
        } catch {
            deserializer.error = "Error parsing data."
            return deserializer
        }
        
        return deserializer
    }
}
