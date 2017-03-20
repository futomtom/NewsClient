
import Foundation
import SwiftyJSON


class News : NSObject{
    
    var articles : [Article]!
    var sortBy : String!
    var source : String!
    var status : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        articles = [Article]()
        let articlesArray = json["articles"].arrayValue
        for articlesJson in articlesArray{
            let value = Article(fromJson: articlesJson)
            articles.append(value)
        }
        sortBy = json["sortBy"].stringValue
        source = json["source"].stringValue
        status = json["status"].stringValue
    }
}


