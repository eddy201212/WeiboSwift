//
//  CZRefreshControl.swift
//  Weibo
//
//  Created by Eddy on 2018/7/11.
//  Copyright © 2018年 WB. All rights reserved.
//

import UIKit

/// 刷新状态切换的临界点
fileprivate let CZRefreshOffset: CGFloat = 126

/// 刷新状态
///
/// - Normal:       普通状态，什么都不做
/// - Pulling:      超过临界点，如果放手，开始刷新
/// - WillRefresh:  用户超过临界点，并且放手
enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新控件 - 负责刷新相关的`逻辑`处理
class CZRefreshControl: UIRefreshControl {

    // MARK: - 属性
    /// 刷新控件的父视图，下拉刷新控件应该适用于 UITableView / UICollectionView
    fileprivate weak var scrollView: UIScrollView?
    
    /// 刷新视图
    fileprivate lazy var refreshView = CZRefreshView.refreshView()
    
    
    /// 构造函数
    override init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        
        // 判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        // 记录父视图
        scrollView = sv
        
        // KVO 监听父视图的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 本视图从父视图上移除
    // 提示：所有的下拉刷新框架都是监听父视图的 contentOffset
    // 所有的框架的 KVO 监听实现思路都是这个！
    override func removeFromSuperview() {
        // superView 还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        // superView 不存在
    }
}


// MARK: - 设置界面
extension CZRefreshControl {
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        
        // 添加刷新视图 - 从 xib 加载出来，默认是 xib 中指定的宽高
        addSubview(refreshView)
        
        // 自动布局 - 设置 xib 控件的自动布局，需要指定宽高约束
        // 提示：iOS 程序员，一定要会原生的写法，因为：如果自己开发框架，不能用任何的自动布局框架！
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}
