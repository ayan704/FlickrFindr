//
//  RestClientConstants.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias APIParameters = Parameters
typealias APISuccessHandler = (JSON) -> Void
typealias APIErrorHandler = (RestError) -> Void

struct URLs {
    static let base: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
}

struct APIHeaders {
    static let content: String = "Content-Type"
    static let json: String = "application/json"
}

struct APIParamConstant {
    static let apiKeyString: String = "api_key"
    static let apiKeyValue: String = "1508443e49213ff84d566777dc211f2a"
    static let noJSONCallbackKey: String = "nojsoncallback"
    static let noJSONCallbackValue: Bool = true
    static let formatKey: String = "format"
    static let formatValue: String = "json"
    static let perPageKey: String = "per_page"
    static let perPageValue: Int = 25
    static let dashboardDataSearchKey: String = "text"
    static let pageKey: String = "page"
}

struct RestErrorCode {
    static let nullResponse: Int = 3001
    static let noValue: Int = 3002
}

struct RestErrorMessage {
    static let nullResponse: String = "Null Response"
    static let noValue: String = "No Value in Response"
    static let cancelledRequest: String = "cancelled"
}
