//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Jayesh on 08/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@objcMembers class SearchViewController : UIViewController  {
    
    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet var tableSearch: UITableView!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var txtSearch: UISearchBar!
    
    //MARK: - Instance Variables
    //MARK: -
    var disposeBag = DisposeBag()
    
    lazy var viewModel: SearchViewModel = {
        return SearchViewModel()
    }()

    //MARK: - ViewController Life Cycle Methods
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeView()
        self.initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.viewModel.fetchPreviousSearch()
        self.txtSearch.text = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    //MARK: - Custom Initialization Methods
    //MARK: -
    func initializeView() {
    }
    
    func initializeViewModel() {
        
        self.txtSearch.rx.searchButtonClicked.asObservable().subscribe ({ _ in
            self.txtSearch.resignFirstResponder()
            self.viewModel.insertSearch(self.txtSearch.text!)
            self.viewModel.searchString = self.txtSearch.text!
            self.showMovieList()
        }).disposed(by: disposeBag)
        
        self.viewModel.reloadData
            .subscribe(onNext:{ [weak self] in
                self?.tableSearch.reloadData()
            })
            .disposed(by: disposeBag)
        
        _ = self.btnCancel.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.viewModel.arrSearch.asObservable()
            .bind(to: self.tableSearch.rx.items(dataSource: self.viewModel.dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.reloadData
            .subscribe(onNext:{ [weak self] in
                self?.tableSearch.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.tableSearch.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, self.viewModel.dataSource[indexPath])
            }
            .subscribe(onNext: { [weak self] pair in
                self?.tableSearch.deselectRow(at: pair.0, animated: true)
                self?.viewModel.searchString = pair.1
                self?.showMovieList()
            })
            .disposed(by: disposeBag)
        
        self.tableSearch.rx.itemDeleted
            .subscribe({ [weak self] indexPath in
                self!.viewModel.deleteSearch((indexPath.element?.row)!)
            })
            .disposed(by: disposeBag)
        
        self.tableSearch.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }
    
    //MARK: - Others Methods
    //MARK: -
    func showMovieList() {
        self.viewModel.fetchPreviousSearch()
        self.txtSearch.text = nil
        let objVC = MovieListViewController.create()
        objVC.searchString = self.viewModel.searchString
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    //MARK: - Deallocation Methods
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SearchViewController: UITableViewDelegate {
    //MARK: - UITableViewDelegate Methods
    //MARK: -
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
            self.viewModel.deleteSearch(indexPath.row)
            completionHandler(true)
        })
        action.image = UIImage(named: "iconDelete")
        action.backgroundColor = .lightGray
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }
}
