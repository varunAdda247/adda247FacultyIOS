//
//  ADDouble.swift
//  Adda247
//
//  Created by Varun Tomar on 06/06/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    var shortValue: String {
        return String(format: "%g", self)
    }
}

//extension Double {
//    var removeZero:String {
//        let nf = NumberFormatter()
//        nf.minimumFractionDigits = 0
//        nf.maximumFractionDigits = 0
//        let tempNumber = NSNumber(value: self)
//        return nf.string(for: self)//nf.stringFromNumber(self)!
//    }
//}


