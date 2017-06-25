//
//  EducationViewController.swift
//  OCD
//
//  Created by Andy Mockler on 6/18/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit

class EducationViewController: UIPageViewController {
    
    // Create an array of education view controllers (which are assigned IDs education1 - education6
    private(set) lazy var educationViewControllers: [UIViewController] = {
        return (1...7).map {
            UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "education\($0)")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        view.backgroundColor = UIColor.black

        if let firstViewController = educationViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

}

extension EducationViewController: UIPageViewControllerDataSource {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return educationViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = educationViewControllers.index(of: firstViewController) else {
            return 0
        }

        return firstViewControllerIndex
    }

    // Present next controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = educationViewControllers.index(of: viewController) else {
            fatalError("Could not find \(viewController) in educationViewControllers")
        }

        let nextIndex = viewControllerIndex + 1

        if nextIndex >= educationViewControllers.count {
            return nil
        }

        return educationViewControllers[nextIndex]
    }

    // Present previous controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = educationViewControllers.index(of: viewController) else {
            fatalError("Could not find \(viewController) in educationViewControllers")
        }

        let previousIndex = viewControllerIndex - 1

        if previousIndex < 0 {
            return nil
        }

        return educationViewControllers[previousIndex]
    }
}
