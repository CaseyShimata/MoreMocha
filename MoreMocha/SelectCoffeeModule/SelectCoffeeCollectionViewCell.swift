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
    
    //Mark: - IBOutlet
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var customizeButton: UIButton!
    @IBOutlet weak var cupShadowImage: UIImageView!
    
    //Mark: - functions
    public func bindData(selectCoffeeModel: SelectCoffeeModel?) -> Void {
        guard let imageUrlString = selectCoffeeModel?.imageUrl else {return}
        coffeeImageView.kf.setImage(with: URL(string: imageUrlString))
        name = selectCoffeeModel?.name
        title = selectCoffeeModel?.title
        bgColor = hexToUIColor(selectCoffeeModel?.backgroundColor ?? "#ffffff")
    }
    
    public func addShadow(endCellWidth: CGFloat) {
        cupShadowImage.backgroundColor = UIColor.brown
        cupShadowImage.layer.shadowColor = UIColor.black.cgColor
        cupShadowImage.layer.shadowOffset = CGSize(width: 20, height: 20)
        cupShadowImage.layer.shadowOpacity = 1.0
        cupShadowImage.clipsToBounds = false
        cupShadowImage.layer.cornerRadius = endCellWidth / 4
        cupShadowImage.layer.shadowRadius = endCellWidth / 4
    }
    
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
