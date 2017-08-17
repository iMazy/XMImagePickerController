//
//  PreViewCollectionViewCell.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos


class PreViewCollectionViewCell: UICollectionViewCell {

    private var photoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView = UIImageView(frame: UIScreen.main.bounds)
        photoImageView.contentMode = .scaleAspectFit
        addSubview(photoImageView)
        
    }
    
    func config(with photoAsset: PHAsset) {
        
        PHAssetManager.transformPHAssetToImage(with: photoAsset, scaled: false) { [unowned self] (image) in
            self.photoImageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
