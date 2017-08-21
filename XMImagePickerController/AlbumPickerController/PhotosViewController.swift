//
//  PhotosViewController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController {
    
    var assetResult: PHFetchResult<PHAsset>?
    fileprivate var selectedIndex: [Int] = []
    
    fileprivate lazy var fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        options.includeAllBurstAssets = false
        options.includeHiddenAssets = false
        return options
    }()

    
    fileprivate var collectionView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    
    fileprivate var toolBarHeight: CGFloat = 44
    fileprivate var toolBarView: UIView!
    
    fileprivate var previewButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("预览", for: .normal)
        btn.setTitleColor(UIColor(red: 255/255.0, green: 42/255.0, blue: 102/255.0, alpha: 1.0), for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.sizeToFit()
        return btn
    }()
    fileprivate var confirmButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确认", for: .normal)
        btn.backgroundColor = UIColor(red: 255/255.0, green: 42/255.0, blue: 102/255.0, alpha: 1.0)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.sizeToFit()
        return btn
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1.0)
        
        setupUI()
        
        fetchPhotos()
    }
    
    fileprivate func setupUI() {
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        backButton.setImage(Bundle().backImageImage, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.sizeToFit()
        backButton.frame.size.width += 7
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        updateBottomToolBar()
        
        flowLayout = UICollectionViewFlowLayout()
        let margin: CGFloat = 4
        let WH: CGFloat = (UIScreen.main.bounds.width-margin*4)/3
        flowLayout.itemSize = CGSize(width: WH, height: WH)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-toolBarHeight-1), collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        collectionView.showsHorizontalScrollIndicator = false
                
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoReuseIdentifier")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        toolBarView = UIView(frame: CGRect(x: 0, y: collectionView.frame.maxY+1, width: UIScreen.main.bounds.width, height: toolBarHeight))
        toolBarView.backgroundColor = UIColor.white
        view.addSubview(toolBarView)
        
        previewButton.frame = CGRect(x: 0, y: 0, width: 60, height: toolBarHeight)
        previewButton.addTarget(self, action: #selector(preViewButtonAction), for: .touchUpInside)
        toolBarView.addSubview(previewButton)
        
        confirmButton.frame = CGRect(x: view.bounds.width-60-16, y: (toolBarHeight-30)/2, width: 60, height: 30)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        confirmButton.layer.cornerRadius = 5
        toolBarView.addSubview(confirmButton)
        
    }
    
    @objc private func confirmButtonAction() {
        let assetArray = self.getSelectedAssets()
        
        let albumNav = self.navigationController as! AlbumPickerController
        
        var imageArray: [UIImage] = [UIImage]()
        assetArray.forEach({ (asset) in
            PHAssetManager.transformPHAssetToImage(with: asset) { image in
                imageArray.append(image)
                
                if imageArray.count == assetArray.count {
                    if let complete = albumNav.completedSelected  {
                        complete(imageArray)
                    }
                }
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func preViewButtonAction() {
        
        let assetArray = self.getSelectedAssets()
        let preVC = PreViewViewController()
        preVC.assetArray = assetArray
        preVC.selectedIndex = self.selectedIndex
        show(preVC, sender: nil)
    }

    private func getSelectedAssets() -> [PHAsset] {
        var assetArray: [PHAsset] = [PHAsset]()
        self.selectedIndex.forEach { (index) in
            if let asset = self.assetResult?.object(at: index) {
                assetArray.append(asset)
            }
        }
        return assetArray
    }
    
    fileprivate func fetchPhotos() {
        if let _ = assetResult {
        } else {
            self.navigationItem.title = "相机胶卷"
            self.assetResult = PHAsset.fetchAssets(with: self.fetchOptions)
        }
        self.collectionView.reloadData()
        
        DispatchQueue.main.async {
            if let assetResult = self.assetResult {
                let lastItemIndex = IndexPath(row: assetResult.count-1, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
            }
        }
    }
    
    @objc fileprivate func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
     @objc fileprivate func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let assetResult = assetResult {
            return assetResult.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoReuseIdentifier", for: indexPath) as! PhotoCollectionViewCell
        if let assetResult = assetResult {
            cell.config(with: assetResult.object(at: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        
        if self.selectedIndex.count > 8 && !cell.isSelect {
            let alertVC = UIAlertController(title: "你最多只能选择9张照片", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        cell.isSelect = !cell.isSelect
        
        if cell.isSelect {
            self.selectedIndex.append(indexPath.row)
        } else {
            self.selectedIndex = self.selectedIndex.filter({ $0 != indexPath.row })
        }        
        updateBottomToolBar()
        
    }
    
    fileprivate func updateBottomToolBar() {
        
        self.previewButton.isEnabled = self.selectedIndex.count > 0
        self.confirmButton.isEnabled = self.previewButton.isEnabled
        
        if self.selectedIndex.count > 0 {
            self.confirmButton.setTitle("确认(\(self.selectedIndex.count))", for: .normal)
            self.confirmButton.alpha = 1
        } else {
            self.confirmButton.setTitle("确认", for: .normal)
            self.confirmButton.alpha = 0.5
        }
    }
}
