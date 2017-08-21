//
//  PreViewViewController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class PreViewViewController: UIViewController {
    
    var assetArray: [PHAsset]?
    var selectedIndex: [Int] = []
    
    fileprivate var selectedIndexCopy: [Int] = []
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate var pageControl: UIPageControl!
    fileprivate var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "确认",
            style: .plain,
            target: self,
            action: #selector(confirmButtonAction)
        )
        
        self.navigationItem.title = "已选照片(\(self.assetArray?.count ?? 0))"
        
        self.flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: self.flowLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .white
        
        self.collectionView.register(PreViewCollectionViewCell.self, forCellWithReuseIdentifier: "preViewReuseIdentifier")
        
        view.addSubview(collectionView)
        
        self.pageControl = UIPageControl()
        self.pageControl.currentPage = 0
        self.pageControl.hidesForSinglePage = true
        self.pageControl.pageIndicatorTintColor = UIColor.darkGray
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 255/255.0, green: 42/255.0, blue: 102/255.0, alpha: 1.0)
        self.pageControl.frame = CGRect(x: 0, y: self.collectionView.bounds.height-37, width: UIScreen.main.bounds.width, height: 37)
        self.pageControl.numberOfPages = self.assetArray?.count ?? 0
        view.addSubview(pageControl)
        
        self.selectButton = UIButton(type: .custom)
        self.selectButton.frame.size = CGSize(width: 25, height: 25)
        self.selectButton.frame.origin = CGPoint(x: UIScreen.main.bounds.width-35, y: UIScreen.main.bounds.height-35)
        self.selectButton.setBackgroundImage(Bundle().selectedImage, for: .normal)
        self.selectButton.setBackgroundImage(Bundle().selectNoneImage, for: .selected)
        self.selectButton.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
        self.view.addSubview(selectButton)
        
    }

    @objc private func selectButtonClick(button: UIButton) {
        button.isSelected = !button.isSelected
    }
    
    @objc private func confirmButtonAction() {

        let albumNav = self.navigationController as! AlbumPickerController
        var imageArray: [UIImage] = [UIImage]()
        assetArray?.forEach({ (asset) in
            PHAssetManager.transformPHAssetToImage(with: asset) { image in
                imageArray.append(image)
                
                if imageArray.count == self.assetArray?.count {
                    if let complete = albumNav.completedSelected  {
                        complete(imageArray)
                    }
                }
            }
        })
        self.dismiss(animated: true, completion: nil)
    }

}

extension PreViewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let assets = self.assetArray {
            return assets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PreViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "preViewReuseIdentifier", for: indexPath) as! PreViewCollectionViewCell
        
        if let assets = self.assetArray {
            cell.config(with: assets[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageOffset = scrollView.contentOffset.x / scrollView.bounds.width
        self.pageControl.currentPage = Int(pageOffset + 0.5)
    }
}

