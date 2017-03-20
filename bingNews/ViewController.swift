//
//  ViewController.swift
//  bingNews
//
//  Created by Alex on 3/18/17.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UICollectionViewController {

    let articles: [Article] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        //  navigationController!.isToolbarHidden = true
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)

        let layout = collectionViewLayout as! MosaicViewLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5

    }


    func sendGetnewsRequest() {
        /**
         getNews
         get https://api.cognitive.microsoft.com/bing/v5.0/news/
         */

        // Add Headers
        let headers = [
            "Ocp-Apim-Subscription-Key\n": "71fc740d5409409d8df291604060c143",
        ]

        // Add URL parameters
        let urlParams = [
            "Category": "Business",
        ]

        // Fetch Request
        Alamofire.request("https://api.cognitive.microsoft.com/bing/v5.0/news/", method: .get, parameters: urlParams, headers: headers)
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

// MARK: UICollectionViewDataSource
extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! NewsViewCell

        // Configure the cell
        cell.article = articles[indexPath.item]

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = articles[indexPath.item]
        performSegue(withIdentifier: "MasterToDetail", sender: character)
    }
}


// MARK: MosaicLayoutDelegate
extension ViewController: MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {

        let character = articles[indexPath.item]
        let image = UIImage(named: articles.urlToImage)
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: image!.size, insideRect: boundingRect)

        return rect.height
    }

    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = articles[indexPath.item]
        let descriptionHeight = heightForText(articles.descriptionField, width: width - 24)
        let height = 4 + 17 + 4 + descriptionHeight + 12
        return height
    }

    func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }


}
