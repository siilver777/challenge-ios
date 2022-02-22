//
//  BankBDD+Web.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation
import CoreData

extension BanksAPI {
    
    func saveTo(database: Database) {
        let banksBDD: [BankBDD] = resources.flatMap { res in
            res.parentBanks.compactMap { bankApi in
                let bankBdd = NSEntityDescription.insertNewObject(forEntityName: "BankBDD", into: database.context) as? BankBDD
                bankBdd?.countryCode = res.countryCode
                bankBdd?.name = bankApi.name
                bankBdd?.logoUrl = bankApi.logoUrl
                
                return bankBdd
            }
        }
        
        database.save()
    }
}
