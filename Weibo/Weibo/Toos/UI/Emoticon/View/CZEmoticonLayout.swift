//
//  CZEmoticonLayout.swift
//  Emoticon
//
//  Created by Eddy on 2018/7/6.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class CZEmoticonLayout: UICollectionViewFlowLayout {

    /// prepare 就是 OC 中的 prepareLayout
    override func prepare() {
        super.prepare()
        
        // 在此方法中，collectionView 的大小已经确定
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        
        // 设定滚动方向
        // 水平方向滚动，cell 垂直方向布局
        // 垂直方向滚动，cell 水平方向布局
        scrollDirection = .horizontal
    }
}
