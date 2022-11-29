//
//  UILabel+setKerning.swift
//  OCD
//
//  Created by Andy Mockler on 6/16/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit

extension UILabel {
    func setKerning(amount: CGFloat) {
        if text != nil {
            let attributedString = NSMutableAttributedString(string: text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: amount, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
