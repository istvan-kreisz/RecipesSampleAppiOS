//
//  NetworkMonitor.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/16/23.
//

import Foundation
import Combine
import Network

protocol NetworkMonitor {
    var isReachable: Bool { get }
    var isReachableListener: AnyPublisher<Bool, Never> { get }
    func startMonitoring()
    func stopMonitoring()
}

enum ReachabilityError: Error {
    case offline
}

class RealNetworkMonitor: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let statusValueSubject = CurrentValueSubject<NWPath.Status, Never>(.requiresConnection)

    var isReachable: Bool { statusValueSubject.value == .satisfied }
    var isReachableListener: AnyPublisher<Bool, Never> {
        statusValueSubject.map { $0 == .satisfied }.eraseToAnyPublisher()
    }
    
//    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async { [weak self] in
                self?.statusValueSubject.send(path.status)
//                self?.isReachableOnCellular = path.isExpensive
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
