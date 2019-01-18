//
//  ListTableViewController.swift
//  MovieApp
//
//  Created by Jayesh on 08/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListTableViewController: UIViewController,UITableViewDelegate {

    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet weak var tblMovieList: UITableView!
    
    //MARK: - Instance Variables
    //MARK: -
    var modelMovieList:MovieListModel!
    var disposeBag = DisposeBag()

    //MARK: - Class Methods
    //MARK: -
    static func create() -> ListTableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListTableViewController") as! ListTableViewController
    }

    //MARK: - ViewController Life Cycle Methods
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func initializeViewModel() {
        
        let items = Observable.just (
            self.modelMovieList.movies
        )
        
        items.bind(to: tblMovieList.rx.items(cellIdentifier: "MoviewListCell", cellType: MoviewListCell.self)) { (row, element, cell) in
            cell.imgMovieList.backgroundColor = UIColor.lightGray
            cell.imgMovieList.kf.indicatorType = .activity
            cell.imgMovieList.kf.setImage(with: URL(string: element.posterPath), completionHandler: {
                (image, error, cacheType, imageUrl) in
                if (image == nil) {
                    //self.imgMovie.image = UIImage(named: "iconUserPlaceholder")
                }
            })
            
            cell.lblMovieName.text = element.title
            cell.lblReleaseDate.text = self.modelMovieList.dfReleaseDate.string(from: Date(timeIntervalSince1970: TimeInterval(element.releaseDate)))
            cell.lblMovieDescription.text = element.description
            cell.viewRating.rating = Double((element.rate / 2.0))
            cell.viewRating.text = "\(String(describing: element.rate))"
            cell.lblAgeCategory.text = element.ageCategory
            
        }.disposed(by: disposeBag)
        
        tblMovieList.rx.modelSelected(String.self).subscribe(onNext:  { value in
            print(value)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Others Methods
    //MARK: -
    func reloadTableviewData() -> Void {
        tblMovieList.reloadData()
    }
    
    //MARK: - Deallocation Methods
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
