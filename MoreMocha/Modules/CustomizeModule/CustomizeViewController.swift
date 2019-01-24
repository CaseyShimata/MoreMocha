//
//  CustomizeViewController.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/23/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit

protocol CustomizeDelegate {
    func passBackInfo(name: String, size: String, options: [String: String])
}

class CustomizeViewController: UIViewController {

    
    //Mark: - Properties
    public var delegate: CustomizeDelegate?
    private var size = "smaßll"
    private var options = [String: String]()
    
    private var choices = ["cream","sugar","splenda","carmel sauce","chocolate sauce","extra shot"]
    
    
    //Mark: - IBOutlet
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var small: UIButton!
    @IBOutlet weak var medium: UIButton!
    
    @IBOutlet weak var large: UIButton!
    
    
    //Mark: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //Mark: - functions
    private func buttonClicked(_ button: UIButton?) {
        small.backgroundColor = UIColor.yellow
        small.backgroundColor = UIColor.orange
        small.backgroundColor = UIColor.red
        size = button?.titleLabel?.text ?? "small"
        button?.backgroundColor = UIColor.green
    }
    
    
    //Mark: - IBAction
    @IBAction func finished(_ sender: Any) {
        if let delegate = delegate {
            self.delegate = nil
            dismiss(animated: true, completion: {
                delegate.passBackInfo(name: self.name.text ?? "", size: self.size, options: self.options)
            })
        }
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickedSmall(_ sender: Any) {
        buttonClicked(sender as? UIButton)
    }
    
    @IBAction func clickedMedium(_ sender: Any) {
        buttonClicked(sender as? UIButton)
    }
    
    @IBAction func clickedLarge(_ sender: Any) {
        buttonClicked(sender as? UIButton)
    }
    

}









//Mark: - table view
extension CustomizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choicesCell", for: indexPath)
        cell.textLabel!.text = choices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                options[cell.textLabel?.text ?? ""] = cell.textLabel?.text ?? ""
            }else {
                cell.accessoryType = .none
                options[cell.textLabel?.text ?? ""] = nil
            }
        }
    }
    
    
}
