//
//  ADClassInfoHeadingSubHeadingAndImageCell.swift
//  Adda247Faculty
//
//  Created by Varun Tomar on 27/09/18.
//  Copyright © 2018 Adda247. All rights reserved.
//

import UIKit

class ADClassInfoHeadingSubHeadingAndImageCell: UITableViewCell,ADClassStatusTableViewCellProtocol {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
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
    
    func populate(_ title: String, subTitle: String) {
       
    }
    
    func populate(_ title:String,subTitle:String,iconImage:String)
    {
        headingLbl.text = title
        subHeadingLbl.text = subTitle
    }

}
