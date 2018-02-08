//
//  OverlayView.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/26/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class OverlayView: UIView {

    private var overlay: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    /// display overlay with activity indicator
    ///
    /// - Parameter view: view on which overlay will get added
    func displayOverlay(view: UIView) {
        
        for subView in view.subviews.reversed() {
            
            if subView is OverlayView {
                self.activityIndicator?.startAnimating()
                view.bringSubview(toFront: subView)
                return
            }
        }
        
        self.overlay = UIView.init(frame: view.frame)
        self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        guard let overlay = self.overlay else {
            return
        }
        
        guard let activityIndicator = self.activityIndicator else {
            return
        }
        
        overlay.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        activityIndicator.center = overlay.center
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.addSubview(overlay)
        view.addSubview(self)
    }
    
    /// hide overlay and activity indicator
    func hideOverlayView() {
        self.activityIndicator?.stopAnimating()
        self.removeFromSuperview()
    }

}
