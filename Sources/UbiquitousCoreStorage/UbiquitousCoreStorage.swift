//
//  UbiquitousCoreStorage.swift
//
//
//  Created by keiji0 on 2022/04/09
//
//

import Foundation
import CoreData
import AppTools
import os

/// デバイス全体で共有される設定
/// デバイス固有と全デバイスでの共有設定
public final class UbiquitousCoreStorage : UbiquitousStorage {
    
    /// オブジェクトモデルを取得
    public static var managedObjectModel: NSManagedObjectModel {
        ManagedObjectModelContainer.shared.model("Model", Bundle.module)
    }
    
    /// 生成
    /// - Parameters:
    ///   - device: 生成元のデバイス
    ///   - context: NSManagedObjectContextを渡す
    public init(_ device: some Device, _ context: NSManagedObjectContext) {
        self.storage = Storage(context)
        self.device = device
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    // MARK: - UbiquitousStorage conform
    
    /// キーに格納された値を取得
    public func get<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> Value? {
        guard let value = storage.getConfigure(deviceKey(key.sharedType), key.key) else {
            return nil
        }
        return try decoder.decode(Value.self, from: value)
    }
    
    /// 全てのデバイスのキーを取得
    public func gets<Value: Decodable>(_ key: UbiquitousStorageKey) throws -> [Value] {
        assert(key.sharedType == .own)
        return try storage.getConfigures(key.key).map {
            try decoder.decode(Value.self, from: $0.1)
        }
    }
    
    /// Endableな値を格納
    public func set<Value: Encodable>(_ key: UbiquitousStorageKey, _ value: Value) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        try storage.begin {
            storage.setConfigure(deviceKey(key.sharedType), key.key, data)
        }
    }
    
    // MARK: - Private
    
    private let storage: Storage
    private let device: any Device
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private func deviceKey(_ deviceKey: UbiquitousStorageKey.SharedType) -> UUID {
        switch deviceKey {
        case .all:
            return UUID.null
        case .own:
            return device.id
        }
    }
}
