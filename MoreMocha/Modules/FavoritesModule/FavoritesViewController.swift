//
//  FavoritesViewController.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/23/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.selectedItem = self.tabBar.items![0]

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





//Mark: - CollectionView Handling

extension FavoritesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let viewTitle = item.title else {return}
        
        let nextView = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: viewTitle.lowercased())
        
        present(nextView, animated: true)
        
    }
    
}
