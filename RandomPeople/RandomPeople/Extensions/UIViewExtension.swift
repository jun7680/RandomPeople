//
//  UIViewExtension.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/31.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
