//
//  Alert.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

enum Alert {
    static func bookmarkNews_success(){
        alertUser(title: "Saved", message: "You have successfully bookmarked this news")
    }
    static func bookmarkNews_failed(){
        alertUser(title: "Error", message: "Failed to bookmark this news")
    }
    static func undo_bookmarkNews_success(){
        alertUser(title: "Deleted", message: "You have successfully remove this news from Bookmarks")
    }
    static func undo_bookmarkNews_failed(){
        alertUser(title: "Error", message: "Failed to delete this news from Bookmarks")
    }
}

func alertUser(title: String, message: String, dismissText: String = "OK", completion: ((UIAlertAction)->())? = nil){
    let alertErrorController = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
        title: dismissText,
        style: .default,
        handler: completion
    )
    
    alertErrorController.addAction(dismiss)
    UIApplication.topViewController()?.present(alertErrorController, animated: true, completion: nil)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class LoadingAlert {
    static func getLoadingAlert() -> UIAlertController {
        let loadingAlertController = UIAlertController.init(title: nil, message: "Loading..", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: loadingAlertController.view.bounds)
        
        indicator.frame.origin.x = -60
        indicator.style = .gray
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingAlertController.view.addSubview(indicator)
        indicator.startAnimating()
        
        return loadingAlertController
    }
    
    static func show(vc:UIViewController) {
        vc.navigationController?.present(getLoadingAlert(), animated: true, completion: nil)
    }
    
    static func dismiss() {
        getLoadingAlert().dismiss(animated: true, completion: nil)
    }
}
