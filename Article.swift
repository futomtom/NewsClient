
import Foundation
import SwiftyJSON
import Kingfisher

//
//	Value.swift
//
//	Create by Alex on 20/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class Article{
    
    var category : String!
    var datePublished : String!
    var descriptionField : String!
    var thumbnail : URL!
    var name : String!
    var image:UIImage? = nil
    var task:RetrieveImageDownloadTask?


    init(fromJson json: JSON!){

          datePublished = json["datePublished"].string
        descriptionField = json["description"].string
        name = json["name"].stringValue
        thumbnail = URL(string:  json["image"]["thumbnail"]["contentUrl"].string!)
    }
    
}
