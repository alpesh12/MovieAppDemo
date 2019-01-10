//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Jayesh on 08/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import RxSwift

class MovieListModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var alertMessage: PublishSubject<String>
    let reloadData: PublishSubject<Void>
    let updateLoadingStatus: PublishSubject<Void>
    
    var movies: [Movie] = [Movie]()
    var selectedMovie: Movie?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus.onNext(())
        }
    }
    
    init() {
        self.alertMessage = PublishSubject<String>().asObservable() as! PublishSubject<String>
        self.reloadData = PublishSubject<Void>().asObservable() as! PublishSubject<Void>
        self.updateLoadingStatus = PublishSubject<Void>().asObservable() as! PublishSubject<Void>
    }
    
    func fetchMoviesList(strURL:String) {
        self.movies.removeAll()
        self.isLoading = true
        AFUtility().doRequestFor(strURL, method: .get, dicsParams: nil, dicsHeaders: nil) { (_ response: NSDictionary?, _ statusCode: Int?, _ error: NSError?) in
            
            self.isLoading = false
            if statusCode == 200 {
                let success = response!.value(forKey: "success") as! Bool
                if  (success == true) {
                    if  (response!.value(forKey: "results") != nil) {
                        if (response!.value(forKey: "results") is NSArray) {
                            let arrData = response!.value(forKey: "results") as! NSArray
                            for item in arrData {
                                self.movies.append(Movie.init(object: item))
                            }
                        } else {
                            self.alertMessage.onNext(key_Failure_Error)
                        }
                    } else {
                        self.alertMessage.onNext(key_Failure_Error)
                    }
                } else {
                    self.alertMessage.onNext(key_Failure_Error)
                }
            } else {
                self.alertMessage.onNext(key_Failure_Error)
            }
            self.reloadData.onNext(())
        }
    }
}
