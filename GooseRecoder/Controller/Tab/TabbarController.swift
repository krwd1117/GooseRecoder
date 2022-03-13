//
//  TabbarController.swift
//  GooseRecoder
//
//  Created by Jeongwan Kim on 2022/03/09.
//

import UIKit

class TabbarController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    // MARK: - Configure
    func configureViewController() {
        self.delegate = self
        
//        let layout = UICollectionViewFlowLayout()
        
        let main = templateNavigationController(
            unselectedImage: UIImage(systemName: "house")!,
            selectedImage: UIImage(systemName: "house.fill")!,
            rootViewController: MainViewController()
        )
        
        let setting = templateNavigationController(
            unselectedImage: UIImage(systemName: "gearshape")!,
            selectedImage: UIImage(systemName: "gearshape.fill")!,
            rootViewController: SettingTableViewController()
        )
        
        viewControllers = [main, setting]
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = .white
        
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage,rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
    
    
}

extension TabbarController: UITabBarControllerDelegate {
    
}
