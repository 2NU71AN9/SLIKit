//
//  Ex_ScrollView.swift
//  SLSupportLibrary
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import MJRefresh

public extension UITableView {
    final func registerNib<T: UITableViewCell>(_: T.Type)  {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerClass<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UICollectionView {
    final func registerNib<T: UICollectionViewCell>(_: T.Type)  {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerClass<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerHeaderNib<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerHeaderClass<T: UICollectionReusableView>(_: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerFooterNib<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func registerFooterClass<T: UICollectionReusableView>(_: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UIScrollView {
    func set_refreshHeader(_ ignoredTop: CGFloat = 0, _ refresh: @escaping () -> Void) {
        let header = MJRefreshNormalHeader(refreshingBlock: refresh)
        header.ignoredScrollViewContentInsetTop = ignoredTop
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.textColor = UIColor.lightGray
        mj_header = header
    }
    func set_refreshFooter(_ loadMore: @escaping () -> Void) {
        let footer = MJRefreshBackNormalFooter(refreshingBlock: loadMore)
        footer.arrowView?.image = nil
        footer.stateLabel?.textColor = UIColor.lightGray
        footer.setTitle("- end -", for: .noMoreData)
        mj_footer = footer
    }
    /// 上拉下拉都有的时候才可以调用
    func endRefreshing(_ count: Int = 0, standard: Int = 10) {
        mj_header?.endRefreshing()
        count < standard
            ? mj_footer?.endRefreshingWithNoMoreData()
            : mj_footer?.endRefreshing()
    }
}
