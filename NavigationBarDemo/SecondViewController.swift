//
//  ViewController.swift
//  NavigationBarDemo
//
//  Created by 范新 on 2018/5/25.
//  Copyright © 2018年 范新. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    lazy var tableView: UITableView = { [unowned self] in
        $0.backgroundColor = UIColor.darkGray
        $0.separatorStyle = .singleLine
        $0.rowHeight = UITableViewAutomaticDimension
        $0.estimatedRowHeight = 62
        $0.dataSource = self
        $0.delegate = self
        $0.tableFooterView = UIView()
        return $0
    }(UITableView(frame: CGRect.zero, style: .plain))

    var gradientProgress: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second"
        setupTableView()
    }

    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let headerFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 210)
        let headerView = UIView(frame: headerFrame)
        tableView.tableHeaderView = headerView
        let image = UIImage(named: "test.jpg")
        tableView.fx_setHeaderImage(frame: headerFrame, image: image)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section) ==>> \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowThird", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.y + scrollView.contentInset.top
        var _gradientProgress = min(1, max(0, progress / 64))
        _gradientProgress = _gradientProgress * _gradientProgress * _gradientProgress * _gradientProgress
        if _gradientProgress != gradientProgress {
            gradientProgress = _gradientProgress
            fx_refreshNavigationBarStyle()
        }
    }

}

extension SecondViewController: FXNavigationBarConfigurationProvider {

    func fx_navigationBarStyle() -> UIBarStyle {
        if gradientProgress < 0.5 {
            return .default
        } else {
            return .black
        }
    }

    func fx_navigationBackgroundColor() -> UIColor {
        return UIColor.blue.withAlphaComponent(gradientProgress)
    }

    func fx_navigationBarTintColor() -> UIColor {
        return UIColor(white: gradientProgress, alpha: 1)
    }

}




