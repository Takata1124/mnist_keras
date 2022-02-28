//
//  UIcolor.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/08.
//

import Foundation
import UIKit

extension UIColor {
    
    static  func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }  
}
