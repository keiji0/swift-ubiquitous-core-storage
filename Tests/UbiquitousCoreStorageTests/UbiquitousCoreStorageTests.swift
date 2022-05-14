import XCTest
import CoreData
import AppTools
@testable import UbiquitousCoreStorage

private let device1 = InstantDevice()
private let device2 = InstantDevice()

final class UbiquitousCoreStorageTests: XCTestCase {
    
    private let container = NSPersistentContainer(name: "TestModel", managedObjectModel: UbiquitousCoreStorage.managedObjectModel)
    
    private lazy var config1: UbiquitousCoreStorage = {
        UbiquitousCoreStorage(device1, container.viewContext)
    }()
    private lazy var config2: UbiquitousCoreStorage = {
        UbiquitousCoreStorage(device2, container.viewContext)
    }()
    
    override func setUp() async throws {
        try container.loadPersistent()
        try container.dataReset()
    }
    
    override func tearDown() async throws {
    }
    
    func test_値を設定することができる() {
        try! config1.set(.ownKey, 2)
        XCTAssertEqual(try! config1.get(.ownKey), 2)
    }
    
    func test_allKeyは全てに共有される() {
        try! config1.set(.allKey, "all")
        XCTAssertEqual(try! config2.get(.allKey), "all")
    }
    
    func test_ownKeyは別のデバイスでは取得できない() {
        try! config1.set(.ownKey, "own")
        XCTAssertNil(try? config2.get(.ownKey) as String?)
    }
    
    func test_ownKeyでも全デバイスの値を取得できる() {
        try! config1.set(.ownKey, "config1")
        try! config2.set(.ownKey, "config2")
        XCTAssertEqual(Set(try! config1.gets(.ownKey)), Set(["config1", "config2"]))
    }
    
    func test_値がうまくDecodeできないとエラー() {
        try! config1.set(.ownKey, "own")
        XCTAssertNil(try? config1.get(.ownKey) as Int?)
    }
}

extension UbiquitousStorageKey {
    static let allKey =
        UbiquitousStorageKey(.all, "all")
    static let ownKey =
        UbiquitousStorageKey(.own, "own")
}
