//
//  DelayScheduler.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public protocol DelaySchedulerProtocol: AnyObject {
    func schedule(after seconds: TimeInterval, action: @escaping () -> Void)
    func cancelAll()
}

public final class AsyncDelayScheduler: DelaySchedulerProtocol {
    private var pendingTasks: [UUID: DispatchWorkItem] = [:]
    private let lock = NSLock()
    
    public init() {}
    
    public func schedule(after seconds: TimeInterval, action: @escaping () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        let taskId = UUID()
        let workItem = DispatchWorkItem { [weak self] in
            action()
            self?.removeTask(id: taskId)
        }
        
        pendingTasks[taskId] = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem)
    }
    
    public func cancelAll() {
        lock.lock()
        defer { lock.unlock() }
        
        for item in pendingTasks.values {
            item.cancel()
        }
        pendingTasks.removeAll()
    }
    
    private func removeTask(id: UUID) {
        lock.lock()
        defer { lock.unlock() }
        pendingTasks.removeValue(forKey: id)
    }
}

public final class ImmediateDelayScheduler: DelaySchedulerProtocol {
    public private(set) var scheduleCallCount = 0
    public var executeImmediately = true
    private var queuedActions: [() -> Void] = []
    
    public init(executeImmediately: Bool = true) {
        self.executeImmediately = executeImmediately
    }
    
    public func schedule(after seconds: TimeInterval, action: @escaping () -> Void) {
        scheduleCallCount += 1
        if executeImmediately {
            action()
        } else {
            queuedActions.append(action)
        }
    }
    
    public func flush() {
        let actions = queuedActions
        queuedActions.removeAll()
        for action in actions {
            action()
        }
    }
    
    public func cancelAll() {
        queuedActions.removeAll()
    }
}
