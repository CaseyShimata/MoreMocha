//
//  SelectCoffeeService.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/19/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit
import RxSwift
import Firebase
import CodableFirebase

class SelectCoffeeService: NSObject {
    
    public static func requestCoffee() -> Observable<[SelectCoffeeModel]?> {
        
        return Observable.create({ (observer) -> Disposable in
            Firestore.firestore().collection("Drink").getDocuments()
                { (result, error) in
                    if error == nil {
                        
                        var coffeeModelArray = [SelectCoffeeModel]()
                        
                        result?.documents.map({
                            do {
                                let selectCoffeeModelInstance = try FirebaseDecoder().decode(SelectCoffeeModel.self, from: $0.data())
                                coffeeModelArray.append(selectCoffeeModelInstance)
                            } catch let error {
                                print("error coercing firebase data to model: \(error)")
                            }
                        })

                        observer.onNext(coffeeModelArray)
                    } else {
                        observer.onError(error!)
                    }

                }
            return Disposables.create()
        })
    }
}
