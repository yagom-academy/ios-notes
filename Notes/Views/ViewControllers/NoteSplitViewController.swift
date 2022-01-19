//
//  NoteSplitViewController.swift
//  Notes
//
//  Created by 이승주 on 2022/01/19.
//

import UIKit

class NoteSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRotateScreenNotificationObserver()
        self.setUI()
    }

    private func setRotateScreenNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.detectOrientation),
            name: NSNotification.Name(Constant.rotateScreenNotificationName),
            object: nil
        )
    }

    @objc private func detectOrientation() {
        self.setUI()
    }

    @objc private func setUI() {
        switch UITraitCollection.current.horizontalSizeClass {
        case .compact:
            self.preferredDisplayMode = .automatic
            print("horizontal compact")
        case .regular:
            self.preferredDisplayMode = .oneBesideSecondary
            print("horizontal regular")
        default:
            break
        }
    }
}
