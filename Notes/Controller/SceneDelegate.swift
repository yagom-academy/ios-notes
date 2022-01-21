//
//  Notes - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let splitViewController = window?.rootViewController as? UISplitViewController,
              let noteTableViewController = (splitViewController.viewControllers.first as? UINavigationController)?.viewControllers.first as? NotesTableViewController,
              let noteNavi = (splitViewController.viewControllers.last as? UINavigationController),
              let noteViewController = (splitViewController.viewControllers.last as? UINavigationController)?.viewControllers.first as?  NoteViewController else {
            return
        }
        noteTableViewController.noteViewController = noteViewController
        noteViewController.delegate = noteTableViewController
        noteTableViewController.noteNavigation = noteNavi
        splitViewController.delegate = self
        
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(1639990420.0748))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date)) // December 31
        
        print(Date().timeIntervalSince1970)
    }


    func sceneDidEnterBackground(_ scene: UIScene) {
        NoteCoreDataStorage.shared.saveContext()
    }
}

extension SceneDelegate: UISplitViewControllerDelegate {
    @available(iOS 14.0, *)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }

    func splitViewController(_ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController:UIViewController,
        onto primaryViewController:UIViewController) -> Bool {
        return true
    }
}
