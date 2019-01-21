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
    @IBOutlet weak var tabBar: UITabBar!
    
    //Mark: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCoffeeViewModel = SelectCoffeeViewModel()
        requestCoffeedata()
    }
    
    
    private func requestCoffeedata() {
        selectCoffeeViewModel?.requestCoffee().subscribe(onNext:{ (selectCoffeeModel) in
            
            self.selectCoffeeModel = selectCoffeeModel
            self.selectCoffeeCollectionConfigration()
                
        }).disposed(by: disposeBag)
    }
    
    private func selectCoffeeCollectionConfigration() {
        selectCoffeeCollectionView.reloadData()

        selectCoffeeCollectionView.isScrollEnabled = false
        
        if selectCoffeeModel?.isEmpty ?? true {
            selectCoffeeCollectionView.isUserInteractionEnabled = false
        }
        else {
            selectCoffeeCollectionView.isUserInteractionEnabled = true
            
            coffeeTitle.text = selectCoffeeModel![0].title
            coffeeTitle.setLineSpacing(lineHeightMultiple: 0.72)
            view.backgroundColor = hexToUIColor(selectCoffeeModel![0].backgroundColor)

            setUpSwipeGestures()
        }
    }
    
    
    private func setUpSwipeGestures() {
        let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(swipeToViewNextPrevImage))
        leftSwipeGest.direction = .left
       
        let rightSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(swipeToViewNextPrevImage))
        rightSwipeGest.direction = .right
        
        leftSwipeGest.delegate = self
        rightSwipeGest.delegate = self
        
        selectCoffeeCollectionView.addGestureRecognizer(leftSwipeGest)
        selectCoffeeCollectionView.addGestureRecognizer(rightSwipeGest)
    }
    
    //Mark: - functions
    @objc private func swipeToViewNextPrevImage(sender: UISwipeGestureRecognizer) {
        
        // calculate center visible item against screen
        guard let visiblesCenterItemIndex : IndexPath? = {
            for item in selectCoffeeCollectionView.visibleCells {
                
                let theAttributes:UICollectionViewLayoutAttributes! = selectCoffeeCollectionView.layoutAttributesForItem(at: selectCoffeeCollectionView.indexPath(for: item)!)
                let cellFrameInSuperview = selectCoffeeCollectionView.convert(theAttributes.frame, to: selectCoffeeCollectionView.superview).midX

                if abs(cellFrameInSuperview - selectCoffeeCollectionView.center.x) < selectCoffeeCollectionView.frame.width / 3 {
                    return selectCoffeeCollectionView.indexPath(for: item)
                }
            }
        return nil
        }() else { return }
        
        // set center item in the visibles array to current
        let visibleItems = selectCoffeeCollectionView.indexPathsForVisibleItems as NSArray
        let visiblesIdxOfCenterItem = visibleItems.index(of: visiblesCenterItemIndex!)
        let currentItem = visibleItems.object(at: visiblesIdxOfCenterItem) as! IndexPath
        
        
        if sender.direction == .left {
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < selectCoffeeModel?.count ?? 0 {
                ///handle disappear
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                ///handle the grow
                guard let nextCell = selectCoffeeCollectionView.cellForItem(at: nextItem) else {return}
                changeLayout(newCurrentCell: nextCell as! SelectCoffeeCollectionViewCell)
            }
        }
            
            
        else if sender.direction == .right {
            let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            if nextItem.row >= 0 {
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                ///breaks swiping right -- nil (next item ?? but not out of bounds interesting.
                ///solution: test nextItem for nil cases .. use more safety checks ..
                ///added guard check
                guard let nextCell = selectCoffeeCollectionView.cellForItem(at: nextItem) else {return}
                changeLayout(newCurrentCell: nextCell as! SelectCoffeeCollectionViewCell)
            }
        }
    }
    
    private func changeLayout(newCurrentCell: SelectCoffeeCollectionViewCell) {
        coffeeTitle.text = newCurrentCell.title
        coffeeTitle.setLineSpacing(lineHeightMultiple: 0.72)
        
        view.backgroundColor = newCurrentCell.bgColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ///still having issues with initial collectionView item
        ///positioning after orientation change but it isn't getting hung up,
        ///just not centering or skipping one drink on first swipe
        selectCoffeeCollectionView.reloadData()
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
        return view.frame.width * 0.115
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minWidth = min(view.frame.width, view.frame.height) / 1.75
        return CGSize(width: minWidth, height: minWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth = min(view.frame.width, view.frame.height) / 1.75
        let offSet = view.frame.width / 2.0 - cellWidth / 2.0
        
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectCoffeeModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCoffeeCell", for: indexPath) as! SelectCoffeeCollectionViewCell
        cell.addShadow(endCellWidth: min(view.frame.width, view.frame.height) / 1.75)
        if let thisSelectCoffeeItem = selectCoffeeModel?[indexPath.row] {
            cell.bindData(selectCoffeeModel: thisSelectCoffeeItem)
        }
        return cell
    }
}

