//
//  Ex_Rx.swift
//  SLIKit
//
//  Created by 孙梁 on 2020/8/10.
//  Copyright © 2020 SL. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Observable {
    /// 不要直接穿闭方法, 会不释放
    final func subscribeTo(_ method: @escaping (Any?) -> Any?) -> Disposable {
        return subscribe(onNext: { (element) in
            _ = method(element)
        })
    }
    /// 不要直接穿闭方法, 会不释放
    final func subscribeTo(_ method: @escaping (Any?) -> Void) -> Disposable {
        return subscribe(onNext: { (element) in
            _ = method(element)
        })
    }
    /// 不要直接穿闭方法, 会不释放
    final func subscribeTo(_ method: @escaping () -> Void) -> Disposable {
        return subscribe(onNext: { (_) in
            method()
        })
    }
}

public extension Reactive where Base: UITableView {
    var reloadData: Binder<Any> {
        return Binder(base) { (tableView, _) in
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            tableView.reloadData()
        }
    }
    var reloadDataWithError: Binder<Error?> {
        return Binder(base) { (tableView, _) in
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            tableView.reloadData()
        }
    }
    var reloadDataWithCount: Binder<Int> {
        return Binder(base) { (tableView, count) in
            tableView.mj_header?.endRefreshing()
            count < 10 ? tableView.mj_footer?.endRefreshingWithNoMoreData() : tableView.mj_footer?.endRefreshing()
            tableView.reloadData()
        }
    }
    var reloadDataErrorWithCount: Binder<(Int, Error?)> {
        return Binder(base) { (tableView, arg) in
            tableView.mj_header?.endRefreshing()
            arg.0 < 10 ? tableView.mj_footer?.endRefreshingWithNoMoreData() : tableView.mj_footer?.endRefreshing()
            tableView.reloadData()
        }
    }
    var reloadSections: Binder<IndexSet> {
        return Binder(base) { (tableView, sections) in
            tableView.reloadSections(sections, with: .none)
        }
    }
    var reloadSectionsWithAnimaton: Binder<(IndexSet, UITableView.RowAnimation)> {
        return Binder(base) { (tableView, value) in
            tableView.reloadSections(value.0, with: value.1)
        }
    }
}
