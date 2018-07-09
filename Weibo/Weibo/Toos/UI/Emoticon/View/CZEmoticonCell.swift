//
//  CZEmoticonCell.swift
//  Emoticon
//
//  Created by Eddy on 2018/7/6.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

/// 表情 Cell 的协议
@objc protocol CZEmoticonCellDelegate: NSObjectProtocol {
    
    /// 表情 cell 选中表情模型
    ///
    /// - parameter em: 表情模型／nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: CZEmoticonCell, em: CZEmoticon?)
}

/// 表情的页面 Cell
/// - 每一个 cell 就是和 collectionView 一样大小
/// - 每一个 cell 中用九宫格的算法，自行添加 20 个表情
/// - 最后一个位置放置删除按钮
class CZEmoticonCell: UICollectionViewCell {
    
    /// 当前页面的表情模型数组，`最多` 20 个
    var emoticons: [CZEmoticon]? {
        
        didSet {
            
            print("表情包的数量\(emoticons?.count ?? 0)")
            
            // 1. 隐藏所有的按钮
            for v in contentView.subviews {
                
                v.isHidden = true
            }
            
            // 显示删除按钮
            contentView.subviews.last?.isHidden = false
            
             // 2. 遍历表情模型数组，设置按钮图像
            for (i, em) in (emoticons ?? []).enumerated() {
                
                // 1> 取出按钮
                if let btn =  contentView.subviews[i] as? UIButton {
                    
                    // 设置图像 - 如果图像为 nil 会清空图像，避免复用
                    btn.setImage(em.image, for: .normal)
                    
                    // 设置 emoji 的字符串 - 如果 emoji 为 nil 会清空 title，避免复用
                    btn.setTitle(em.emoji, for: .normal)
                    
                    btn.isHidden = false
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CZEmoticonCell {
    
    @objc fileprivate func selectedEmoticonButton(btn: UIButton) {
        
        
    }
    
    @objc fileprivate func longGesture(gesture: UILongPressGestureRecognizer) {
        
    }
}

// MARK: 设置界面
extension CZEmoticonCell {
    
    // - 从 XIB 加载，bounds 是 XIB 中定义的大小，不是 size 的大小
    // - 从纯代码创建，bounds 是就是布局属性中设置的 itemSize
    func setupUI() {
        
        let rowCount = 3
        let colCount = 7
        
        // 左右间距
        let leftMargin: CGFloat = 12
        // 底部间距，为分页控件预留空间
        let bottomMargin: CGFloat = 16
        
        
        let width = (bounds.width - CGFloat(2) * leftMargin) / CGFloat(colCount)
        let height = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        // 连续创建 21 个按钮
        for i in 0..<21 {
            
            let row = i / 7
            let col = i % 7
            
            let x = CGFloat(col) * width + leftMargin
            let y = CGFloat(row) * height
            
            let btn = UIButton()
            
            // 设置按钮的大小
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            
            contentView.addSubview(btn)
            
            // 设置按钮的字体大小，lineHeight 基本上和图片的大小差不多！
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
        }
        
        // 取出末尾的删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        
        // 设置图像
        let image = UIImage(named: "compose_emotion_delete_highlighted", in: CZEmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: [])
        
        // 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        
        longPress.minimumPressDuration = 0.1
        addGestureRecognizer(longPress)
    }
}
