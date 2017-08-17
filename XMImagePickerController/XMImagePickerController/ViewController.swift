//
//  ViewController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

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
        
        self.getPhotoLibraryAccessStatus { (status) in
            guard status == true else {
                let alertVC = UIAlertController(title: "无法获取照片", message: "请开启照片权限", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确认", style: .default, handler: nil)
                alertVC.addAction(cancelAction)
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let nav = AlbumPickerController()
            nav.addChildVC()
            nav.completedSelected = { assets in
                self.dataSource = assets
                self.collectionView.reloadData()
            }
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func getPhotoLibraryAccessStatus(_ callback: @escaping (_ granted: Bool) -> Void) {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            callback(true)
        case .denied, .restricted:
            callback(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    callback(true)
                } else {
                    callback(false)
                }
            }
        }
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
