//
//  Notes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let splitViewController = window?.rootViewController as? UISplitViewController else {
            return
        }
        splitViewController.delegate = self
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        NoteContainerManager.shared.saveContext()
    }

}

extension SceneDelegate: UISplitViewControllerDelegate {
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column)
    -> UISplitViewController.Column {
        return .primary
    }

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
