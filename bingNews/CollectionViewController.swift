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
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.itemSize = CGSize(width: view.bounds.width, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView?.prefetchDataSource = self
    

        
        NewsAPI.share.sendNewsRequest { articles in
            self.articles = articles
            self.collectionView?.reloadData()
        }

 
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
}

// MARK: UICollectionViewDelegate
extension CollectionViewController:UICollectionViewDataSourcePrefetching {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //       let character = articles[indexPath.item]
        //       performSegue(withIdentifier: "MasterToDetail", sender: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetch")
        for indexPath in indexPaths {
            print(indexPath.item)
            let article = articles[indexPath.row]
            let start = CFAbsoluteTimeGetCurrent()
            
            article.task = ImageDownloader.default.downloadImage(with: article.thumbnail, options: [], progressBlock: nil) {
                (image, error, url, data) in
                let end = CFAbsoluteTimeGetCurrent()
                print(end - start)
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

