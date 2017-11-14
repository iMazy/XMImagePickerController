//
//  ViewController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos
import AlbumPickerController

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    fileprivate var dataSource: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let margin: CGFloat = 4
        let WH: CGFloat = (UIScreen.main.bounds.width-margin*4)/3
        flowLayout.itemSize = CGSize(width: WH, height: WH)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    
    @IBAction func selectePhotos(_ sender: UIBarButtonItem) {
        
        let albumPC = AlbumPickerController()
        albumPC.limitImageCount = 1
        albumPC.completedSelected = { assets in
            self.dataSource = assets
            self.collectionView.reloadData()
        }
        self.present(albumPC, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCellReusableIdentifier", for: indexPath) as! HomeCollectionViewCell
        cell.iconImageView.image = dataSource[indexPath.row]
        return cell
    }
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconImageView.contentMode = .scaleAspectFill
    }
    
}
