//
//  selectCoffeeViewModel.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/19/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit
import RxSwift

class SelectCoffeeViewModel: NSObject {
    
    public func requestCoffee() -> Observable<[SelectCoffeeModel]?> {
        return SelectCoffeeService.requestCoffee()
    }
    
}
