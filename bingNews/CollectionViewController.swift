//
//  CollectionViewController.swift
//  bingNews
//
//  Created by Alex on 3/20/17.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var articles: [Article] = []
    let category = ["Business","Entertainment_MovieAndTV","Entertainment_Music","Health","Politics"
        ,"Technology","Science","Sports_Golf","Sports_MLB","Sports_NBA","Sports_NFL","Sports_NHL","Sports_Soccer"
        ,"Sports_Tennis","Sports_CFB","Sports_CBB"]
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 30) / 3
        layout.itemSize = CGSize(width: width, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView?.prefetchDataSource = self
    

        
        BingAPI.share.sendNewsRequest(by: category[0]) { articles in
            self.articles = articles
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
           as! HeaderView
            
            header.title = "Section Header"
            
            return header
    }
  

    
 }

// MARK: UICollectionViewDataSource
extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsFlowCell
        
        // Configure the cell
        cell.article = articles[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == articles.count - 5 {
            let categoryIndex = min(articles.count / 10,category.count - 1)
            BingAPI.share.sendNewsRequest(by: category[categoryIndex]) { newArticles in
                self.articles += newArticles
                print(self.articles.count,newArticles.count)
                self.collectionView?.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension CollectionViewController:UICollectionViewDataSourcePrefetching {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //       let character = articles[indexPath.item]
        //       performSegue(withIdentifier: "MasterToDetail", sender: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    //    print("prefetch")
        for indexPath in indexPaths {
    //        print(indexPath.item)
            let article = articles[indexPath.row]
            let start = CFAbsoluteTimeGetCurrent()
            
            article.task = ImageDownloader.default.downloadImage(with: article.thumbnail, options: [], progressBlock: nil) {
                (image, error, url, data) in
                let end = CFAbsoluteTimeGetCurrent()
            //    print(end - start)
                article.image = image
                //(cell as! CollectionViewCell).cellImageView.image = image
            }
        }
    }
    
    
    // indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("c")
        for indexPath in indexPaths {
            print(indexPath.row)
            let article = articles[indexPath.row]
            article.task?.cancel()
        }
    }
    

}

