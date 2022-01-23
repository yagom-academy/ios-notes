//
//  ViewControllerCaller.swift
//  Notes
//
//  Created by 이승주 on 2022/01/22.
//

import UIKit

final class ViewControllerCaller {
    static func callActivityViewController(entireContents: String, viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [entireContents],
            applicationActivities: nil
        )
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = viewController.view
                popoverController.sourceRect = CGRect(
                    x: viewController.view.bounds.midX,
                    y: viewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popoverController.permittedArrowDirections = []
            }
        }
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
