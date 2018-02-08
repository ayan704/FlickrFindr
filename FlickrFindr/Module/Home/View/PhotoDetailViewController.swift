//
//  PhotoDetailViewController.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/25/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class PhotoDetailViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var detailImage: CustomImageView!
    @IBOutlet fileprivate weak var detailImageWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var detailImageHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var closeButton: UIButton!
    
    private var imageURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.updateImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// configure default UI elements, also can be used to setup font, color etc
    private func configureUI() {
        self.detailImageWidth.constant = self.view.frame.width
    }
    
    /// download and update the image with imageURL
    private func updateImage() {
        if let url = self.imageURL {
            self.detailImage.setImage(urlString: url,
                                      placeHolderImage: Constants.placeholderImage) { [unowned self] (aspectRatio) in
                                        
                                        DispatchQueue.main.async {
                                            
                                            //modify the height and width constraint, to maintain the aspect ratio
                                            var imageHeight = self.view.frame.width * aspectRatio
                                            let maxAllowedHeight = min(imageHeight, (self.view.frame.height -
                                                (self.closeButton.frame.origin.y + self.closeButton.frame.size.height + 80)))
                                            
                                            if imageHeight > maxAllowedHeight {
                                                imageHeight = maxAllowedHeight
                                                let imageWidth = imageHeight * aspectRatio
                                                self.detailImageWidth.constant = imageWidth
                                            }
                                            self.detailImageHeight.constant = imageHeight
                                            self.view.layoutIfNeeded()
                                        }
            }
        } else {
            self.showError(errorMessage: CustomErrorString.noImageURL)
        }
    }
    
    func setImageURL(imageURL: String) {
        self.imageURL = imageURL
    }
    
    /// dismiss the view presented modally
    ///
    /// - Parameter sender: close button
    @IBAction func closeButtonClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
