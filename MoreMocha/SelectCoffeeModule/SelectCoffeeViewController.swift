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
    private var currentCenterIndex: IndexPath?
    private var cellSpacing: CGFloat = 0.0
    private var cellWidth: CGFloat = 0.0
    private var cellOffset: CGFloat = 0.0

    fileprivate var selectCoffeeModel: [SelectCoffeeModel]?

    
    
    //Mark: - IBOutlets
    @IBOutlet weak var coffeeTitle: UILabel!
    @IBOutlet weak var coffeeDetails: UILabel!
    @IBOutlet weak var selectCoffeeCollectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionParentHeight: NSLayoutConstraint!
    
    
    
    //Mark: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        setSizes()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        selectCoffeeViewModel = SelectCoffeeViewModel()
        requestCoffeedata()
    }


    private func requestCoffeedata() {
        selectCoffeeViewModel?.requestCoffee().subscribe(onNext: { (selectCoffeeModel) in
            self.selectCoffeeModel = selectCoffeeModel
            self.setUpSwipeGestures()
        }).disposed(by: disposeBag)
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
        selectCoffeeCollectionConfigration()
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
            setSizes()
        }
    }
    
    
    
    //Mark: - autoTriggeredFunction
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {_ in
            self.setSizes()
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
                
                currentCenterIndex = nextItem
                
                changeLayout(newCurrentCell: nextCell as! SelectCoffeeCollectionViewCell)
                
                ///handle disappear
                (currentCell as! SelectCoffeeCollectionViewCell).customizeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                ///transition to next item
                self.selectCoffeeCollectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
               
                ///handle the grow
                UIView.animate(withDuration: 0.5, animations: {
                    (nextCell as! SelectCoffeeCollectionViewCell)
                        .customizeButton.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    
    
    //Mark: - functions
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
        view.backgroundColor = newCurrentCell.bgColor
    }
    
    
    //Mark: - IBAction
    @IBAction func didFinishSelectingCoffee(_ sender: Any) {
    }
}



















//Mark: - CollectionView Handling

extension SelectCoffeeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    private func setSizes() {
        let screenWidth = view.frame.width
        let minWidth = min(screenWidth, view.frame.height)
        
        
        ///what percent of screen is:
        ///1/6cup, gap, cup, gap, 1/6 cup
        /// .05 .225, .45, .225, .05
        ///&& off set is 1/6 cup + gap
        ///landscape is
        ///.068333, .22667, .41, .22667, .068333
        
        var sizeMultiplier: CGFloat = 0.41
        let halfCupSize = minWidth * sizeMultiplier / 2
        var cellSpacingMultiplier: CGFloat = screenWidth * 0.22667 + halfCupSize
        var offSet = screenWidth * 0.295 + halfCupSize
        
        
        if UIDevice.current.orientation == .portrait {
            sizeMultiplier = 0.45
            cellSpacingMultiplier = screenWidth * 0.225
            offSet = screenWidth * 0.275
        }
        
        
        cellWidth = minWidth * sizeMultiplier
        collectionParentHeight.constant = cellWidth
        cellSpacing = cellSpacingMultiplier
        cellOffset = offSet

        selectCoffeeCollectionView.collectionViewLayout.invalidateLayout()
        
        if self.currentCenterIndex != nil {
        
            //scroll to needs to wait until rotation
            self.selectCoffeeCollectionView.scrollToItem(at: self.currentCenterIndex!, at: .centeredHorizontally, animated: false)
            
            //animation needs to wait until scroll finished
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.20, execute: {(
                self.selectCoffeeCollectionView.cellForItem(at: self
                    .currentCenterIndex!) as! SelectCoffeeCollectionViewCell)
                    .customizeButton.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        ///space too wide(big) (pad land) --- possible because pad width ratio bigger ---- only if launched in landscape initially .. same with iphone 5s
        return cellSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        ///offset too far right(big) pad portrait ---- only if launched in landscape initially .. / same with iphone 5s /// --- considering my calculation for spacing is not accurately dynamic
        ///.. solution is to consider the math
        return UIEdgeInsets(top: 0, left: cellOffset, bottom: 0, right: cellOffset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectCoffeeModel?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCoffeeCell", for: indexPath) as! SelectCoffeeCollectionViewCell
        
        cell.bindParentUIInfo(cellWidth: cellWidth)
        
        indexPath.row == 0 ? cell.appear() : cell.disappear()
        
        if let thisSelectCoffeeItem = selectCoffeeModel?[indexPath.row] {
            cell.bindData(selectCoffeeModel: thisSelectCoffeeItem)
        }
        
        return cell
    }
}

