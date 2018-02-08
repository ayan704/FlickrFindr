//
//  CustomImageView.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import AlamofireImage

class CustomImageView: UIImageView {
    
    private var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .clear
    }
    
    /// Download image with URL, display placeholder image depending on the flag
    ///
    /// - Parameters:
    ///   - urlString: image URL string
    ///   - placeHolderImage: placeholder image name (should be present in main bundle)
    ///   - shouldShowDefaultImage: whether to show default image or not
    public func setImage(urlString: String?, placeHolderImage: String?, shouldShowDefaultImage: Bool = true) {
        
        guard let urlStr = urlString  else {
            self.image = UIImage(named: Constants.placeholderImage)
            return
        }
        
        if urlStr.isEmpty {
            self.image = UIImage(named: Constants.placeholderImage)
        } else if let url = URL(string: urlStr) {
            
            let name = placeHolderImage ?? Constants.placeholderImage
            let image = shouldShowDefaultImage ? UIImage(named: name) : nil
            self.addIndicator()
            self.af_setImage(withURL: url, placeholderImage: image, completion: { [weak self] (_) in
                self?.removeIndicator()
            })
        }
    }
    
    /// Add Activity Indicator while image download is in progress
    func addIndicator() {
        
        if (self.activityIndicator == nil) {
            
            self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            self.activityIndicator?.hidesWhenStopped = true
            
            self.activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator?.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
            
            if let indicator = activityIndicator {
                
                self.addSubview(indicator)
                self.activityIndicator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                self.activityIndicator?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            }
        }
        self.activityIndicator?.startAnimating()
    }
    
    /// Remove Activity Indicator once image download completes (success/fail)
    func removeIndicator() {
        self.activityIndicator?.stopAnimating()
    }
    
    /// Download image with URL, display placeholder image depending on the flag
    ///
    /// - Parameters:
    ///   - urlString: image URL string
    ///   - placeHolderImage: placeholder image name (should be present in main bundle)
    ///   - shouldShowDefaultImage: whether to show default image or not
    ///   - completion: completion block, gets called when image is downloaded
    public func setImage(urlString: String?,
                         placeHolderImage: String?,
                         shouldShowDefaultImage: Bool = true,
                         completion: ((CGFloat) -> Void)?) {
        
        guard let urlStr = urlString  else {
            self.image = UIImage(named: Constants.placeholderImage)
            return
        }
        
        if urlStr.isEmpty {
            self.image = UIImage(named: Constants.placeholderImage)
        } else if let url = URL(string: urlStr) {
            
            let name = placeHolderImage ?? Constants.placeholderImage
            let image = (shouldShowDefaultImage == false) ? nil : UIImage(named: name)
            self.addIndicator()
            self.af_setImage(withURL: url, placeholderImage: image, completion: { (response) in
                
                // returns the aspect ratio of the downloaded image
                if let image = response.result.value {
                    let aspectRatio = image.size.height / image.size.width
                    completion?(aspectRatio)
                }
                self.removeIndicator()
            })
        }
    }
    
}
