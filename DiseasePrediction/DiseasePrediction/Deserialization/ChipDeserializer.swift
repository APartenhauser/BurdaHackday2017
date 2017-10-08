//
//  ChipDeserializer.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

class ChipDeserializer<T>: BaseResponseDeserializer<T> where T: ResponseConvertible & ResponseCollectionConvertible {
    override class func deserialize(_ responseData: Data?) -> ChipDeserializer<T> {
        let deserializer = ChipDeserializer<T>()
        
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
