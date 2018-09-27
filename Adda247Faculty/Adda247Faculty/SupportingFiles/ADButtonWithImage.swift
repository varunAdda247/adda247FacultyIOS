//
//  ADButtonWithImage.swift
//  Adda247
//
//  Created by Varun Tomar on 16/05/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

class ADButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
