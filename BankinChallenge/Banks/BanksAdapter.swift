//
//  BanksAdapter.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation
import UIKit.UITableView

protocol BanksAdapterDelegate {
    func sectionTitle(for section: Int) -> String?
    func numberOfSections() -> Int
    func numberOfRows(for section: Int) -> Int
    func item(for indexPath: IndexPath) -> Bank?
}

class BanksAdapter: NSObject {
    let delegate: BanksAdapterDelegate
    
    init(delegate: BanksAdapterDelegate) {
        self.delegate = delegate
    }
}

extension BanksAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate.sectionTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell", for: indexPath)
        
        let item = delegate.item(for: indexPath)
        cell.textLabel?.text = item?.name
        
        return cell
    }
}
