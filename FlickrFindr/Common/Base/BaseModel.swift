//
//  BaseModel.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel {
    
    var status: String?
    var code: String?
    var message: String?
    
    /// All JSON response has some common attributes
    /// Combine all the common attributes in base model
    /// - Parameter response: JSON response
    init(with response: JSON) {
        self.status = response["stat"].stringValue
        self.code = response["code"].stringValue
        self.message = response["message"].stringValue
    }
    
}
