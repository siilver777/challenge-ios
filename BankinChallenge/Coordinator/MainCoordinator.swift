//
//  MainCoordinator.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = BanksViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
