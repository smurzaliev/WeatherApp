//
//  UIExtensions.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return self.snp
        #else
            return self.snp
        #endif
    }
}
