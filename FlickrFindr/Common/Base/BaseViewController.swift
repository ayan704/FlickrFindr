//
//  BaseViewController.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var overlayView: OverlayView = OverlayView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Common method to display any error in a alert view
    ///
    /// - Parameter errorMessage: error String to display
    func showError(errorMessage: String) {
        
        let alert = UIAlertController.init(title: "Error",
                                           message: errorMessage,
                                           preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Close",
                                           style: UIAlertActionStyle.default,
                                           handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// Method to show activity indicator for all view controllers which inherits BaseViewController
    func displayActivityIndicator() {
        DispatchQueue.main.async {
            self.overlayView.displayOverlay(view: self.view)
        }
    }
    
    /// Method to hide activity indicator for all view controllers which inherits BaseViewController
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.overlayView.hideOverlayView()
        }
    }

}
