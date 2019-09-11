//
//  MainTabBarController.swift
//  PhotosLibrary
//
//  Created by dewill on 22/08/2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photosCollecionVC =  PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        viewControllers = [
            generateNavigationController(rootViewController: photosCollecionVC, title: "Image", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(rootViewController: ViewController(), title: "Favourite", image: #imageLiteral(resourceName: "heart"))]
        
    }
    
    
    private func generateNavigationController(rootViewController : UIViewController, title: String, image: UIImage) -> UINavigationController {
        let nc = UINavigationController(rootViewController: rootViewController)
        nc.tabBarItem.title = title
        nc.tabBarItem.image = image
        return nc
    }
}
