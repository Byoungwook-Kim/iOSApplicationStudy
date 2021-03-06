//
//  TutorilaMasterVC.swift
//  MyMemory
//
//  Created by Byoung_wook on 2021/09/23.
//  Copyright © 2021 rubypaper. All rights reserved.
//

import UIKit

class TutorilaMasterVC: UIViewController, UIPageViewControllerDataSource {
    
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        guard self.contenTitles.count >= idx && self.contenTitles.count > 0 else {
            return nil
        }
        
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else {
            return nil
        }
        
        cvc.titleText = self.contenTitles[idx]
        cvc.imageFile = self.contentImages[idx]
        cvc.pageindex = idx
        return cvc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! TutorialContentsVC).pageindex else {
            return nil
        }
        
        guard index > 0 else {
            return nil
        }
        
        index -= 1
        return self.getContentVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var index = (viewController as! TutorialContentsVC).pageindex else {
            return nil
        }
        
        index += 1
        
        guard index < self.contenTitles.count else {
            return nil
        }
        return self.getContentVC(atIndex: index)
    }
    
    var pageVC: UIPageViewController!
    
    var contenTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImages = ["Page0", "Page1", "Page2", "Page3"]
    @IBAction func close(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        self.pageVC = self.instanceTutorialVC(name: "PageVC") as! UIPageViewController
        self.pageVC.dataSource = self
        
        let startContentVC = self.getContentVC(atIndex: 0)!
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true)
        
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 50
        
        self.addChildViewController(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParentViewController: self)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contenTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
