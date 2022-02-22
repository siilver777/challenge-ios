//
//  BankService.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

protocol BankServiceProtocol {
    func fetchBanks(completion: @escaping ([Bank]) -> Void)
}

class BankService: BankServiceProtocol {
    private let webService: BankApiServiceProtocol
    private let bddService: BankDatabaseServiceProtocol
    
    init(webService: BankApiServiceProtocol = BankApiService(), bddService: BankDatabaseServiceProtocol = BankDatabaseService()) {
        self.webService = webService
        self.bddService = bddService
    }
    
    func fetchBanks(completion: @escaping ([Bank]) -> Void) {
        webService.fetchBanks { apiResult in
            
            switch apiResult {
            case .success(let banksFromApi):
                let banks = banksFromApi.resources.flatMap { res in
                    res.parentBanks.map { Bank(from: $0, resource: res) }
                }
                
                completion(banks)
                banksFromApi.saveTo(database: .shared)
            case .failure(let error):
                print(error)

                // Database fallback
                let banksFromDatabase = self.bddService.fetchBanks()
                
                let banks = banksFromDatabase.map(Bank.init)
                completion(banks)
            }
        }
    }
}
