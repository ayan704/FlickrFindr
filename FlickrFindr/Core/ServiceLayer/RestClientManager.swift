//
//  RestClientManager.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestClientManager {
    
    static var ongoingRestAPICall: [String: DataRequest] = [:]
    
    private class func getHeaderInfo() -> HTTPHeaders {
        let headers = [APIHeaders.content: APIHeaders.json]
        return headers
    }
    
    private class func constractAPIParameters(params: APIParameters?) -> APIParameters? {
        var requestParams = params
        requestParams?[APIParamConstant.apiKeyString] = APIParamConstant.apiKeyValue
        requestParams?[APIParamConstant.noJSONCallbackKey] = APIParamConstant.noJSONCallbackValue
        requestParams?[APIParamConstant.formatKey] = APIParamConstant.formatValue
        return requestParams
    }
    
    /// Common class to invoke REST API
    ///
    /// - Parameters:
    ///   - requestUrl: endURL
    ///   - parameters: parameters to be passed to the API
    ///   - onSuccess: callback for success scanario
    ///   - onFailure: callback for failure scenario
    class func dataRequest(requestUrl: String?,
                           parameters: APIParameters?,
                           onSuccess: @escaping APISuccessHandler,
                           onFailure: @escaping APIErrorHandler) {
        
        var completeURL = URLs.base
        if let url = requestUrl {
            completeURL += url
        }
        // Assuming all webservice calls are GET, if we want to make it configurable we can accept it as parameter as well
        let dataRequest = Alamofire.request(completeURL,
                                            method: HTTPMethod.get,
                                            parameters: self.constractAPIParameters(params: parameters),
                                            encoding: URLEncoding.default,
                                            headers: self.getHeaderInfo())
        dataRequest.validate()
        
        // cancels if the same request is going on with a different set of parameter
        // previous request is not required, as a new call is being made with different set of parameter
        // this can be achieved multiple ways, also we can keep a reference of the request in ViewModel or
        // any other place, and cancel while initiating a new request with different parameter set
        if let request = ongoingRestAPICall[completeURL] {
            request.cancel()
        }
        ongoingRestAPICall[completeURL] = dataRequest
        
        dataRequest.responseJSON {  dataResponse in
            ongoingRestAPICall.removeValue(forKey: completeURL)
            
            guard let urlResponse = dataResponse.response else {
                if (dataResponse.error?.localizedDescription ?? "") == RestErrorMessage.cancelledRequest {
                    return
                }
                onFailure(self.restError(errorCode: RestErrorCode.nullResponse,
                                         errorMessage: RestErrorMessage.nullResponse))
                return
            }
            
            switch dataResponse.result {
            case .success:
                
                if let json = dataResponse.result.value {
                    let jsonObject = JSON.init(json)
                    onSuccess(jsonObject)
                } else {
                    onFailure(self.restError(errorCode: RestErrorCode.noValue,
                                             errorMessage: RestErrorMessage.noValue))
                }
            case .failure(let error):
                
                onFailure(self.restError(errorCode: urlResponse.statusCode,
                                         errorMessage: error.localizedDescription))
            }
        }
    }
    
    class func restError(errorCode: Int, errorMessage: String) -> RestError {
        return RestError.init(code: errorCode, message: errorMessage)
    }
    
}
