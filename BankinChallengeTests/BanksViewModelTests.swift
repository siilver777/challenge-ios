//
//  BanksViewModelTests.swift
//  BankinChallengeTests
//
//  Created by Jason Pierna on 22/02/2022.
//

import XCTest
@testable import BankinChallenge

class BankViewModelTests: XCTestCase {
    
    func test_fetchData() {
        let banks = [
            Bank(countryCode: "FR", name: "LCL", logoUrl: nil),
            Bank(countryCode: "ES", name: "Santander", logoUrl: nil),
            Bank(countryCode: "FR", name: "Société Générale", logoUrl: nil),
            Bank(countryCode: "DE", name: "N26", logoUrl: nil),
            Bank(countryCode: "EN", name: "Revolut", logoUrl: nil),
            Bank(countryCode: "FR", name: "Revolut (FR)", logoUrl: nil)
        ]
        
        let mockService = MockBankService(fetchBanksResult: banks)
        let sut = BanksViewModel(currentCountryCode: "FR", service: mockService)
        
        let expectation = XCTestExpectation(description: "Fetch banks")

        sut.fetchData {
            expectation.fulfill()
            
            XCTAssertTrue(mockService.fetchBanksCalled)
            XCTAssertEqual(sut.bankSections.count, 4)
            XCTAssertEqual(sut.bankSections, [
                .init(countryCode: "FR", banks: [
                    .init(countryCode: "FR", name: "LCL", logoUrl: nil),
                    .init(countryCode: "FR", name: "Société Générale", logoUrl: nil),
                    .init(countryCode: "FR", name: "Revolut (FR)", logoUrl: nil),
                ]),
                .init(countryCode: "DE", banks: [
                    .init(countryCode: "DE", name: "N26", logoUrl: nil)
                ]),
                .init(countryCode: "EN", banks: [
                    .init(countryCode: "EN", name: "Revolut", logoUrl: nil)
                ]),
                .init(countryCode: "ES", banks: [
                    .init(countryCode: "ES", name: "Santander", logoUrl: nil)
                ])
                

            ])
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
        
    class MockBankService: BankServiceProtocol {
        
        let fetchBanksResult: [Bank]
        init(fetchBanksResult: [Bank]) {
            self.fetchBanksResult = fetchBanksResult
        }
        
        var fetchBanksCalled = false
        func fetchBanks(completion: @escaping ([Bank]) -> Void) {
            fetchBanksCalled = true
            completion(fetchBanksResult)
        }
    }
}
