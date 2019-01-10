//
//  HomeMovieCell.swift
//  MovieApp
//
//  Created by Jayesh on 09/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class HomeMovieCell: UIView {

    @IBOutlet weak var lblPreSale: UILabel!
    @IBOutlet weak var btnBuyTicket: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    
    static func create(frame: CGRect) -> HomeMovieCell
    {
        let homeMovieCell = UINib(nibName: "HomeMovieCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! HomeMovieCell
        homeMovieCell.frame = frame
        return homeMovieCell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        self.imgMovie.layer.cornerRadius = 10
        self.imgMovie.layer.masksToBounds = true
        
        self.lblPreSale.layer.cornerRadius = self.lblPreSale.frame.size.height/2
        self.lblPreSale.layer.masksToBounds = true
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setData(_ objMovie: Movie) {
        self.lblPreSale.isHidden = true
        if (objMovie.presaleFlag == 1) {
            self.lblPreSale.isHidden = false
        }
        imgMovie.backgroundColor = UIColor.lightGray
        imgMovie.kf.indicatorType = .activity
        imgMovie.kf.setImage(with: URL(string: objMovie.posterPath!), completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image == nil) {
                //self.imgMovie.image = UIImage(named: "iconUserPlaceholder")
            }
        })
    }
}
