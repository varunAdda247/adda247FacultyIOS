//
//  ADPageViewController.swift
//  Adda247
//
//  Created by Varun Tomar on 25/10/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIPageViewController {
 
    func goToNextPage(animated: Bool = true) {
    guard let currentViewController = self.viewControllers?.first else { return }
    guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
    setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
 
   func goToPreviousPage(animated: Bool = true) {
   guard let currentViewController = self.viewControllers?.first else { return }
   guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
   setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
   }
 
 }

