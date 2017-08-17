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

    fileprivate var phohoImageView: UIImageView?
    fileprivate var coverView: UIView?
    
    var isSelect: Bool = false {
        didSet {
            //
        }
    }
    
    func config(with photoAsset: PHAsset, selected: Bool) {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
