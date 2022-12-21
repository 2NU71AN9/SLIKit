//
//  Ex_ScrollView.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import MJRefresh

public extension SLEx where Base: UITableView {
    
    @discardableResult
    func rowHeight(_ height: CGFloat = UITableView.automaticDimension) -> SLEx {
        base.rowHeight = height
        return self
    }
    
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> SLEx {
        base.estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat = UITableView.automaticDimension) -> SLEx {
        base.sectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> SLEx {
        base.estimatedSectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat = UITableView.automaticDimension) -> SLEx {
        base.sectionFooterHeight = height
        return self
    }
    
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> SLEx {
        base.estimatedSectionFooterHeight = height
        return self
    }
    
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> SLEx {
        base.separatorStyle = style
        return self
    }
    
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> SLEx {
        base.tableHeaderView = view
        return self
    }
    
    @discardableResult
    func tableFooterView(_ view: UIView?) -> SLEx {
        base.tableFooterView = view
        return self
    }
    
    @discardableResult
    func registerNib<T: UITableViewCell>(_: T.Type) -> SLEx {
        let nib = UINib(nibName: T.sl.reuseIdentifier, bundle: nil)
        base.register(nib, forCellReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerClass<T: UITableViewCell>(_: T.Type) -> SLEx {
        base.register(T.self, forCellReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
}

public extension SLEx where Base: UICollectionViewFlowLayout {
    
    @discardableResult
    func itemSize(_ size: CGSize = UICollectionViewFlowLayout.automaticSize) -> SLEx {
        base.itemSize = size
        return self
    }
    
    @discardableResult
    func estimatedItemSize(_ size: CGSize) -> SLEx {
        base.estimatedItemSize = size
        return self
    }
    
    /// 水平间距
    @discardableResult
    func minimumInteritemSpacing(_ spacing: CGFloat) -> SLEx {
        base.minimumInteritemSpacing = spacing
        return self
    }
    
    /// 垂直间距
    @discardableResult
    func minimumLineSpacing(_ spacing: CGFloat) -> SLEx {
        base.minimumLineSpacing = spacing
        return self
    }
    
    @discardableResult
    func sectionInset(_ inset: UIEdgeInsets) -> SLEx {
        base.sectionInset = inset
        return self
    }

    /// 横屏时在SafeArea内
    @discardableResult
    func sectionInsetReference(_ a: UICollectionViewFlowLayout.SectionInsetReference = .fromSafeArea) -> SLEx {
        base.sectionInsetReference = a
        return self
    }
}

public extension SLEx where Base: UICollectionView {
    
    @discardableResult
    func registerNib<T: UICollectionViewCell>(_: T.Type) -> SLEx {
        let nib = UINib(nibName: T.sl.reuseIdentifier, bundle: nil)
        base.register(nib, forCellWithReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerClass<T: UICollectionViewCell>(_: T.Type) -> SLEx {
        base.register(T.self, forCellWithReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerHeaderNib<T: UICollectionReusableView>(_: T.Type) -> SLEx {
        let nib = UINib(nibName: T.sl.reuseIdentifier, bundle: nil)
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerHeaderClass<T: UICollectionReusableView>(_: T.Type) -> SLEx {
        base.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerFooterNib<T: UICollectionReusableView>(_: T.Type) -> SLEx {
        let nib = UINib(nibName: T.sl.reuseIdentifier, bundle: nil)
        base.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
    
    @discardableResult
    func registerFooterClass<T: UICollectionReusableView>(_: T.Type) -> SLEx {
        base.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.sl.reuseIdentifier)
        return self
    }
}

public extension SLEx where Base: UIScrollView {
    
    @discardableResult
    func showsHorizontalScrollIndicator(_ show: Bool) -> SLEx {
        base.showsHorizontalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func showsVerticalScrollIndicator(_ show: Bool) -> SLEx {
        base.showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate) -> SLEx {
        switch delegate {
        case let d as UITableViewDelegate where base is UITableView:
            base.delegate = d
        case let d as UICollectionViewDelegate where base is UICollectionView:
            base.delegate = d
        default:
            base.delegate = delegate
        }
        return self
    }
    
    @discardableResult
    func dataSource(_ dataSource: NSObjectProtocol) -> SLEx {
        switch dataSource {
        case let d as UITableViewDataSource where base is UITableView:
            (base as? UITableView)?.dataSource = d
        case let d as UICollectionViewDataSource where base is UICollectionView:
            (base as? UICollectionView)?.dataSource = d
        default:
            break
        }
        return self
    }
    
    @discardableResult
    func refreshHeader(_ ignoredTop: CGFloat = 0, _ refresh: @escaping () -> Void) -> SLEx {
        let header = MJRefreshNormalHeader(refreshingBlock: refresh)
        header.ignoredScrollViewContentInsetTop = ignoredTop
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.textColor = UIColor.lightGray
        base.mj_header = header
        return self
    }
    
    @discardableResult
    func refreshFooter(_ loadMore: @escaping () -> Void) -> SLEx {
        let footer = MJRefreshBackNormalFooter(refreshingBlock: loadMore)
        footer.isAutomaticallyChangeAlpha = true
        footer.arrowView?.image = nil
        footer.stateLabel?.textColor = UIColor.lightGray
        footer.setTitle("- 到底了 -", for: .noMoreData)
        base.mj_footer = footer
        return self
    }
    
    /// 上拉下拉都有的时候才可以调用
    @discardableResult
    func endRefreshing(_ count: Int = 0, standard: Int = 10) -> SLEx {
        base.mj_header?.endRefreshing()
        count < standard
            ? base.mj_footer?.endRefreshingWithNoMoreData()
            : base.mj_footer?.endRefreshing()
        return self
    }
}
