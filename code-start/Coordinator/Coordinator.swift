//
//  Coordinator.swift
//  code-start
//
//  Created by Тимур Калимуллин on 13.12.2023.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    func start()
    func finish()
}

final class AppCoordinator: NSObject, CoordinatorProtocol {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainModuleBuilder = MainModuleBuilder()
        //let mainViewController = mainModuleBuilder.build(moduleOutput: self)
        let mainViewController = ViewController()
        mainViewController.presenter.moduleOutputDelegate = self
        //self.navigationController.pushViewController(mainViewController, animated: true)
        self.navigationController.pushViewController(mainViewController, animated: true)
    }

    func finish() {
    }
}

extension AppCoordinator: MainModuleOutputDelegate {
    func profileIconTapped() {
        let profileViewContoroller = ProfileViewController()
        self.navigationController.pushViewController(profileViewContoroller, animated: true)
    }

    func courseBlockTapped(courseName: String) {
        let questionViewController = QuestionViewController()
        questionViewController.presenter.coordinatorDelegate = self
        questionViewController.setupCourseName(courseName)
        self.navigationController.pushViewController(questionViewController, animated: true)
    }
}

protocol QuestionModuleOutputDelegate: AnyObject {
    func backButtonTapped()
    func progressBarTapped(destinatedVC: QuestionListViewController)
}

extension AppCoordinator: QuestionModuleOutputDelegate {
    func backButtonTapped() {
        self.navigationController.popViewController(animated: true)
    }

    func progressBarTapped(destinatedVC: QuestionListViewController) {
        self.navigationController.present(destinatedVC, animated: false)
    }
}
