//
//  PhotoCollectionViewCell.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {

    fileprivate var phohoImageView: UIImageView!
    fileprivate var coverView: UIView!
    fileprivate var selectedImageView: UIImageView!
    
    var isSelect: Bool = false {
        didSet {

            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                
                if self.isSelect {
                    self.selectedImageView.transform = CGAffineTransform.identity
                    self.coverView.alpha = 0.45
                } else {
                    self.selectedImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.coverView.alpha = 0.0
                }
                
            })
        }
    }
    
    func config(with photoAsset: PHAsset) {
        
        PHAssetManager.transformPHAssetToImage(with: photoAsset) { [unowned self] (image) in
            self.phohoImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        phohoImageView = UIImageView(frame: bounds)
        phohoImageView.contentMode = .scaleAspectFill
        phohoImageView.clipsToBounds = true
        
        coverView = UIView(frame: bounds)
        coverView.backgroundColor = UIColor.white
        coverView.alpha = 0.0
//        coverView.isHidden = true
        
        selectedImageView = UIImageView(image: Bundle().selectedImage)
        
        selectedImageView.frame.origin = CGPoint(x: bounds.width-selectedImageView.bounds.width-8, y: 8)
//        selectedImageView.isHidden = true
        self.selectedImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        addSubview(phohoImageView)
        addSubview(coverView)
        addSubview(selectedImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Bundle {
    var _bundle:Bundle?{
        if let path = Bundle(for: AlbumPickerController.self).path(forResource: "AlbumResources", ofType: "bundle"){
            return Bundle(path: path)
        }
        return nil
    }
    
    var selectedImage: UIImage?{
        if let path = _bundle?.path(forResource: "PickerChecked@2x", ofType: "png"){
            return UIImage(contentsOfFile: path)!
        }
        return nil
    }
    
    var backImageImage: UIImage? {
        if let path = _bundle?.path(forResource: "invalidName@2x", ofType: "png"){
            return UIImage(contentsOfFile: path)!
        }
        return nil
    }
}
