//
//  BankServiceTests.swift
//  BankinChallengeTests
//
//  Created by Jason Pierna on 22/02/2022.
//

import XCTest
@testable import BankinChallenge
import CoreData

class BankServiceTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let container = NSPersistentContainer(name: "Database")
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { _, _ in }
        
        managedObjectContext = container.viewContext
    }
    
    func test_BankService_ReturnFromApi_WhenApiSuccess() {
        let apiObj = BanksAPI(
            resources: [
                .init(
                    countryCode: "FR",
                    parentBanks: [
                        .init(name: "LCL", logoUrl: nil)
                    ]
                )
            ]
        )
        
        let mockWS = MockWebService(fetchBanksResult: .success(apiObj))
        let mockBdd = MockBddService(fetchBanksResult: [])
        
        let sut = BankService(webService: mockWS, bddService: mockBdd)
        
        let expectation = XCTestExpectation(description: "Fetch banks from API")
        sut.fetchBanks { banks in
            expectation.fulfill()
            
            XCTAssertTrue(mockWS.fetchBanksCalled)
            XCTAssertFalse(mockBdd.fetchBanksCalled)
            
            XCTAssertEqual(banks.count, 1)
            XCTAssertEqual(banks.first!.countryCode, "FR")
            XCTAssertEqual(banks.first!.name, "LCL")
            XCTAssertNil(banks.first!.logoUrl)
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_BankService_ReturnFromDatabase_WhenApiError() {
        var bddObj = NSEntityDescription.insertNewObject(forEntityName: "BankBDD", into: managedObjectContext) as! BankBDD
        bddObj.countryCode = "FR"
        bddObj.name = "LCL"
        
        let mockWS = MockWebService(fetchBanksResult: .failure(NSError(domain: "", code: 0, userInfo: nil)))
        let mockBdd = MockBddService(fetchBanksResult: [bddObj])
        
        let sut = BankService(webService: mockWS, bddService: mockBdd)
        
        let expectation = XCTestExpectation(description: "Fetch banks from Database")
        sut.fetchBanks { banks in
            expectation.fulfill()
            
            XCTAssertTrue(mockWS.fetchBanksCalled)
            XCTAssertTrue(mockBdd.fetchBanksCalled)
            
            XCTAssertEqual(banks.count, 1)
            XCTAssertEqual(banks.first!.countryCode, "FR")
            XCTAssertEqual(banks.first!.name, "LCL")
            XCTAssertNil(banks.first!.logoUrl)
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    class MockWebService: BankApiServiceProtocol {
        
        let fetchBanksResult: Result<BanksAPI, Error>
        init(fetchBanksResult: Result<BanksAPI, Error>) {
            self.fetchBanksResult = fetchBanksResult
        }
        
        var fetchBanksCalled = false
        func fetchBanks(completion: @escaping (Result<BanksAPI, Error>) -> Void) {
            fetchBanksCalled = true
            completion(fetchBanksResult)
        }
    }
    
    class MockBddService: BankDatabaseServiceProtocol {
        
        let fetchBanksResult: [BankBDD]
        init(fetchBanksResult: [BankBDD]) {
            self.fetchBanksResult = fetchBanksResult
        }
        
        var fetchBanksCalled = false
        func fetchBanks() -> [BankBDD] {
            fetchBanksCalled = true
            return fetchBanksResult
        }
    }
    
}
