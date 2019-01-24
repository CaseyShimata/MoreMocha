//
//  ColorDarknessDetector.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/24/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        print(white)
        return white > 0.5
    }
}
