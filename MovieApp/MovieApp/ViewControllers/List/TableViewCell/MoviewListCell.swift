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
}
