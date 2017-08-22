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
    
    fileprivate var selectedIndexCopy: [Int] = []
    
    var selectedIndex: [Int] = []  {
        didSet {
            self.selectedIndexCopy = selectedIndex
        }
    }
    
    var backToConfirmSelect:(([Int])->Void)?
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate var pageControl: UIPageControl!
    fileprivate var selectButton: UIButton!
    fileprivate var bottomToolBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        view.backgroundColor = UIColor.lightGray
        
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

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "确认",
            style: .plain,
            target: self,
            action: #selector(confirmButtonAction)
        )
        
        self.navigationItem.title = "已选照片(\(self.assetArray?.count ?? 0))"
        
        self.flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-36)
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-36), collectionViewLayout: self.flowLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .white
        
        self.collectionView.register(PreViewCollectionViewCell.self, forCellWithReuseIdentifier: "preViewReuseIdentifier")
        
        view.addSubview(collectionView)
        
        self.bottomToolBar = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-35, width: UIScreen.main.bounds.width, height: 35))
        self.bottomToolBar.backgroundColor = UIColor.white
        view.addSubview(bottomToolBar)
        
        self.pageControl = UIPageControl()
        self.pageControl.currentPage = 0
        self.pageControl.hidesForSinglePage = true
        self.pageControl.pageIndicatorTintColor = UIColor.darkGray
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 255/255.0, green: 42/255.0, blue: 102/255.0, alpha: 1.0)
        self.pageControl.frame = CGRect(x: 35, y: 0, width: UIScreen.main.bounds.width-70, height: 35)
        self.pageControl.numberOfPages = self.assetArray?.count ?? 0
        self.pageControl.isUserInteractionEnabled = false
        self.bottomToolBar.addSubview(pageControl)
        
        self.selectButton = UIButton(type: .custom)
        self.selectButton.frame.size = CGSize(width: 25, height: 25)
        self.selectButton.frame.origin = CGPoint(x: UIScreen.main.bounds.width-35, y: 5)
        self.selectButton.setBackgroundImage(Bundle().selectedImage, for: .normal)
        self.selectButton.setBackgroundImage(Bundle().selectNoneImage, for: .selected)
        self.selectButton.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
        self.bottomToolBar.addSubview(selectButton)
        
    }
    
    @objc fileprivate func backAction() {
        self.navigationController?.popViewController(animated: true)
        
        if let comfirmClosure = self.backToConfirmSelect {
            comfirmClosure(self.selectedIndexCopy)
        }
    }

    @objc private func selectButtonClick(button: UIButton) {
        button.isSelected = !button.isSelected
        
        let pageIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        if button.isSelected {
            self.selectedIndexCopy[pageIndex] = -1
        } else {
            self.selectedIndexCopy[pageIndex] = self.selectedIndex[pageIndex]
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = self.selectedIndexCopy.filter({$0 != -1}).count > 0
    }
    
    @objc private func confirmButtonAction() {
        
        guard let assets = self.assetArray else { return }
        
        var completedAsset: [PHAsset] = [PHAsset]()
        
        for (index, value) in self.selectedIndexCopy.enumerated() {
            if value != -1 {
                completedAsset.append((assets[index]))
            }
        }
        let albumNav = self.navigationController as! AlbumPickerController
        var imageArray: [UIImage] = [UIImage]()
        completedAsset.forEach({ (asset) in
            PHAssetManager.transformPHAssetToImage(with: asset) { image in
                imageArray.append(image)
                
                if imageArray.count == completedAsset.count {
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
    
}

extension PreViewViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageOffset = scrollView.contentOffset.x / scrollView.bounds.width
        self.pageControl.currentPage = Int(pageOffset + 0.5)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if self.selectedIndexCopy[pageIndex] == -1 {
            self.selectButton.isSelected = true
        } else {
            self.selectButton.isSelected = false
        }
    }
}

