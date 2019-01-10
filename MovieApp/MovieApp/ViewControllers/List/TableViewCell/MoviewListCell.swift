//
//  MoviewListCell.swift
//  MovieApp
//
//  Created by Bhavin on 09/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import Cosmos

class MoviewListCell: UITableViewCell {

    
    @IBOutlet weak var imgMovieList: UIImageView!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var btnBuyTicket: UIButton!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblAgeCategory: UILabel!
    
    
    override func awakeFromNib() {
        self.imgMovieList.layer.cornerRadius = 10
        self.imgMovieList.layer.masksToBounds = true

        self.btnBuyTicket.layer.cornerRadius = 15
        self.btnBuyTicket.layer.masksToBounds = true
        
        self.lblAgeCategory.layer.cornerRadius = 10
        self.lblAgeCategory.layer.borderWidth = 1
        self.lblAgeCategory.layer.borderColor = UIColor.lightGray.cgColor
        self.lblAgeCategory.layer.masksToBounds = true

    }
    
    func setMovieData(objMovie:Movie) -> Void
    {
        imgMovieList.backgroundColor = UIColor.lightGray
        imgMovieList.kf.indicatorType = .activity
        imgMovieList.kf.setImage(with: URL(string: objMovie.posterPath!), completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image == nil) {
                //self.imgMovie.image = UIImage(named: "iconUserPlaceholder")
            }
        })
        
        lblMovieName.text = objMovie.title
        lblReleaseDate.text = AppDelegate.SharedDelegate().dfReleaseDate.string(from: Date(timeIntervalSince1970: objMovie.releaseDate!))
        lblMovieDescription.text = objMovie.description
        viewRating.rating = Double((objMovie.rate! / 2.0))
        viewRating.text = "\(String(describing: objMovie.rate!))"
        lblAgeCategory.text = objMovie.ageCategory
    }
}
