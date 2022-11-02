//
//  SLGCDTimer.swift
//  SLIKit
//
//  Created by 孙梁 on 2022/11/2.
//

import UIKit

public class SLGCDTimer: NSObject {
    private lazy var timer: DispatchSourceTimer? = {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + repeating, repeating: repeating)
        timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.handler()
            }
        }
        return timer
    }()
    
    private var repeating: DispatchTimeInterval
    private var handler: () -> Void
    
    public init(repeating: DispatchTimeInterval, handler: @escaping () -> Void) {
        self.repeating = repeating
        self.handler = handler
    }
    
    /// 计时器正在运行
    private var isCounting = false
    
    @objc public func start() {
        guard !isCounting else { return }
        timer?.schedule(deadline: .now() + repeating, repeating: repeating)
        timer?.resume()
        isCounting = true
    }
    
    @objc public func pause() {
        guard isCounting else { return }
        timer?.suspend()
        isCounting = false
    }
    
    @objc public func cancel() {
        pause()
        timer?.resume()
        timer?.cancel()
        timer = nil
    }
}
