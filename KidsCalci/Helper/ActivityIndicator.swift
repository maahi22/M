//
//  ActivityIndicator.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 14/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

struct ActivityIndicator {
    
    let viewForActivityIndicator = UIView()
    let view: UIView
    let navigationController: UINavigationController?
    let tabBarController: UITabBarController?
    let activityIndicatorView = UIActivityIndicatorView()
    let loadingTextLabel = UILabel()
    
    var navigationBarHeight: CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0.0 }
    var tabBarHeight: CGFloat { return tabBarController?.tabBar.frame.height ?? 0.0 }
    
    func showActivityIndicator(_ loadingText :String) {
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.white
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height - tabBarHeight - navigationBarHeight) / 2.0)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = loadingText
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .gray
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        viewForActivityIndicator.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}