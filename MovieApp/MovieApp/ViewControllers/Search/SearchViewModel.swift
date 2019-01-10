//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Jayesh on 08/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewModel {
    
    let reloadData: PublishSubject<Void>
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "CELL")!
            cell.textLabel?.text = element
            return cell
    }, canEditRowAtIndexPath: {_,_ in
            return true
    })
    var arrSearch = Variable([SectionModel<String, String>]())
    var searchString = ""
    init() {
        self.reloadData = PublishSubject<Void>().asObservable() as! PublishSubject<Void>
    }
    
    func fetchPreviousSearch() {
        let availableSearch = UserDefaults.standard.stringArray(forKey: "search")
        if (availableSearch != nil) {
            if (self.arrSearch.value.count == 0) {
                self.arrSearch.value.insert(SectionModel(model: "", items: []), at: 0)
            }
            self.arrSearch.value[0].items = availableSearch!
        }
        self.reloadData.onNext(())
    }
    
    func insertSearch(_ strSearch: String) {
        var availableSearch = UserDefaults.standard.stringArray(forKey: "search")
        if (availableSearch != nil) {
            availableSearch?.insert(strSearch, at: 0)
            if ((availableSearch?.count)! <= 10) {
                UserDefaults.standard.set(availableSearch, forKey: "search")
            } else {
                let newArray = availableSearch?.prefix(10)
                UserDefaults.standard.set(Array(newArray!), forKey: "search")
            }
            
        } else {
            UserDefaults.standard.set([strSearch], forKey: "search")
        }
        UserDefaults.standard.synchronize()
    }
    
    func deleteSearch(_ index: Int) {
        var availableSearch = UserDefaults.standard.stringArray(forKey: "search")
        if (availableSearch != nil) {
            availableSearch?.remove(at: index)
            UserDefaults.standard.set(availableSearch, forKey: "search")
            
            if (self.arrSearch.value.count == 0) {
                self.arrSearch.value.insert(SectionModel(model: "", items: []), at: 0)
            }
            self.arrSearch.value[0].items = availableSearch!
        }
        self.reloadData.onNext(())
    }
}
