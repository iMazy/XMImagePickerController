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

    fileprivate var iconImageView: UIImageView = UIImageView()
    fileprivate var albumNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    fileprivate var countLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()

    
    func config(with model: AlbumModel) {
        self.albumNameLabel.text = model.name
        self.countLabel.text = "(\(model.count))"
        self.albumNameLabel.sizeToFit()
        self.countLabel.sizeToFit()
        
        
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
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        self.accessoryType = .disclosureIndicator

        self.iconImageView.contentMode = .scaleAspectFill
        addSubview(iconImageView)
    
        addSubview(albumNameLabel)
        addSubview(countLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        
        albumNameLabel.frame.origin = CGPoint(x: iconImageView.frame.maxX+10, y: iconImageView.frame.midY - albumNameLabel.bounds.height/2)
        countLabel.frame.origin = CGPoint(x: albumNameLabel.frame.maxX+8, y: iconImageView.frame.midY - countLabel.bounds.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
