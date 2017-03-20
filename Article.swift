
import Foundation
import SwiftyJSON

class Article{
    
    var author : String!
    var descriptionField : String!
    var publishedAt : String!
    var title : String!
    var url : String!
    var urlToImage : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        author = json["author"].stringValue
        descriptionField = json["description"].stringValue
        publishedAt = json["publishedAt"].stringValue
        title = json["title"].stringValue
        url = json["url"].stringValue
        urlToImage = json["urlToImage"].stringValue
    }
    
}
