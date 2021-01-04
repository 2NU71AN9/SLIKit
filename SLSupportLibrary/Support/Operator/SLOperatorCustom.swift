//
//  SLOperatorCustom.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
import RxCocoa
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// 去空
postfix operator ~~
public postfix func ~~(a: String?)            -> String            { return a == nil ? "" : a! }
public postfix func ~~(a: Int?)               -> Int               { return a == nil ? 0 : a! }
public postfix func ~~(a: Int8?)              -> Int8              { return a == nil ? 0 : a!}
public postfix func ~~(a: Int16?)             -> Int16             { return a == nil ? 0 : a! }
public postfix func ~~(a: Int32?)             -> Int32             { return a == nil ? 0 : a! }
public postfix func ~~(a: Int64?)             -> Int64             { return a == nil ? 0 : a! }
public postfix func ~~(a: UInt?)              -> UInt              { return a == nil ? 0 : a! }
public postfix func ~~(a: Double?)            -> Double            { return a == nil ? 0 : a! }
public postfix func ~~(a: Float?)             -> Float             { return a == nil ? 0 : a! }
public postfix func ~~(a: CGFloat?)           -> CGFloat           { return a == nil ? 0 : a! }
public postfix func ~~(a: [Any]?)             -> [Any]             { return a == nil ? [] : a! }
public postfix func ~~(a: [String]?)          -> [String]          { return a == nil ? [] : a! }
public postfix func ~~(a: [Int]?)             -> [Int]             { return a == nil ? [] : a! }
public postfix func ~~(a: [String: Any]?)     -> [String: Any]     { return a == nil ? [:] : a! }
public postfix func ~~(a: [String: String]?)  -> [String: String]  { return a == nil ? [:] : a! }
public postfix func ~~<T: NSObject>(a: T?) -> T {
    return a == nil ? T.init() : a!
}
public postfix func ~~<T: HandyJSON>(a: T?) -> T {
    return a == nil ? T.deserialize(from: "")! : a!
}

/// 字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}





// Two way binding operator between control property and relay, that's all it takes.
infix operator <-> : DefaultPrecedence

#if os(iOS)
func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base>(textInput: TextInput<Base>, relay: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = relay.asObservable().bind(to: textInput.text)
    
    let bindToRelay = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] n in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != relay.value {
             relay.accept(nonMarkedTextValue ?? "")
             }
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != relay.value {
                relay.accept(nonMarkedTextValue)
            }
            }, onCompleted:  {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}
#endif

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG && !os(macOS)
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to relay.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> relay` instead of `textField.rx.text <-> relay`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }
    
    let bindToUIDisposable = relay.asObservable().bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}


func <-> (property: BehaviorRelay<String?>, relay: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = relay.asObservable().bind(to: property)
    let bindToRelay = property
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { n in
            if n != relay.value {
                relay.accept(n ?? "")
            }
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

func <-> <T> (property: BehaviorRelay<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.asObservable().bind(to: property)
    let bindToRelay = property
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { n in
            if let _n = n as? String,
                let _value = relay.value as? String,
                _n != _value {
                relay.accept(n)
            } else if let _n = n as? Int,
                let _value = relay.value as? Int,
                _n != _value {
                relay.accept(n)
            } else if let _n = n as? Double,
                let _value = relay.value as? Double,
                _n != _value {
                relay.accept(n)
            } else if let _n = n as? Float,
                let _value = relay.value as? Float,
                _n != _value {
                relay.accept(n)
            }
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}



infix operator ^-^ : DefaultPrecedence

/// 两个数组取交集
func ^-^<T> (left: [T], right: [T]) -> [T] {
    var a: [T] = []
    left.forEach { (m) in
        right.forEach { (n) in
            if m ==== n {
                a.append(m)
            }
        }
    }
    return a
}

infix operator ==== : DefaultPrecedence

/// 是否相等
func ====<T> (left: T, right: T) -> Bool {
    if let left = left as? String, let right = right as? String {
        return left == right
    } else if let left = left as? Int, let right = right as? Int {
        return left == right
    } else if let left = left as? Double, let right = right as? Double {
        return left == right
    } else if let left = left as? Float, let right = right as? Float {
        return left == right
    } else if let left = left as? CGFloat, let right = right as? CGFloat {
        return left == right
    } else if let left = left as? NSObject, let right = right as? NSObject {
        return left == right
    }
    return false
}
