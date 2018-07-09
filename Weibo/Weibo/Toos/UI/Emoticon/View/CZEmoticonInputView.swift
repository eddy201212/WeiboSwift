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

    fileprivate var seletedEmoticonCallBack: ((_ emoticon: CZEmoticon?)->())?
    
    class func inputView(selectedEmoticon: @escaping(_ emoticon: CZEmoticon?)->()) -> CZEmoticonInputView {
        
        let nib = UINib(nibName: "CZEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! CZEmoticonInputView
        
        // 记录闭包
        v.seletedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(CZEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        
        // 设置分页控件的图片
        let bundle = CZEmoticonManager.shared.bundle
        
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
        let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil)
        else {
            return
        }
        
        // 使用填充图片设置颜色
        //        pageControl.pageIndicatorTintColor = UIColor(patternImage: normalImage)
        //        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selectedImage)
        
        // 使用 KVC 设置私有成员属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
    }
}

// MARK:UICollectionViewDelegate
extension CZEmoticonInputView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1.获取中心点
        var center = scrollView.center
        center.x = scrollView.contentOffset.x
        
        // 2.获取当前显示的cell的indexPath
        let paths = collectionView.indexPathsForVisibleItems
        
        // 3.判断中心点在哪一个 indexPath 上， 在哪个页面上
        var targetIndexPath: IndexPath?
        
        for indexPath in paths {
            
            // 1> 根据 indexPath 获得 cell
            let cell = collectionView.cellForItem(at: indexPath)
            
            // 2> 判断中心点位置
            if cell?.frame.contains(center) == true {
                
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        
        // 4. 判断是否找到 目标的 indexPath
        // indexPath.section => 对应的就是分组
        // FIXME:---
        
        // 5. 设置分页控件
        // 总页数，不同的分组，页数不一样
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
    }
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
        let emoticons = CZEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        
        cell.emoticons = emoticons
        
        // 3. 返回 cell
        return cell
    }
}


// MARK: - CZEmoticonCellDelegate
extension CZEmoticonInputView: CZEmoticonCellDelegate {
    
    /// 选中的表情回调
    ///
    /// - Parameters:
    ///   - cell: 分页 cell
    ///   - em: 选中的表情，删除键为 nil
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?) {
        
       // 执行闭包，回调选中的表情
        seletedEmoticonCallBack?(em)
    }
}



