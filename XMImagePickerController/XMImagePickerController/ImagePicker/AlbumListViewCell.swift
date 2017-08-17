//
//  AlbumListViewCell.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func config(with model: AlbumModel) {
        self.albumNameLabel.text = model.name
        self.countLabel.text = "(\(model.count))"
        
        if let asset = model.assetResult?.lastObject {
            
            let scale: CGFloat = UIScreen.main.scale
            let newSize: CGSize = CGSize(
                width: self.bounds.width * scale,
                height: self.bounds.width * scale * (self.iconImageView.bounds.width/self.iconImageView.bounds.height)
            )
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: newSize,
                contentMode: .aspectFill,
                options: options
            ) { [weak self] image, info in
                guard let sSelf = self else { return }
                sSelf.iconImageView.image = image
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImageView.contentMode = .scaleAspectFill
    }
}
