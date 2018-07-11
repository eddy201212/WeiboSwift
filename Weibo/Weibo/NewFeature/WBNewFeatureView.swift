//
//  WBNewFeatureView.swift
//  Weibo
//
//  Created by Eddy on 2018/7/11.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
 
    class func newFeatureView() -> WBNewFeatureView {
        
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! WBNewFeatureView
        
        return v
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
