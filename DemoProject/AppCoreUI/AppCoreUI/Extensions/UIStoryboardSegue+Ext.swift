//
//  UIStoryboardSegue+Ext.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 22/03/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit

class DismissController: UIStoryboardSegue {
    override func perform() {
        if let viewController = source.presentingViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}

class PopController: UIStoryboardSegue {
    override func perform() {
        if let navController =  source.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

class PopToController: UIStoryboardSegue {
    override func perform() {
        if let navController = source.navigationController,
            let popToViewController = navController
                .viewControllers.first(where: { $0.classForCoder == destination.classForCoder}) {
            navController.popToViewController(popToViewController, animated: true)
        }
    }
}

class PushReplaceController: UIStoryboardSegue {
    override func perform() {
        if let navController = source.navigationController {

            navController.pushViewController(destination, animated: true)
            let indexToRemove = navController.viewControllers.count - 2
            if indexToRemove >= 0 {
                navController.viewControllers.remove(at: indexToRemove)
            }
        }
    }
}
