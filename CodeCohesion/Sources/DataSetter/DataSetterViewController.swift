//
//  DataSetterViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class DataSetterViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!

    var count: Int = 0 {
        didSet {
            textLabel.text = "\(count)"
        }
    }
    
    @IBAction func addOne(_ sender: Any) {
        count += 1
        //        textLabel.text = "\(count)"
    }
    
    @IBAction func subOne(_ sender: Any) {
        count -= 1
        //        textLabel.text = "\(count)"
    }
}
