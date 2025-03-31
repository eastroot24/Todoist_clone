//
//  UIApplication+Extension.swift
//  Todoist_clone
//  Created by eastroot on 3/4/25.
//

import UIKit

extension UIApplication {
    // ✅ 현재 화면에서 최상위 UIViewController 가져오기
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow }?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabBarController = controller as? UITabBarController {
            return topViewController(controller: tabBarController.selectedViewController)
        }
        
        if let presentedController = controller?.presentedViewController {
            return topViewController(controller: presentedController)
        }
        
        return controller
    }
}

