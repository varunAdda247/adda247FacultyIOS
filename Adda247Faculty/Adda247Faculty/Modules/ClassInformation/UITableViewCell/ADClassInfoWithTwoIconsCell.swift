//
//  ADClassInfoWithTwoIconsCell.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 27/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import Foundation
import UIKit

class ADClassInfoWithTwoIconsCell: UITableViewCell,ADClassStatusTableViewCellProtocol {
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var iconImage1: UIImageView!
    @IBOutlet weak var iconImage2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
//        startTimeLbl.text = nil
//        endTimeLbl.text = nil
    }
    
    func populate(_ title:String,subTitle:String,iconImage:String) {
        
    }
    
    func populate(startTime:String, endTime:String)  {
        startTimeLbl.text = startTime
        endTimeLbl.text = endTime
    }
}
