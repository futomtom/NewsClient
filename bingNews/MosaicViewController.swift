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
import Kingfisher
import SwiftyJSON

class MosaicViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {

    var articles: [Article] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        //  navigationController!.isToolbarHidden = true
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        collectionView?.prefetchDataSource = self

        let layout = collectionViewLayout as! MosaicViewLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        NewsAPI.share.sendNewsRequest { articles in
            self.articles = articles
            self.collectionView?.reloadData()
        }

    }
}

// MARK: UICollectionViewDataSource
extension MosaicViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsViewCell

        // Configure the cell
        cell.article = articles[indexPath.item]

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MosaicViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 //       let character = articles[indexPath.item]
 //       performSegue(withIdentifier: "MasterToDetail", sender: character)
    }
}


// MARK: MosaicLayoutDelegate
extension MosaicViewController: MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {

        let article = articles[indexPath.item]
        if  let image = article.image {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
            return rect.height
            
        }else  {
                ImageDownloader.default.downloadImage(with: article.thumbnail, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    article.image = image
                    let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
                    let rect = AVMakeRect(aspectRatio: (image?.size)!, insideRect: boundingRect)
                    print("hight = \(rect.height)")
                 //   self.collectionView?.reloadItems(at: [indexPath])
                }
            
            return 172.5
        }
    
    }

    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let article = articles[indexPath.item]
        let descriptionHeight = heightForText(article.descriptionField, width: width - 24)
        let height = 4 + 17 + 4 + descriptionHeight + 12
        return height
    }

    func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }


    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            print("prefetch")
        for indexPath in indexPaths {
            print(indexPath.item)
            let article = articles[indexPath.row]
            article.task = ImageDownloader.default.downloadImage(with: article.thumbnail, options: [], progressBlock: nil) {
                (image, error, url, data) in
                article.image = image
                //(cell as! CollectionViewCell).cellImageView.image = image
            }


        }
    }

    // indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {

        for indexPath in indexPaths {
             let article = articles[indexPath.row]
             article.task?.cancel()
        }
    }



}
