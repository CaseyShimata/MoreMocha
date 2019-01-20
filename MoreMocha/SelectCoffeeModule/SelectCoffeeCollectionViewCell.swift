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
    
    
    //Mark: - IBOutlet
    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var customizeButton: UIButton!
    
    //Mark: - functions
    public func bindData(selectCoffeeModel: SelectCoffeeModel?) -> Void {
        guard let imageUrlString = selectCoffeeModel?.imageUrl else {return}
        coffeeImageView.kf.setImage(with: URL(string: imageUrlString))
    }
    
    //Mark: - IBAction
    @IBAction func didSelectCustomizeButton(_ sender: Any) {
        //pop over with text field, static collection view, static tableview and submit button
    }
    

    
}
