//
//  SelectCoffeeCollectionViewCell.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/19/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//
import UIKit
import Kingfisher

class SelectCoffeeCollectionViewCell: UICollectionViewCell {

    //Mark: - properties
    var name: String?
    var title: String?
    var bgColor: UIColor?
    var details: String?
    var parentWidth: CGFloat?
    var parentView: UIViewController?

    //Mark: - IBOutlet
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var customizeButton: UIButton!

    @IBOutlet weak var customizeWidth: NSLayoutConstraint!
    @IBOutlet weak var customizeHeight: NSLayoutConstraint!
    @IBOutlet weak var cupHeight: NSLayoutConstraint!
    @IBOutlet weak var cupWidth: NSLayoutConstraint!

    //Mark: - dataFunctions
    public func bindData(selectCoffeeModel: SelectCoffeeModel?, parentView: UIViewController?) -> Void {
        self.parentView = parentView
        name = selectCoffeeModel?.name
        title = selectCoffeeModel?.title
        bgColor = hexToUIColor(selectCoffeeModel?.backgroundColor ?? "#ffffff")

        guard let imageUrlString = selectCoffeeModel?.imageUrl else {
            coffeeImageView.image = UIImage(named: "No_image_available.jpg")
            return
        }

        coffeeImageView.kf.setImage(with: URL(string: imageUrlString))
    }



    //Mark: = UIfunctions
    public func bindParentUIInfo(cellWidth: CGFloat) {
        parentWidth = cellWidth
        adjustCoffeeImage()
        adjustCustomizeButton()
    }


    public func adjustCoffeeImage() {
        coffeeImageView.clipsToBounds = false
        cupWidth.constant = parentWidth!
        cupHeight.constant = parentWidth!
//        coffeeImageView.alpha = 0.0
        
        let shadowPath = UIBezierPath(rect: CGRect(x: parentWidth! * 0.20, y: parentWidth! * 0.5, width: parentWidth! * 0.80, height: parentWidth! * 0.95))
        
        coffeeImageView.layer.masksToBounds = false
        coffeeImageView.layer.shadowColor = UIColor.black.cgColor
        coffeeImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        coffeeImageView.layer.shadowOpacity = 0.3
        
        coffeeImageView.layer.shadowRadius = parentWidth! * 0.16
        coffeeImageView.layer.shadowPath = shadowPath.cgPath

    }

    public func adjustCustomizeButton() {
        customizeButton.clipsToBounds = false
        customizeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        customizeWidth.constant = parentWidth! * 0.26
        customizeHeight.constant = parentWidth! * 0.26
        customizeButton.layer.cornerRadius = parentWidth! * 0.26 / 2
    }


    //Mark: = animationFunctions
    public func disappear() {
        customizeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }

    
    public func appear() {
        UIView.animate(withDuration: 0.25, animations: {
            self.customizeButton.transform = CGAffineTransform.identity
        })
    }

    

    //Mark: - IBAction
    @IBAction func didSelectCustomizeButton(_ sender: Any) {
        //pop over with text field, static collection view, static tableview and submit button
        guard let parent = parentView else {return}
        
        let nextView = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "customize")
        
        (nextView as? CustomizeViewController)?.delegate = parent as? CustomizeDelegate
        
        parent.present(nextView, animated: true)

    }
}

