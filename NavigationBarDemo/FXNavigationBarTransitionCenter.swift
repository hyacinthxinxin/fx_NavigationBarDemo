//
//  FXNavigationBarTransitionCenter.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/28.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

class FXNavigationBarTransitionCenter: NSObject {

    fileprivate lazy var fromViewControllerFakeBar: UIToolbar = { [unowned self] in
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.delegate = self
        return toolbar
        }()

    fileprivate lazy var toViewControllerFakeBar: UIToolbar = { [unowned self] in
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.delegate = self
        return toolbar
        }()

    fileprivate var defaultNavigationBarConfiguration: FXNavigationBarConfiguration?

    fileprivate var isTransitioningNavigationBar: Bool = false

    convenience init(navigationBarConfigurationProvider: FXNavigationBarConfigurationProvider) {
        self.init()
        defaultNavigationBarConfiguration = FXNavigationBarConfiguration(provider: navigationBarConfigurationProvider)
    }

    fileprivate func removeFakeBars() {
        fromViewControllerFakeBar.removeFromSuperview()
        toViewControllerFakeBar.removeFromSuperview()
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let defaultNavigationBarConfiguration = self.defaultNavigationBarConfiguration else {
            return
        }
        let currentNavigationBarConfiguration = navigationController.navigationBar.currentNavigationBarConfiguration ?? defaultNavigationBarConfiguration
        var showNavigationBarConfiguration = defaultNavigationBarConfiguration
        if let provider = viewController as? FXNavigationBarConfigurationProvider {
            showNavigationBarConfiguration = FXNavigationBarConfiguration(provider: provider)
        }
        var transparentNavigationBarConfiguration: FXNavigationBarConfiguration?
        if currentNavigationBarConfiguration != showNavigationBarConfiguration {
            transparentNavigationBarConfiguration = FXNavigationBarConfiguration(barStyle: showNavigationBarConfiguration.barStyle, tintColor: showNavigationBarConfiguration.tintColor, backgroundColor: UIColor.clear)
        }
        navigationController.navigationBar.fx_apply(transparentNavigationBarConfiguration ?? showNavigationBarConfiguration)
        navigationController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            if currentNavigationBarConfiguration != showNavigationBarConfiguration {
                UIView.setAnimationsEnabled(false)
                if let fromViewController = context.viewController(forKey: .from),
                    let fakeBarFrame = fromViewController.fx_fakeBarFrame(for: navigationController.navigationBar) {
                    self.fromViewControllerFakeBar.fx_apply(currentNavigationBarConfiguration)
                    self.fromViewControllerFakeBar.frame = fakeBarFrame
                    fromViewController.view.addSubview(self.fromViewControllerFakeBar)
                }
                if let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
                    let fakeBarFrame = toViewController.fx_fakeBarFrame(for: navigationController.navigationBar) {
                    self.toViewControllerFakeBar.fx_apply(showNavigationBarConfiguration)
                    self.toViewControllerFakeBar.frame = fakeBarFrame
                    toViewController.view.addSubview(self.toViewControllerFakeBar)
                }
                UIView.setAnimationsEnabled(true)
            }
        }, completion: { (context) in
            if context.isCancelled {
                self.removeFakeBars()
                navigationController.navigationBar.fx_apply(currentNavigationBarConfiguration)
            }
            self.isTransitioningNavigationBar = false
        })
        if #available(iOS 10, *) {
            navigationController.transitionCoordinator?.notifyWhenInteractionChanges({ (context) in
                if context.isCancelled {
                    navigationController.navigationBar.fx_apply(currentNavigationBarConfiguration)
                }
            })
        } else {
            navigationController.transitionCoordinator?.notifyWhenInteractionEnds({ (context) in
                if context.isCancelled {
                    navigationController.navigationBar.fx_apply(currentNavigationBarConfiguration)
                }
            })
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        removeFakeBars()
        guard let defaultNavigationBarConfiguration = self.defaultNavigationBarConfiguration else {
            return
        }
        var showNavigationBarConfiguration = defaultNavigationBarConfiguration
        if let provider = viewController as? FXNavigationBarConfigurationProvider {
            showNavigationBarConfiguration = FXNavigationBarConfiguration(provider: provider)
        }
        navigationController.navigationBar.fx_apply(showNavigationBarConfiguration)
        isTransitioningNavigationBar = false
    }

}

extension FXNavigationBarTransitionCenter: UIToolbarDelegate {

    internal func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

}
