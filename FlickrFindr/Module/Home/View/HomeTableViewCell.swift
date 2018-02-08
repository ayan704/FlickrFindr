//
//  HomeTableViewCell.swift
//  FlickrFindr
//
//  Created by Ayan Mandal on 11/25/17.
//  Copyright © 2017 Ayan Mandal. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: CustomImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnailImageView.image = UIImage.init(named: Constants.placeholderImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.thumbnailImageView.image = nil
    }
    
    /// update cell with data
    ///
    /// - Parameter photo: model object for the cell (here, this is a struct)
    func updateData(photo: Photo?) {
        
        self.titleLabel.text = photo?.title
        self.thumbnailImageView.setImage(urlString: CommonUtility.getURLforImage(photo: photo, type: ImageType.thumbnail),
                                         placeHolderImage: Constants.placeholderImage)
    }

}
