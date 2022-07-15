//
//  UIView+Extension.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/15.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
