//
//  BanksViewController.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import UIKit

class BanksViewController: UIViewController {

    weak var coordinator: Coordinator?
    private let viewModel = BanksViewModel()
    private var adapter: BanksAdapter?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "BankCell")
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Banks"
        
        adapter = BanksAdapter(delegate: self)
        tableView.dataSource = adapter
        tableView.refreshControl = refreshControl
        
        viewModel.$bankSections.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        refresh()
    }
    
    @objc private func refresh() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

extension BanksViewController: BanksAdapterDelegate {
    func numberOfSections() -> Int {
        return viewModel.bankSections.count
    }
    
    func sectionTitle(for section: Int) -> String? {
        guard viewModel.bankSections.count > section else { return nil }
        return viewModel.bankSections[section].countryCode
    }
    
    func numberOfRows(for section: Int) -> Int {
        guard viewModel.bankSections.count > section else { return 0 }
        return viewModel.bankSections[section].banks.count
    }
    
    func item(for indexPath: IndexPath) -> Bank? {
        guard viewModel.bankSections.count > indexPath.section else { return nil }
        let section = viewModel.bankSections[indexPath.section]
        
        guard section.banks.count > indexPath.row else { return nil }
        return section.banks[indexPath.row]
    }
}
