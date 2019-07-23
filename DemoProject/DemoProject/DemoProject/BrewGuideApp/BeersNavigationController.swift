//
//  BeersNavigationController.swift
//  DemoProject
//
//  Created by GEORGE QUENTIN on 21/07/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit

class BeersNavigationController: UINavigationController {

    /*
     Now, when you decide to replace the default back button with your own custom back button you will see that the “Swipe Back” Gesture is not working anymore. Apparently the UIScreenEdgePanGestureRecognizer’s delegate only allows the gesture to be recognized when it sees that the default back button is being used. Bummer!
     
     To make the “Swipe Back” work again you have to bypass the delegate that disables the gesture. If found some suggestions that would simply set the delegate to nil. This seems to work at first. But when you start playing around with your app after doing that you will eventually see that the app freezes and does not recognize ANY touches anymore. This happens when you swipe back while the navigation controller is pushing a view controller. Not good!
     So you have to set the delegate yourself and implement gestureRecognizerShouldBegin(_:) to disable the gesture whenever the navigation controller is pushing a view controller.
     
     The easiest way to do this is to subclass UINavigationController:
     */
    
    // 1
    var isPushingViewController = false
    
    
    override func loadView() {
        super.loadView()
    
    }
    
    override init(rootViewController : UIViewController) {
        super.init(rootViewController : rootViewController)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass : navigationBarClass, toolbarClass : toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "new_main_view") as! ViewController
//        self.setViewControllers([newViewController], animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3
        //delegate = self
        // 5
        //interactivePopGestureRecognizer?.delegate = self
    }
    
    // 2
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
        super.pushViewController(viewController, animated: animated)
    }
}

 
// MARK: - UINavigationControllerDelegate

extension BeersNavigationController: UINavigationControllerDelegate {
    // 4
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let beerNavigationController = navigationController as? BeersNavigationController else { return }

        isPushingViewController = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension BeersNavigationController: UIGestureRecognizerDelegate {
    // 6
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && isPushingViewController == false
    }
}

