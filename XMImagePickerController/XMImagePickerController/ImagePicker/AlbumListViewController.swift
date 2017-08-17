//
//  AlbumListViewController.swift
//  XMImagePickerController
//
//  Created by Mazy on 2017/8/16.
//  Copyright © 2017年 Mazy. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tv.tableFooterView = UIView()
        tv.rowHeight = 80
        return tv
    }()
    
    fileprivate var albums: [AlbumModel] = [AlbumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        fetchAlbums()
    }
    
    func setupUI() {
        navigationItem.title = "照片"
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        cancelButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumListViewCell", bundle: nil), forCellReuseIdentifier: "albumReuseCellIdentifier")
    }
    
    func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

}


// MARK: - dataSource
extension AlbumListViewController {
    
    fileprivate func fetchAlbums() {
        // Get all user albums
        let userAlbumsOptions: PHFetchOptions = {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.includeAllBurstAssets = false
            options.includeHiddenAssets = false
            
            if #available(iOS 9.0, *) {
                options.includeAssetSourceTypes = .typeUserLibrary
            } else {
                // Fallback on earlier versions
            }
            return options
        }()
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: .any, options: nil)
        
        userAlbums.enumerateObjects({
            
            let collection = $0.0
            
            guard let name = collection.localizedTitle else {
                return
            }
            
            let result = PHAsset.fetchAssets(in: collection, options: userAlbumsOptions)
            
            guard let _ = result.lastObject else {
                return
            }
            
            // Add album
            let model = AlbumModel(with: name, count: result.count, assetResult: result)
            self.albums.append(model)
            
            self.tableView.reloadData()
            
        })
        
    }
}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlbumListViewCell = tableView.dequeueReusableCell(withIdentifier: "albumReuseCell", for: indexPath) as! AlbumListViewCell
//        cell.config(with: self.albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let model = self.albums[indexPath.row]
        if let asset = model.assetResult {
            let vc = PhotosViewController()
            vc.assetResult = asset
            vc.navigationItem.title = model.name
            show(vc, sender: nil)
        }
    }

}

class AlbumModel {
    
    var name: String = ""
    var count: Int = 0
    var assetResult: PHFetchResult<PHAsset>?
    
    convenience init(with name: String, count: Int, assetResult: PHFetchResult<PHAsset>?) {
        
        self.init()
        
        self.name = name
        self.count = count
        self.assetResult = assetResult
    }
}
