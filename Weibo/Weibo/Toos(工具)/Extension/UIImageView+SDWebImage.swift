//
//  UIImageView+SDWebImage.swift
//  Weibo
//
//  Created by Eddy on 2018/6/28.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func wb_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        kf.setImage(with: url, placeholder: placeholderImage, options: [], progressBlock: nil) { (image, _, _, _) in
            
            if isAvatar {
                
                self.image = image?.wb_avatarImage(size: self.bounds.size, lineWidth: 0.5)
            }
        }
    }
}
