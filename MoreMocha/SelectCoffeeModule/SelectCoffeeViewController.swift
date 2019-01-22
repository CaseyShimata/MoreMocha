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
    private var currentCenterCell: UICollectionViewCell?
    
    fileprivate var selectCoffeeModel: [SelectCoffeeModel]?

    //Mark: - IBOutlets
    @IBOutlet weak var coffeeTitle: UILabel!
    @IBOutlet weak var coffeeDetails: UILabel!
    @IBOutlet weak var selectCoffeeCollectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionParentHeight: NSLayoutConstraint!
    
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
//            view.backgroundColor = hexToUIColor(selectCoffeeModel![0].backgroundColor)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        ///still having issues with initial collectionView item
        ///positioning after orientation change but it isn't getting hung up,
        ///just not centering or skipping one drink on first swipe

        coordinator.animate(alongsideTransition: nil, completion: {_ in
            
            if self.currentCenterCell != nil {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
                    (self.currentCenterCell as! SelectCoffeeCollectionViewCell).appear()
                })
            }

        })
    }

    
    @objc private func swipeToViewNextPrevImage(sender: UISwipeGestureRecognizer) {
        
        // calculate center visible item against screenSize
        guard let visiblesCenterItemIndex = calculateCenterVisibleItem() else {return}
        
        // convert center item in the visibles array to full collection array
        guard let currentItem = getCurrentCellIndex(visibleIndex: visiblesCenterItemIndex) else {return}
        if sender.direction == .left || sender.direction == .right {
            let addSub = sender.direction == .left ? 1 : -1
            let nextItem = IndexPath(item: currentItem.item + addSub, section: 0)

            if nextItem.row < selectCoffeeModel?.count ?? 0 && nextItem.row >= 0 {
                
                ///breaks swiping right -- nil (next item ?? but not out of bounds interesting.
                ///solution: test nextItem for nil cases .. use more safety checks ..
                ///added guard check
                guard let currentCell = selectCoffeeCollectionView.cellForItem(at: IndexPath(item: currentItem.item, section: 0)) else {return}

                guard let nextCell = selectCoffeeCollectionView.cellForItem(at: IndexPath(item: nextItem.item, section: 0)) else {return}
                
                currentCenterCell = nextCell

                changeLayout(newCurrentCell: nextCell as! SelectCoffeeCollectionViewCell)
                
                ///handle disappear
                (currentCell as! SelectCoffeeCollectionViewCell).customizeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                ///transition to next item
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
                
                ///handle the grow
                UIView.animate(withDuration: 0.5, animations: {
                    (nextCell as! SelectCoffeeCollectionViewCell).customizeButton.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    private func calculateCenterVisibleItem() -> IndexPath? {
        for item in selectCoffeeCollectionView.visibleCells {
            
            let theAttributes:UICollectionViewLayoutAttributes! = selectCoffeeCollectionView.layoutAttributesForItem(at: selectCoffeeCollectionView.indexPath(for: item)!)
            let cellFrameInSuperview = selectCoffeeCollectionView.convert(theAttributes.frame, to: selectCoffeeCollectionView.superview).midX
            if abs(cellFrameInSuperview - selectCoffeeCollectionView.center.x) < selectCoffeeCollectionView.frame.width / 3 {
                return selectCoffeeCollectionView.indexPath(for: item)
            }
        }
        return nil
    }
    
    private func getCurrentCellIndex(visibleIndex: IndexPath) -> IndexPath? {
        let visibleItems = selectCoffeeCollectionView.indexPathsForVisibleItems as NSArray
        let visiblesIdxOfCenterItem = visibleItems.index(of: visibleIndex)
        return visibleItems.object(at: visiblesIdxOfCenterItem) as? IndexPath
    }
    
    private func changeLayout(newCurrentCell: SelectCoffeeCollectionViewCell) {
        coffeeTitle.text = newCurrentCell.title
        coffeeTitle.setLineSpacing(lineHeightMultiple: 0.72)
        
//        view.backgroundColor = newCurrentCell.bgColor
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
        
        collectionParentHeight.constant = minWidth
        
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
        
        cell.bindParentUIInfo(cellWidth: min(view.frame.width, view.frame.height) / 1.75)
        
        handleReloadButtonAnimate(indexPath: indexPath, cell: cell)
        
        if let thisSelectCoffeeItem = selectCoffeeModel?[indexPath.row] {
            cell.bindData(selectCoffeeModel: thisSelectCoffeeItem)
        }
        
        return cell
    }
    
    
    
    private func handleReloadButtonAnimate(indexPath: IndexPath, cell: SelectCoffeeCollectionViewCell) {
        indexPath.row == 0 && currentCenterCell == nil ? cell.appear() : cell.disappear()
    }
}

