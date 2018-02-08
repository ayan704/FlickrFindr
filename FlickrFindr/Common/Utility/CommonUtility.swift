//
//  CommonUtility.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/25/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation

class CommonUtility {
    
    /// Method to construct URL for image download
    ///
    /// - Parameters:
    ///   - photo: photo struct
    ///   - type: type of image it needs to return
    /// - Returns: image URL string ot nil
    class func getURLforImage(photo: Photo?, type: ImageType) -> String? {
        
        guard let photo = photo else {
            return nil
        }
        
        var typeString = ""
        switch type {
        case .thumbnail:
            typeString = "t"
        case .large:
            typeString = "h"
        default:
            typeString = "m"
        }
        
        let urlString = "https://farm\(photo.farm ?? "").staticflickr.com/\(photo.server ?? "")/" +
                        "\(photo.photoId ?? "")_\(photo.secret ?? "")_\(typeString).jpg"
        return urlString
    }
    
}
