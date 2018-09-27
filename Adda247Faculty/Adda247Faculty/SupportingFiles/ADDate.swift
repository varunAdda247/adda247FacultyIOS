//
//  ADDate.swift
//  Adda247
//
//  Created by Varun Tomar on 01/05/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var millisecondsSince1970:Double {
        return ((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
