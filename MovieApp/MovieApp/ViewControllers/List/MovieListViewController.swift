//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Jayesh on 08/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import RxSwift

class MovieListViewController: UIViewController {

    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet weak var scrPager: ScrollPager!
    
    //MARK: - Instance Variables
    //MARK: -
    var disposeBag = DisposeBag()
    var objComminsoonVC:ListTableViewController!
    var objNowshowing:ListTableViewController!
    
    var isNowShowingFetch = true
    var isCommingSoonFetch = false

    var searchString = ""
    
    var selectedPager = 0

    lazy var viewModel: MovieListModel = {
        return MovieListModel()
    }()

    //MARK: - Class Methods
    //MARK: -
    static func create() -> MovieListViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
    }
    
    //MARK: - ViewController Life Cycle Methods
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrPager.delegate = self;
        self.initializeView()
        self.initializeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Custom Initialization Methods
    //MARK: -
    func initializeView() {
        objComminsoonVC = ListTableViewController.create()
        objNowshowing = ListTableViewController.create()
        
        //scroll page
        scrPager.addSegmentsWithTitlesAndViews(segments: [(title:"Now Showing", view:objNowshowing.view!), (title:"Comming Soon", view:objComminsoonVC.view!)])
        scrPager.font = UIFont.systemFont(ofSize: 16)
        scrPager.selectedFont = UIFont.systemFont(ofSize: 16)
    }
    
    func initializeViewModel() {
        viewModel.alertMessage
            .subscribe(onNext:{ [weak self] in
                self?.presentAlert(message: $0)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.updateLoadingStatus
            .subscribe(onNext:{ [weak self] in
                print($0)
                //self?.presentAlert(message: $0)
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    HUD.showLoadingHUD()
                }else {
                    HUD.hideLoadingHUD()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadData
            .subscribe(onNext:{ [weak self] in
                self?.printData()
            })
            .disposed(by: disposeBag)
        viewModel.fetchMovies(keyword: searchString, offset: 1, type: "nowshowing")
    }
    
    //MARK: - Others Methods
    //MARK: -
    private func printData(){
        if self.selectedPager == 0{
            objNowshowing.modelMovieList = self.viewModel;
            objNowshowing.initializeViewModel()
        }
        else{
            objComminsoonVC.modelMovieList = self.viewModel;
            objComminsoonVC.initializeViewModel()
        }
        print(self.viewModel.movies.count);
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    //MARK: - Deallocation Methods
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
extension MovieListViewController: ScrollPagerDelegate {
    //MARK: - ScrollPagerDelegate Methods
    //MARK: -
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        selectedPager = changedIndex
        if changedIndex == 0 {
            
            if isNowShowingFetch == false {
                viewModel.fetchMovies(keyword: searchString, offset: 1, type: "nowshowing")
            } else {
                objNowshowing.reloadTableviewData()
            }
        }
        else {
            if isCommingSoonFetch == false {
                viewModel.fetchMovies(keyword: searchString, offset: 1, type: "commingsoon")
                isCommingSoonFetch = true
            } else {
                objComminsoonVC.reloadTableviewData()
            }
        }
    }
}
