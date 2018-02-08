//
//  HomeViewModel.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/25/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import Foundation

protocol HomeViewProtcol: class {
    func refreshHomeView()
    func displayError(errorMessage: String)
}

class HomeViewModel {
    
    weak var delegate: HomeViewProtcol?
    var dashboard: Dashboard?
    
    /// Retrieve photo list for the given search term
    ///
    /// - Parameters:
    ///   - searchString: search string
    ///   - pageNo: pass page no for pagination, if not passed, assumes no pagination done and fetches default page data
    ///   - resetPreviuosSearchData: reset previously searched data for new search, otherwise update for pagination
    func getPhotoList(searchString: String, pageNo: Int?, resetPreviuosSearchData: Bool) {
        
        var parameters = [APIParamConstant.dashboardDataSearchKey : searchString,
                          APIParamConstant.perPageKey : APIParamConstant.perPageValue] as APIParameters
        if let page = pageNo {
            parameters[APIParamConstant.pageKey] = page
        }
        
        RestClientManager.dataRequest(requestUrl: nil,
                                      parameters: parameters,
                                      onSuccess: { [unowned self] (response) in
                                        
                                        if !resetPreviuosSearchData {
                                            if let dashboard = self.dashboard {
                                                dashboard.updateWithJSON(responseJSON: response)
                                                self.delegate?.refreshHomeView()
                                                return
                                            }
                                        } else {
                                            self.dashboard = nil
                                        }
                                        
                                        if let dashboard = Dashboard.init(response: response) {
                                            
                                            if let errorMessage = dashboard.message, !errorMessage.isEmpty {
                                                self.delegate?.displayError(errorMessage: errorMessage)
                                                return
                                            }
                                            self.dashboard = dashboard
                                            self.delegate?.refreshHomeView()
                                            
                                        } else {
                                            self.delegate?.displayError(errorMessage: CustomErrorString.noDataToDisplay)
                                        }
                                        
        }) { [unowned self] (restError) in
            self.delegate?.displayError(errorMessage: restError.errorMessage)
        }
    }
    
}
