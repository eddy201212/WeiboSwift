//
//  WeiboCommon.swift
//  Weibo
//
//  Created by Eddy on 2018/6/19.
//  Copyright © 2018年 WB. All rights reserved.
//

import Foundation
import UIKit

let WBAppKey = "3213991513"
let WBAppSecret = "7a4dd699abcd218ccf574be21ee2ea38"
let WBRedirectURI = "http://www.baidu.com"

// 全局通知定义

let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"

let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"

let WBStatusCellBrowserPhotoNotificaiton = "WBStatusCellBrowserPhotoNotificaiton"

let WBStatusCellBrowserPhotoURLsKey = "WBStatusCellBrowserPhotoURLsKey"
let WBStatusCellBrowserPhotoImageViewKey = "WBStatusCellBrowserPhotoImageViewKey"
let WBStatusCellBrowserPhotoSelectedIndexKey = "WBStatusCellBrowserPhotoSelectedIndexKey"

let WBStatusPictureViewOutterMargin = CGFloat(12)
let WBStatusPictureViewInnerMargin = CGFloat(3)
let WBStatusPictureViewWidth = UIScreen.main.bounds.width - 2 * WBStatusPictureViewOutterMargin
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3

let isIphoneX: Bool = UIDevice.current.isIphoneX()
let isIphoneXR: Bool = UIDevice.current.isIphoneXR()
let isIphoneX_Max: Bool = UIDevice.current.isIphoneXS_Max()
let isIphoneX_Series: Bool = UIDevice.current.isIphoneX_Series()

let navigationBarHeight: CGFloat = isIphoneX_Series ? 88 : 64
let tabBarHeight: CGFloat = isIphoneX_Series ? 83 : 49
let bottomSafeMargin: CGFloat = isIphoneX_Series ? 34 : 0

let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height
