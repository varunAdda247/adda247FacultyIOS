//
//  ADClassDataCell.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 26/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADClassDataCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var classNameLbl: UILabel!
    @IBOutlet weak var centerLbl: UILabel!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var parentContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView?.layer.cornerRadius = 5
        self.containerView?.layer.masksToBounds = true
        
        self.containerView?.layer.borderColor = UIColor.packageCellBorderColor().cgColor
        self.containerView?.layer.borderWidth = 1
        self.containerView?.clipsToBounds = true

        
        let path = UIBezierPath(roundedRect:parentContentView.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5, height:  5))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        parentContentView.layer.mask = maskLayer
        
        self.classNameLbl.sizeToFit()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
