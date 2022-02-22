//
//  BankDatabaseService.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

protocol BankDatabaseServiceProtocol {
    func fetchBanks() -> [BankBDD]
}

class BankDatabaseService: BankDatabaseServiceProtocol {
    
    private let database = Database.shared
    
    func fetchBanks() -> [BankBDD] {
        return database.loadAll(BankBDD.self)
    }
}
