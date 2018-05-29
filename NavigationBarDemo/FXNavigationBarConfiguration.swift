//
//  FXBarConfiguration.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/28.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

protocol FXNavigationBarConfigurationProvider {
    func fx_navigationBarStyle() -> UIBarStyle
    func fx_navigationBarTintColor() -> UIColor
    func fx_navigationBackgroundColor() -> UIColor
}

struct FXNavigationBarConfiguration {

    var barStyle: UIBarStyle = .default
    var tintColor: UIColor = UIColor.blue
    var backgroundColor: UIColor = UIColor.white

    init(barStyle: UIBarStyle, tintColor: UIColor, backgroundColor: UIColor) {
        self.barStyle = barStyle
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    init(provider: FXNavigationBarConfigurationProvider) {
        self.init(barStyle: provider.fx_navigationBarStyle(), tintColor: provider.fx_navigationBarTintColor(), backgroundColor: provider.fx_navigationBackgroundColor())
    }
    
}

extension FXNavigationBarConfiguration: Equatable {

    static func == (lhs: FXNavigationBarConfiguration, rhs: FXNavigationBarConfiguration) -> Bool {
        return lhs.barStyle == rhs.barStyle && lhs.tintColor == rhs.tintColor && lhs.backgroundColor == rhs.backgroundColor
    }
    
}

extension UIImage {
// 纯色图片 默认大小 {1, 1}
    static func fx_pureColorImage(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: max(0.5, size.width), height: max(0.5, size.height)), false, 0)
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

fileprivate var fx_currentNavigationBarConfiguration = "fx_currentNavigationBarConfiguration"

extension UINavigationBar {

    var currentNavigationBarConfiguration: FXNavigationBarConfiguration? {
        get {
            return objc_getAssociatedObject(self, &fx_currentNavigationBarConfiguration) as? FXNavigationBarConfiguration
        }
        set {
            objc_setAssociatedObject(self, &fx_currentNavigationBarConfiguration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    fileprivate var fx_backgroundView: UIView? {
        return value(forKey: "_backgroundView") as? UIView
    }

    func fx_apply(_ configuration: FXNavigationBarConfiguration) {
        barStyle = configuration.barStyle
        isTranslucent = true
        tintColor = configuration.tintColor
        if configuration.backgroundColor == UIColor.clear {
            fx_backgroundView?.alpha = 0
        } else {
            fx_backgroundView?.alpha = 1
        }
        setBackgroundImage(UIImage.fx_pureColorImage(with: configuration.backgroundColor), for: .default)
        shadowImage = UIImage()
        currentNavigationBarConfiguration = configuration
    }

}

extension UIToolbar {

    func fx_apply(_ configuration: FXNavigationBarConfiguration) {
        barStyle = configuration.barStyle
        isTranslucent = true
        tintColor = configuration.tintColor
        setBackgroundImage(UIImage.fx_pureColorImage(with: configuration.backgroundColor), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

}


extension UIViewController {

    func fx_navigationBar() -> UINavigationBar? {
        if self is UINavigationController {
            return (self as? UINavigationController)?.navigationBar
        }
        return self.navigationController?.navigationBar
    }

    func fx_refreshNavigationBarStyle() {
        if let provider = self as? FXNavigationBarConfigurationProvider {
            fx_navigationBar()?.fx_apply(FXNavigationBarConfiguration(provider: provider))
        }
    }

    func fx_fakeBarFrame(for navigationBar: UINavigationBar) -> CGRect? {
        guard let backgroundView = navigationBar.value(forKey: "_backgroundView") as? UIView,
            var frame = backgroundView.superview?.convert(backgroundView.frame, to: self.view) else {
                return nil
        }
        frame.origin.x = view.bounds.origin.x
        return frame
    }

}
