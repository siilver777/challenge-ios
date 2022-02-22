//
//  Banks.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

struct BanksAPI: Codable {
    let resources: [Resource]
    
    struct Resource: Codable {
        let countryCode: String
        let parentBanks: [Bank]

        enum CodingKeys: String, CodingKey {
            case countryCode = "country_code"
            case parentBanks = "parent_banks"
        }

        struct Bank: Codable {
            let name: String
            let logoUrl: String?

            enum CodingKeys: String, CodingKey {
                case name
                case logoUrl = "logo_url"
            }
        }
    }
}
