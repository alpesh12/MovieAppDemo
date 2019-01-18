//
//  HudHelper.swift
//  MovieApp
//
//  Created by Jayesh on 09/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import SVProgressHUD

class HUD {
    private init(){}
    static let sharedInstance = HUD()
    var isLoadingViewShowing = false
    
    static func showLoadingHUD() {
        if HUD.sharedInstance.isLoadingViewShowing == false{
            HUD.sharedInstance.isLoadingViewShowing = true
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
        }
    }
    
    static func hideLoadingHUD() {
        HUD.sharedInstance.isLoadingViewShowing = false
        SVProgressHUD.dismiss()
    }
}
