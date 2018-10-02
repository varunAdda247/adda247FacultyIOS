//
//  ADClassInfoHeadingSubHeadingImageAndButton.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 27/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADClassInfoHeadingSubHeadingImageAndButtonCell: UITableViewCell,ADClassStatusTableViewCellProtocol {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        headingLbl.text = nil
        subHeadingLbl.text = nil
    }
    
    func populate(_ title:String,subTitle:String,iconImage:String) {
        
    }
}
