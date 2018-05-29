//
//  ViewController1.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/29.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Third"
    }

}

extension ThirdViewController: FXNavigationBarConfigurationProvider {

    func fx_navigationBarStyle() -> UIBarStyle {
        return .black
    }

    func fx_navigationBackgroundColor() -> UIColor {
        return UIColor.green
    }

    func fx_navigationBarTintColor() -> UIColor {
        return UIColor.white
    }

}
