//
//  SelectCoffeeViewController.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/19/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher


class SelectCoffeeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Mark: - properties
    private let disposeBag = DisposeBag()
    
    private var selectCoffeeViewModel: SelectCoffeeViewModel?
    
    fileprivate var selectCoffeeModel: [SelectCoffeeModel]?

    
    //Mark: - IBOutlets
    
    @IBOutlet weak var coffeeTitle: UILabel!
    @IBOutlet weak var coffeeDetails: UILabel!
    @IBOutlet weak var selectCoffeeCollectionView: UICollectionView!
    
    
    //Mark: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestCoffeedata()
    }
    
    private func requestCoffeedata() {
        selectCoffeeViewModel = SelectCoffeeViewModel()
        
        selectCoffeeViewModel?.requestCoffee().subscribe(onNext: { (selectCoffeeModel) in
            self.selectCoffeeModel = selectCoffeeModel
            self.selectCoffeeCollectionView.reloadData()
            self.selectCoffeeCollectionConfigration()
        }).disposed(by: disposeBag)
    }
    
    private func selectCoffeeCollectionConfigration() -> Void {
        selectCoffeeCollectionView.isScrollEnabled = false
        if selectCoffeeModel?.isEmpty ?? true {
            selectCoffeeCollectionView.isUserInteractionEnabled = false
        }
        else {
            selectCoffeeCollectionView.isUserInteractionEnabled = true
            let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(swipeToViewNextPrevImage))
            leftSwipeGest.direction = .left
            let rightSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(swipeToViewNextPrevImage))
            rightSwipeGest.direction = .right
            
            leftSwipeGest.delegate = self
            rightSwipeGest.delegate = self
            selectCoffeeCollectionView.addGestureRecognizer(leftSwipeGest)
            selectCoffeeCollectionView.addGestureRecognizer(rightSwipeGest)
        }
    }

    
    //Mark: - functions
    @objc private func swipeToViewNextPrevImage(sender: UISwipeGestureRecognizer) {
        
        //        view.backgroundColor = hexStringToUIColor(hex: "#51E58F")

        ///handle background color change / title change
        ///handle collection item/image change
        ///handle disappear
        ///handle the grow
        ///gesture left iterate selectCoffeeModelArr index - 1
        
        if sender.direction == .left {
            let visibleItems: NSArray = self.selectCoffeeCollectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < selectCoffeeModel?.count ?? 0 {
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                
            }
        }
        else if sender.direction == .right {
            let visibleItems: NSArray = self.selectCoffeeCollectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            
            if nextItem.row < selectCoffeeModel?.count ?? 0  && nextItem.row >= 0{
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
            }
        }
    }


    
    //Mark: - IBAction
    @IBAction func didFinishSelectingCoffee(_ sender: Any) {
        
    }
    
    @IBAction func didClickCustomize(_ sender: Any) {
    }
    
}







//Mark: - CollectionView Handling


extension SelectCoffeeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == selectCoffeeCollectionView ? 0 : 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == selectCoffeeCollectionView ? 0 : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width * 0.65)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectCoffeeModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCoffeeCell", for: indexPath) as! SelectCoffeeCollectionViewCell
        if let thisSelectCoffeeItem = selectCoffeeModel?[indexPath.row] {
            cell.bindData(selectCoffeeModel: thisSelectCoffeeItem)
        }
        return cell
    }
}

