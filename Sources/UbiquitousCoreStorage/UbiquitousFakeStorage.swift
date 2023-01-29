//
//  UbiquitousFakeStorage.swift
//  
//  
//  Created by keiji0 on 2023/01/29
//  
//

import Foundation
import AppTools

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()

/// メモリ上で動作するUbiquitousStorageを提供してくれるクラス
public final class UbiquitousFakeStorageProvider {
    fileprivate var allStore = [UbiquitousStorageKey.Key: Data]()
    fileprivate var deviceStorages = [UUID: UbiquitousFakeStorage]()
    
    public func storage(device: some Device) -> some UbiquitousStorage {
        if let deviceStorage  = deviceStorages[device.id] {
            return deviceStorage
        }
        let storage = UbiquitousFakeStorage(self)
        deviceStorages[device.id] = storage
        return storage
    }
}

/// メモリ上で動作するUbiquitousStorage
public final class UbiquitousFakeStorage : UbiquitousStorage {
    private unowned let provider: UbiquitousFakeStorageProvider
    fileprivate var store = [UbiquitousStorageKey.Key: Data]()
    
    fileprivate init(_ provider: UbiquitousFakeStorageProvider) {
        self.provider = provider
    }
    
    public func get<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> Value? {
        switch key.sharedType {
        case .all:
            return try get(provider.allStore, key)
        case .own:
            return try get(store, key)
        }
    }
    
    public func gets<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> [Value] {
        assert(key.sharedType == .own)
        return try provider.deviceStorages.compactMap {
            try get($0.value.store, key)
        }
    }

    public func set<Value: Encodable>(_ key: UbiquitousStorageKey, _ value: Value) throws {
        let data = try encoder.encode(value)
        switch key.sharedType {
        case .all:
            provider.allStore[key.key] = data
        case .own:
            store[key.key] = data
        }
    }
    
    private func get<Value: Decodable>(_ store: [UbiquitousStorageKey.Key: Data], _ key: UbiquitousStorageKey) throws -> Value? {
        guard let data = store[key.key] else {
            return nil
        }
        return try decoder.decode(Value.self, from: data)
    }
}
