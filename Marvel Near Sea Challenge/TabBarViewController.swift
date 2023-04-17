//
//  TabBarViewController.swift
//  Marvel Near Sea Challenge
//
//  Created by Alex Faria on 17/04/2023.
//

import UIKit

class TabBar: UITabBarController {

    enum Constants {

        static let heroListViewControllerTittle = "Heroes"
        static let heroListViewControllerIcon = "person.crop.rectangle.stack.fill"
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .red
        setupViewControllers()
    }

    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage) -> UIViewController {

        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title

        return navController
    }

    private func setupViewControllers() {
        
        viewControllers = [

            createNavController(for: HeroListViewController(),
                                   title: "Constants.heroListViewControllerTittle",
                                   image: UIImage(systemName: Constants.heroListViewControllerIcon)!),
        ]
    }

}
