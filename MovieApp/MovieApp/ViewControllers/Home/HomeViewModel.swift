//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Jayesh on 07/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class HomeViewModel {
    
    // MARK: - Inputs

    // MARK: - Outputs
    var alertMessage: PublishSubject<String>
    let reloadData: PublishSubject<Void>
    let updateLoadingStatus: PublishSubject<Void>
    
    var movies: [Movie] = [Movie]()
    
    private let provider = MoyaProvider<MovieAPI>()
    
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
    
    func fetchMovies() {
        self.movies.removeAll()
        self.isLoading = true
        let decoder = JSONDecoder()
        _ = provider.rx.request(MovieAPI.Home(), callbackQueue: DispatchQueue.main)
            .map([Movie].self, atKeyPath: "results", using: decoder, failsOnEmptyData: false)
            .subscribe({ (event) in
            self.isLoading = false
            switch event {
            case .success(let movies):
                debugPrint(movies)
                self.movies = movies
                break
            case .error(let error):
                print(error)
                self.alertMessage.onNext("Something went wrong")
                break
            }
            self.reloadData.onNext(())
        })
    }
}
