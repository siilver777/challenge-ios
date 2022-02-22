//
//  Observable.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

@propertyWrapper class Observable<T> {
    var wrappedValue: T {
        didSet {
            queue.async { [unowned self] in
                self.listener?(wrappedValue)
            }
        }
    }
    
    private let queue: DispatchQueue
    private var listener: ((T) -> Void)?
    
    init(wrappedValue: T, on queue: DispatchQueue = .main) {
        self.wrappedValue = wrappedValue
        self.queue = queue
    }
    
    var projectedValue: Observable<T> { self }
    
    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
    }
}
