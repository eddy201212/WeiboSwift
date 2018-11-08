//
//  WBStatusToolBar.swift
//  Weibo
//
//  Created by Eddy on 2018/6/28.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    var viewModel: WBStatusViewModel? {
        
        didSet {
            retweetedButton.setTitle(viewModel?.retweetStr, for: .normal)
            commentButton.setTitle(viewModel?.commentStr, for: .normal)
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    @IBOutlet var retweetedButton: UIButton!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var likeButton: UIButton!
}
