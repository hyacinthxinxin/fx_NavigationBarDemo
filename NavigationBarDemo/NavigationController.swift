//
//  NavigationController.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/29.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var transitionCenter: FXNavigationBarTransitionCenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate  = self
        transitionCenter = FXNavigationBarTransitionCenter(navigationBarConfigurationProvider: self)
    }

}

extension NavigationController: FXNavigationBarConfigurationProvider {


    func fx_navigationBarStyle() -> UIBarStyle {
        return .default
    }

    func fx_navigationBackgroundColor() -> UIColor {
        return UIColor.orange
    }

    func fx_navigationBarTintColor() -> UIColor {
        return UIColor.white
    }

}


extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        transitionCenter.navigationController(navigationController, willShow: viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        transitionCenter.navigationController(navigationController, didShow: viewController, animated: animated)
    }
}
