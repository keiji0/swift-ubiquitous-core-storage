//
//  UbiquitousFakeStorageTests.swift
//  
//  
//  Created by keiji0 on 2023/01/29
//  
//

import XCTest
import AppTools
@testable import UbiquitousCoreStorage

final class UbiquitousMemoryStorageTests : XCTestCase {
    
    private let deviceA = InstantDevice()
    private let deviceB = InstantDevice()
    private let provider = UbiquitousFakeStorageProvider()
    private let ownKeyA = UbiquitousStorageKey(.own, "a")
    private let ownKeyB = UbiquitousStorageKey(.own, "b")
    private let allKeyA = UbiquitousStorageKey(.all, "a")
    private let allKeyB = UbiquitousStorageKey(.all, "B")
    
    func test_デバイスごとのStorageを作ることができる() {
        let storageA = provider.storage(device: deviceA)
        let storageB = provider.storage(device: deviceB)
        XCTAssertTrue(storageA !== storageB)
    }
    
    func test_同一デバイスは同じStorageを参照する() {
        let storageA = provider.storage(device: deviceA)
        let storageADash = provider.storage(device: deviceA)
        XCTAssertTrue(storageA === storageADash)
    }
    
    func test_ShareTypeAllの値を変更すると他のデバイスのストレージに反映される() {
        let storageA = provider.storage(device: deviceA)
        let storageB = provider.storage(device: deviceB)
        try! storageA.set(allKeyA, 20)
        XCTAssertEqual(try! storageB.get(allKeyA), 20)
    }
    
    func test_ShareTypeAllの値を変更すると他のデバイスの値が上書きされる() {
        let storageA = provider.storage(device: deviceA)
        let storageB = provider.storage(device: deviceB)
        try! storageA.set(allKeyA, 20)
        try! storageB.set(allKeyA, 8)
        XCTAssertEqual(try! storageA.get(allKeyA), 8)
    }
    
    func test_ShareTypeOwnの値を変更しても他のデバイスには反映されない() {
        let storageA = provider.storage(device: deviceA)
        let storageB = provider.storage(device: deviceB)
        try! storageA.set(ownKeyA, 20)
        XCTAssertNil(try! storageB.get(Int.self, ownKeyA))
    }
    
    func test_ShareTypeOwnで全てのデバイスの値を取得できる() {
        let storageA = provider.storage(device: deviceA)
        let storageB = provider.storage(device: deviceB)
        try! storageA.set(ownKeyA, "a")
        try! storageB.set(ownKeyA, "b")
        XCTAssertTrue(Set(try! storageA.gets(String.self, ownKeyA)).isSubset(of: ["a", "b"]))
    }
}
