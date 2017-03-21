//
//  BingAPI.swift
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
    
    
    func sendNewsRequest(by source:String,handler:@escaping (([Article]) ->Void)) {
        let urlParams = [
            "source":source,
            "apiKey":"978edd928d834f80a9ee2657e04582e1",
            ]
        
        // Fetch Request
        Alamofire.request("https://newsapi.org/v1/articles", method: .get, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }

       }
}

