//
//  UIScrollView+extensions.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import UIKit
import SnapKit

extension UIScrollView {
    func applyVerticalStyle() {
        self.backgroundColor = Colors.white
        self.isScrollEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = false
    }
}
