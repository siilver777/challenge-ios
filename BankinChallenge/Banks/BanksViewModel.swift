//
//  BanksViewModel.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

class BanksViewModel {
    
    private let service: BankServiceProtocol
    
    init(service: BankServiceProtocol = BankService()) {
        self.service = service
    }
    
    // MARK: - Outputs
    
    @Observable var bankSections = [BankSection]()
    
    func fetchData() {
        service.fetchBanks { [weak self] in
            let sections = Dictionary(grouping: $0, by: { bank in
                bank.countryCode
            })
            
            self?.bankSections = sections.map { key, value in
                BankSection(countryCode: key, banks: value)
            }
            .sorted(by: { a, b in
                if a.countryCode == Locale.current.regionCode {
                    return true
                }
                
                return a.countryCode < b.countryCode
            })
        }
    }
}

struct BankSection {
    let countryCode: String
    let banks: [Bank]
}
