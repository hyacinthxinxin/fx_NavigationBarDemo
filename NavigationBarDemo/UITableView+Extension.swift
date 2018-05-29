//
//  UITableView+Extension.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/28.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

fileprivate var fx_originalFrame = "fx_originalFrame"
fileprivate var fx_imageView = "fx_imageView"

extension UITableView {

    open override var contentOffset: CGPoint {
        didSet {
            if let originalFrame = objc_getAssociatedObject(self, &fx_originalFrame) as? CGRect,
                let imageView = objc_getAssociatedObject(self, &fx_imageView) as? UIImageView {
                let offsetY = contentOffset.y
                if offsetY < 0 {
                    imageView.frame = CGRect(x: offsetY / 2, y: offsetY, width: originalFrame.size.width - offsetY, height: originalFrame.size.height - offsetY)
                } else {
                    imageView.frame = originalFrame
                }
            }
        }
    }

    func fx_setHeaderImage(frame: CGRect, image: UIImage?) {
        objc_setAssociatedObject(self, &fx_originalFrame, frame, .OBJC_ASSOCIATION_RETAIN)
        let bgImageView = UIImageView(frame: frame)
        bgImageView.image = image
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFill
        insertSubview(bgImageView, at: 0)
        objc_setAssociatedObject(self, &fx_imageView, bgImageView, .OBJC_ASSOCIATION_RETAIN)
    }

}
