//
//  AlbumNavigationController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit

class AlbumNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = UIColor.white
        
        navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17)]
        
        self.interactivePopGestureRecognizer?.delegate = nil
        
        addChildViewController(AlbumListViewController())
        addChildViewController(PhotosViewController())


    }
}
