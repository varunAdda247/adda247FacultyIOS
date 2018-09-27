//
//  ADUnderLinedLabel.swift
//  Adda247
//
//  Created by Varun Tomar on 19/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

class ADUnderLinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedStringKey , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
