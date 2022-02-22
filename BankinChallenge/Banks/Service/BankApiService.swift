//
//  ApiService.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation

protocol BankApiServiceProtocol {
    func fetchBanks(completion: @escaping (Result<BanksAPI, Error>) -> Void)
}

class BankApiService: BankApiServiceProtocol {
    
    private let clientId = "dd6696c38b5148059ad9dedb408d6c84"
    private let clientSecret = "56uolm946ktmLTqNMIvfMth4kdiHpiQ5Yo8lT4AFR0aLRZxkxQWaGhLDHXeda6DZ"
    private let baseURL = "https://sync.bankin.com/v2"
    
    func fetchBanks(completion: @escaping (Result<BanksAPI, Error>) -> Void) {
        let urlString = baseURL + "/banks?limit=100&client_id=\(clientId)&client_secret=\(clientSecret)"
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.addValue("2018-06-15", forHTTPHeaderField: "Bankin-Version")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                do {
                    let banks = try JSONDecoder().decode(BanksAPI.self, from: data)
                    completion(.success(banks))
                } catch {
                    // parsing error
                    completion(.failure(error))
                }
            } else if let err = err {
                // error
                completion(.failure(err))
            } else {
                // unknown error
                print("Unknown error")
            }
        }.resume()
    }
}
