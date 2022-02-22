//
//  Bank.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

struct Bank: Equatable {
    let countryCode: String
    let name: String
    let logoUrl: String?
    
    init(countryCode: String, name: String, logoUrl: String?) {
        self.countryCode = countryCode
        self.name = name
        self.logoUrl = logoUrl
    }
    
    init(from web: BanksAPI.Resource.Bank, resource: BanksAPI.Resource) {
        self.countryCode = resource.countryCode
        self.name = web.name
        self.logoUrl = web.logoUrl
    }
    
    init(from bdd: BankBDD) {
        self.countryCode = bdd.countryCode ?? ""
        self.name = bdd.name ?? ""
        self.logoUrl = bdd.logoUrl
    }
}
