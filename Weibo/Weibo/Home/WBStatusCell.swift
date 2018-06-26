//
//  WBStatusCell.swift
//  Weibo
//
//  Created by Eddy on 2018/6/26.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

@objc protocol WBStatusCellDelegate: NSObjectProtocol{
    
    @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}


class WBStatusCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
