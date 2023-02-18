//
//  Reference.swift
//  
//
//  Created by Jaehong Kang on 2023/02/18.
//

import Dispatch

@propertyWrapper
final public class Reference<Value> {
    private var _value: Value

    private lazy var _queue = DispatchQueue(
        label: String(reflecting: self),
        qos: .unspecified,
        attributes: [.concurrent],
        autoreleaseFrequency: .workItem,
        target: nil
    )

    public var wrappedValue: Value {
        get {
            _queue.sync {
                _value
            }
        }
        set {
            modify { value in
                value = newValue
            }
        }
    }

    public init(_ wrappedValue: Value) {
        self._value = wrappedValue

        _ = _queue // For preventing date race condition.
    }

    public func modify(_ modifier: @escaping (inout Value) -> Void) {
        _queue.async(
            qos: .unspecified,
            flags: [.inheritQoS, .assignCurrentContext, .barrier]
        ) { [weak self] in
            guard let self = self else { return }

            modifier(&self._value)
        }
    }
}

#if swift(>=5.5)
extension Reference: @unchecked Sendable where Value: Sendable { }
#endif

extension Reference: Equatable where Value: Equatable {
    public static func == (lhs: Reference<Value>, rhs: Reference<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Reference: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension Reference: Comparable where Value: Comparable {
    public static func < (lhs: Reference<Value>, rhs: Reference<Value>) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}
