//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Jayesh on 07/01/19.
//  Copyright © 2019 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import iCarousel
import RxSwift

@objcMembers class HomeViewController : UIViewController {
    
    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet var carousel: iCarousel!
    @IBOutlet var lblMovieName: UILabel!
    @IBOutlet var lblGenre: UILabel!
    
    //MARK: - Instance Variables
    //MARK: -
    var disposeBag = DisposeBag()
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    var timer: Timer!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Custom Initialization Methods
    //MARK: -
    func initializeView() {
        self.carousel.type = .custom
    }
    
    func initializeViewModel() {
        viewModel.alertMessage
            .subscribe(onNext:{ [weak self] in
                self?.presentAlert(message: $0)
            })
            .disposed(by: disposeBag)


        viewModel.updateLoadingStatus
            .subscribe(onNext:{ [weak self] in
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
                self?.carousel.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchMovies()
    }
   
    //MARK: - Others Methods
    //MARK: -
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    func test() {
        self.carousel.scroll(byOffset: 1, duration: 0.3)
    }
    //MARK: - Deallocation Methods
    //MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController: iCarouselDataSource, iCarouselDelegate {
    //MARK: - iCarouselDataSource Methods
    //MARK: -
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.viewModel.movies.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var customView:HomeMovieCell!
        if (view != nil && (view is HomeMovieCell))
        {
            customView = view as! HomeMovieCell
        } else {
            customView = HomeMovieCell.create(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width - 150, height: carousel.frame.size.height))
        }
        customView.setData(self.viewModel.movies[index])
        return customView;
    }
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let centerItemZoom: CGFloat = 1.1
        let centerItemSpacing: CGFloat = 1.23
        
        let spacing: CGFloat = self.carousel(carousel, valueFor: .spacing, withDefault: 0.90)
        let absClampedOffset = min(1.0, fabs(offset))
        let clampedOffset = min(1.0, max(-1.0, offset))
        let scaleFactor = 1.0 + absClampedOffset * (1.0/centerItemZoom - 1.0)
        let offset = (scaleFactor * offset + scaleFactor * (centerItemSpacing - 1.0) * clampedOffset) * carousel.itemWidth * spacing
        var transform = CATransform3DTranslate(transform, offset, 0.0, -absClampedOffset)
        transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0)
        
        return transform;
    }
    //MARK: - iCarouselDelegate Methods
    //MARK: -
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value
        }
        if (option == .wrap) {
            return 1
        }
        return value
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        print(carousel.currentItemIndex)
        if (carousel.currentItemIndex > -1 && self.viewModel.movies.count > carousel.currentItemIndex) {
            self.lblMovieName.text = self.viewModel.movies[carousel.currentItemIndex].title
            self.lblGenre.text = self.viewModel.movies[carousel.currentItemIndex].genreIDS.map({ (genere: GenreID) -> String in
                genere.name
            }).joined(separator: ", ")
        } else {
            self.lblMovieName.text = ""
            self.lblGenre.text = ""
        }
    }
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        timer?.invalidate()
        timer = nil
    }
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
}
