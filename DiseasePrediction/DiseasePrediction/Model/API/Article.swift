//
//  Article.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

final class Article: NSObject, ResponseConvertible, ResponseCollectionConvertible, URLStringConvertible {
    static var urlRoute: String {
        return "/articles"
    }
    
    var title: String? = ""
    var imageUrl: String?
    var date: Date?
    var topic: String? = ""
    var contentType: String? = ""
    var articleDescription: String? = ""
    var link: String?
    var autoplay = false
    var beitragsId: String?
    var containerId: String?
    
    
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Article] {
        var articles = [Article]()
        
        for articleData in responseData {
            articles += [Article(responseData: articleData)]
        }
        
        return articles
    }
    
    required init(responseData: Dictionary<String, Any>) {
        super.init()
        
        title = responseData["title"] as? String ?? ""
        if let imageUrlString = responseData["imageLarge"] as? String {
            self.imageUrl = imageUrlString
        }
        
        link = responseData["link"] as? String
    }
}
