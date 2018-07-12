//
//  WBStatusPictureView.swift
//  Weibo
//
//  Created by Eddy on 2018/6/28.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit
import SnapKit

//微博配图视图
class WBStatusPictureView: UIView {

    @IBOutlet var heightCons: NSLayoutConstraint!
    
    var viewModel: WBStatusViewModel? {
        
        didSet {
            //FIXME:
            calViewSize()
            urls = viewModel?.picURLs
        }
    }

    var urls: [WBStatusPicture]? {
        
        didSet {
            
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                iv.wb_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                
                iv.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased()) != "gif"
                
                iv.isHidden = false
                index += 1
            }
        }
    }
    
    private func calViewSize() {
        
        // 处理宽度
        // 单图. 更新视图的大小，修改 subviews[0] 的宽高
        
        if viewModel?.picURLs?.count == 1 {
            
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height - WBStatusPictureViewOutterMargin)
            
        } else {
            // 多图，恢复subview[0]的宽高，保证九宫格布局的完整
            
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        }
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

extension WBStatusPictureView {
    
    @objc func tapAction(tapGesture: UITapGestureRecognizer) {
        
        guard let iv = tapGesture.view,
        let picURLs = viewModel?.picURLs else {
            return
        }
        
        var selectedIndex = iv.tag
        
        //针对4张图的处理
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        
        let urls = (picURLs as NSArray).value(forKey: "largePic") as! [String]
        
        // 处理可见的图像视图数组
        var imageViewList = [UIImageView]()
        for iv in subviews as! [UIImageView] {
            
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(WBStatusCellBrowserPhotoNotificaiton), object: self, userInfo: [WBStatusCellBrowserPhotoURLsKey: urls,
                       WBStatusCellBrowserPhotoImageViewKey: imageViewList,
                       WBStatusCellBrowserPhotoSelectedIndexKey: selectedIndex]
        )
        
    }
}

extension WBStatusPictureView {
    
    func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
     
        for i in 0..<count * count {
            
            let row = CGFloat(i / 3)//当前行
            let col = CGFloat(i % 3)//当前列
            
            let xOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            
            let iv = UIImageView()
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            iv.isUserInteractionEnabled = true
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.tag = i
            addSubview(iv)
            
            addGifView(iv:iv)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            iv.addGestureRecognizer(tapGesture)
        }
    }

    fileprivate func addGifView(iv: UIImageView) {
        
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        iv.addSubview(gifImageView)
        
        gifImageView.snp.makeConstraints { (make) in
            
            make.right.equalTo(iv)
            make.bottom.equalTo(iv)
        }
    }
}
