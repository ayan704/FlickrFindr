//
//  Dashboard.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var photoId: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: String?
    var title: String?
    var ispublic: Bool?
    var isfriend: Bool?
    var isfamily: Bool?
}

class Dashboard: BaseModel {
    
    var pageNo: Int?
    var totalPages: Int?
    var photoPerpage: Int?
    var totalPhoto: Int?
    var photoDataSource: Array<Photo>?
    
    init?(response: JSON) {
        
        if response.isEmpty {
            return nil
        }
        super.init(with: response)
        self.parseResponse(responseJSON: response)
    }
    
    private func parseResponse(responseJSON: JSON) {
        
        let photosJSON = responseJSON["photos"]
        if !photosJSON.isEmpty {
            self.pageNo = photosJSON["page"].intValue
            self.totalPages = photosJSON["pages"].intValue
            self.photoPerpage = photosJSON["perpage"].intValue
            self.totalPhoto = photosJSON["total"].intValue
            self.photoDataSource = [Photo]()
            
            for photoJSON in photosJSON["photo"].arrayValue {
                if let photo = self.createPhotoModel(photoJSON: photoJSON) {
                    self.photoDataSource?.append(photo)
                }
            }
        }
    }
    
    private func createPhotoModel(photoJSON: JSON) -> Photo? {
        
        if !photoJSON.isEmpty {
            
            var photo = Photo()
            photo.photoId = photoJSON["id"].stringValue
            photo.owner = photoJSON["owner"].stringValue
            photo.secret = photoJSON["secret"].stringValue
            photo.server = photoJSON["server"].stringValue
            photo.farm = photoJSON["farm"].stringValue
            photo.title = photoJSON["title"].stringValue
            photo.ispublic = photoJSON["ispublic"].boolValue
            photo.isfriend = photoJSON["isfriend"].boolValue
            photo.isfamily = photoJSON["isfamily"].boolValue
            return photo
        }
        return nil
    }
    
    func updateWithJSON(responseJSON: JSON) {
        if responseJSON.isEmpty {
            return
        }
        
        let photosJSON = responseJSON["photos"]
        if !photosJSON.isEmpty {
            self.pageNo = photosJSON["page"].intValue
            self.totalPages = photosJSON["pages"].intValue
            self.photoPerpage = photosJSON["perpage"].intValue
            self.totalPhoto = photosJSON["total"].intValue
            
            for photoJSON in photosJSON["photo"].arrayValue {
                if let photo = self.createPhotoModel(photoJSON: photoJSON) {
                    self.photoDataSource?.append(photo)
                }
            }
        }
    }
    
}
