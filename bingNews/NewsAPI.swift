//
//  NewsAPI.swift
//  Pods
//
//  Created by Alex on 3/20/17.
//
//

import Foundation
import SwiftyJSON
import Alamofire

class NewsAPI {
    static let share = NewsAPI()
    
    
    let headers = [
        "Ocp-Apim-Subscription-Key": "71fc740d5409409d8df291604060c143"
    ]
    
    let baseURL = "https://api.cognitive.microsoft.com/bing/v5.0/"
    
    
    func sendNewsRequest(handler:@escaping (([Article]) ->Void)) {
        /**
         getNews
         get https://api.cognitive.microsoft.com/bing/v5.0/news/
         */
        
        // Add Headers
        
        // Add URL parameters
        let urlParams = [
            "Category": "Entertainment",
            ]
        
        // Fetch Request
        Alamofire.request("\(baseURL)news/", method: .get, parameters: urlParams, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    var articles:[Article] = []
                    for (_,subJson):(String, JSON) in json["value"] {
                        let  article = Article(fromJson: subJson)
                        articles.append(article)
                    }
                    
                    DispatchQueue.main.async {
                        handler(articles)
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
}

