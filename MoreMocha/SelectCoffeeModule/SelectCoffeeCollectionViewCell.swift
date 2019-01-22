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
    
    //Mark: - IBOutlet
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var cupShadowImage: UIImageView!
    @IBOutlet weak var customizeButton: UIButton!
    
    @IBOutlet weak var cupShadowImageWidth: NSLayoutConstraint!
    @IBOutlet weak var cupShadowImageHeight: NSLayoutConstraint!
    @IBOutlet weak var customizeWidth: NSLayoutConstraint!
    @IBOutlet weak var customizeHeight: NSLayoutConstraint!
    @IBOutlet weak var cupHeight: NSLayoutConstraint!
    @IBOutlet weak var cupWidth: NSLayoutConstraint!
    
    //Mark: - dataFunctions
    public func bindData(selectCoffeeModel: SelectCoffeeModel?) -> Void {
        name = selectCoffeeModel?.name
        title = selectCoffeeModel?.title
        bgColor = hexToUIColor(selectCoffeeModel?.backgroundColor ?? "#ffffff")
        guard let imageUrlString = selectCoffeeModel?.imageUrl else {
            cupShadowImage.alpha = 0.0
            coffeeImageView.image = UIImage(named: "No_image_available.jpg")
            return
        }
        coffeeImageView.kf.setImage(with: URL(string: imageUrlString))
    }
    
    //Mark: = UIfunctions
    public func bindParentUIInfo(cellWidth: CGFloat) {
        parentWidth = cellWidth
        adjustCoffeeImage()
        adjustcupShadowImage()
        adjustCustomizeButton()
    }
    
    public func adjustCoffeeImage() {
        coffeeImageView.clipsToBounds = false
        cupWidth.constant = parentWidth!
        cupHeight.constant = parentWidth!
    }

    public func adjustcupShadowImage() {
        let heightAndWidth = parentWidth! * 0.48
        cupShadowImage.backgroundColor = UIColor.brown
        cupShadowImage.clipsToBounds = false
        cupShadowImage.layer.cornerRadius = heightAndWidth / 2
        cupShadowImageWidth.constant = heightAndWidth
        cupShadowImageHeight.constant = heightAndWidth

        let shadowPath = UIBezierPath(rect: CGRect(x: parentWidth! * 0.05, y: parentWidth! * 0.166, width: parentWidth! * 0.75, height: parentWidth! * 0.75))
        cupShadowImage.layer.masksToBounds =  false
        cupShadowImage.layer.shadowColor = UIColor.purple.cgColor
        cupShadowImage.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
        cupShadowImage.layer.shadowOpacity =  0.4
        cupShadowImage.layer.shadowRadius = 55.0
        cupShadowImage.layer.shadowPath = shadowPath.cgPath
    }
    
    public func adjustCustomizeButton() {
        customizeButton.clipsToBounds = false
        customizeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        customizeWidth.constant = parentWidth! * 0.17
        customizeHeight.constant = parentWidth! * 0.17
        customizeButton.layer.cornerRadius = parentWidth! * 0.17 / 2
    }

    
    //Mark: = animationFunctions
    public func disappear() {
        customizeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    public func appear() {
        UIView.animate(withDuration: 0.25, animations: {
            print("appear hit")
            self.customizeButton.transform = CGAffineTransform.identity
        })
    }
    
    //Mark: - IBAction
    @IBAction func didSelectCustomizeButton(_ sender: Any) {
        //pop over with text field, static collection view, static tableview and submit button
    }
    

    
}
