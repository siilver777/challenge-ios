//
//  BanksViewModel.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

class BanksViewModel {
    
    private let service: BankServiceProtocol
    private let currentCountryCode: String?
    
    init(currentCountryCode: String? = Locale.current.regionCode, service: BankServiceProtocol = BankService()) {
        self.service = service
        self.currentCountryCode = currentCountryCode
    }
    
    // MARK: - Outputs
    
    @Observable var bankSections = [BankSection]()
    
    func fetchData(completion: @escaping () -> Void) {
        service.fetchBanks { [weak self] in
            let sections = Dictionary(grouping: $0, by: { bank in
                bank.countryCode
            })
            
            self?.bankSections = sections.map { key, value in
                BankSection(
                    countryCode: key,
                    banks: value
                )
            }
            .sorted(by: { a, b in
                if a.countryCode == self?.currentCountryCode ?? "" {
                    return true
                }
                
                if b.countryCode == self?.currentCountryCode ?? "" {
                    return false
                }
                
                return a.countryCode < b.countryCode
            })
            
            completion()
        }
    }
}

struct BankSection: Equatable {
    let countryCode: String
    let banks: [Bank]
}
