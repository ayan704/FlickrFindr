//
//  HomeViewController.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/24/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

enum ImageType {
    case thumbnail
    case large
    case unknown
}

class HomeViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var homeTableView: UITableView!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel: HomeViewModel = HomeViewModel()
    fileprivate var currentSearchString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = PageTitle.home
        self.configureUI()
        self.configureViewDelegates()
        self.displayNoDataFoundView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// configure default UI elements, also can be used to setup font, color etc
    private func configureUI() {
        self.configureTableView()
        self.configureSearchBar()
    }
    
    private func configureTableView() {
        self.homeTableView.estimatedRowHeight = 100.0
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func configureSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = Constants.searchPlaceHolderString
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
    }
    
    /// set all necessary view delegates
    private func configureViewDelegates() {
        self.viewModel.delegate = self
    }
    
    /// Call this method when there is no data to display
    private func displayNoDataFoundView() {
        self.infoLabel.isHidden = false
        self.homeTableView.isHidden = true
        self.infoLabel.text = Constants.noPhotoFound
    }
    
    /// method to check and invoke pagination
    ///
    /// - Parameter index: index of the last visible cell
    fileprivate func checkAndFetchMorePhoto(index: Int) {
        guard let pageNo = self.viewModel.dashboard?.pageNo else {
            return
        }
        guard let totalPages = self.viewModel.dashboard?.totalPages else {
            return
        }
        if index == ((self.viewModel.dashboard?.photoDataSource?.count ?? 0) - 1) && pageNo < totalPages {
            self.fetchPhotoList(searchString: self.currentSearchString, pageNo: pageNo + 1, resetPreviuosSearchData: false)
        }
    }
    
    /// fetch photo list
    ///
    /// - Parameters:
    ///   - searchString: search term to get photo list
    ///   - pageNo: pass page no for pagination
    ///   - resetPreviuosSearchData: reset previously searched data for new search, otherwise update for pagination
    fileprivate func fetchPhotoList(searchString: String, pageNo: Int?, resetPreviuosSearchData: Bool) {
        if resetPreviuosSearchData {
            self.displayActivityIndicator()
        } else {
            self.showTableFooterSpinner()
        }
        
        self.viewModel.getPhotoList(searchString: searchString, pageNo: pageNo, resetPreviuosSearchData: resetPreviuosSearchData)
    }
    
    /// Show Table view footer spinner
    func showTableFooterSpinner() {
        let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.homeTableView.tableFooterView = spinner
        spinner.startAnimating()
        self.homeTableView.isHidden = false
    }
    
    /// hide Table View footer spinner
    func hideTableFooterSpinner() {
        
        if let tableFooter = self.homeTableView.tableFooterView {
            for subView in tableFooter.subviews.reversed() {
                
                if subView is UIActivityIndicatorView {
                    if let spinner = subView as? UIActivityIndicatorView {
                        spinner.stopAnimating()
                        spinner.removeFromSuperview()
                    }
                    return
                }
            }
        }
        self.homeTableView.isHidden = true
    }
    
}

extension HomeViewController: HomeViewProtcol {
    
    /// Update UI elements after getting the data back from the API
    func refreshHomeView() {
        self.hideActivityIndicator()
        self.hideTableFooterSpinner()
        if self.viewModel.dashboard?.photoDataSource?.isEmpty ?? true {
            self.displayNoDataFoundView()
        } else {
            self.infoLabel.isHidden = true
            self.homeTableView.isHidden = false
            self.homeTableView.reloadData()
        }
    }
    
    /// Display error mesage
    ///
    /// - Parameter errorMessage: error message string
    func displayError(errorMessage: String) {
        self.hideActivityIndicator()
        self.hideTableFooterSpinner()
        self.showError(errorMessage: errorMessage)
    }
    
}

// MARK: - Tableview DataSource and Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dashboard?.photoDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.homeTableViewCellId) as? HomeTableViewCell
        
        cell?.selectionStyle = .none
        cell?.updateData(photo: self.viewModel.dashboard?.photoDataSource?[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.checkAndFetchMorePhoto(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let imageURL = CommonUtility.getURLforImage(photo: self.viewModel.dashboard?.photoDataSource?[indexPath.row],
                                                          type: ImageType.large) else {
                                                            self.displayError(errorMessage: CustomErrorString.noImageURL)
                                                            return
        }
        
        let storyBoard = UIStoryboard.init(name: Constants.storyboard, bundle: Bundle.main)
        guard let modalViewController = storyBoard.instantiateViewController(withIdentifier:
            String.init(describing: PhotoDetailViewController.self)) as? PhotoDetailViewController else {
                self.displayError(errorMessage: CustomErrorString.photoDetailVCInitError)
                return
        }
        
        modalViewController.setImageURL(imageURL: imageURL)
        modalViewController.modalPresentationStyle = .fullScreen
        self.present(modalViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Search results updater protocol implementation
extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.currentSearchString = searchText
            self.fetchPhotoList(searchString: searchText, pageNo: nil, resetPreviuosSearchData: true)
        }
    }
}

