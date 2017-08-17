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
            self.coverView.isHidden = !isSelect
            self.selectedImageView.isHidden = coverView.isHidden
        }
    }
    
    func config(with photoAsset: PHAsset) {
                
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        let scale: CGFloat = UIScreen.main.scale
        let newSize: CGSize = CGSize(
            width: self.bounds.width * scale,
            height:self.bounds.height * scale
        )
        
        PHImageManager.default().requestImage(
            for: photoAsset,
            targetSize: newSize,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, info in
            guard let sSelf = self else { return }
            if let image = image {
                sSelf.phohoImageView.image = image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        phohoImageView = UIImageView(frame: bounds)
        
        phohoImageView.contentMode = .scaleAspectFill
        coverView = UIView(frame: bounds)
        coverView.alpha = 0.35
        selectedImageView = UIImageView(image: UIImage(named: "PickerChecked"))
        selectedImageView.frame.origin = CGPoint(x: bounds.width-selectedImageView.bounds.width-8, y: 8)
        selectedImageView.isHidden = true
        addSubview(phohoImageView)
        addSubview(coverView)
        addSubview(selectedImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
