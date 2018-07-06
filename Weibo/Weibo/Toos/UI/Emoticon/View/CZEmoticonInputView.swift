//
//  CZEmoticonInputView.swift
//  Emoticon
//
//  Created by Eddy on 2018/7/6.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

fileprivate let cellId = "CZEmoticonCellId"

class CZEmoticonInputView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var toolbar: UIView!
    
    class func inputView() -> CZEmoticonInputView {
        
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! CZEmoticonInputView
        
        return v
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
    }
}

// MARK:UICollectionViewDelegate
extension CZEmoticonInputView: UICollectionViewDelegate {
        
}

// MARK:UICollectionViewDataSource
extension CZEmoticonInputView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CZEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return CZEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 取 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CZEmoticonCell
        
        // 2. 设置 cell - 传递对应页面的表情数组
        
        
        
        // 3. 返回 cell
        return cell
    }
}



