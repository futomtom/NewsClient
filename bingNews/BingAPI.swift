
import Foundation
import Alamofire
import SwiftyJSON



enum BingNews {
    case news(String)
    
    
    private var baseURL: URL { return URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/")! }
    public func path(postfix:String) -> String {
        switch self {
        case .news(let category):
            return "\(baseURL)/news/\(category)"
        }
        
    }
}


/*

class BingNewsAPI {
    
    func reguest(ednpoint:BingNews) {
        switch ednpoint {
        case .news(let string):
            let url = .news("e")
        default:
            return
        }
        
        
    }
    
       func getNews(category:String) -> [News]? {
        Alamofire.request(BingNews., method: .get).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
        }

        
    }
  }
}
 */
