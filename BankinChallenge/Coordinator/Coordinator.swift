//
//  Coordinator.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
