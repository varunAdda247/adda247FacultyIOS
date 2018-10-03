//
//  ADColor.swift
//  Adda247
//
//  Created by Varun Tomar on 04/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    static func navigationBarColor()-> UIColor{
        //UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        return UIColor(red: 03.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func backgroundThemeColor()-> UIColor{
    
        return UIColor(red: 03.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func pinkThemeColor()-> UIColor{
        
        return UIColor(red: 255.0/255.0, green: 64.0/255.0, blue: 129.0/255.0, alpha: 1.0)
    }

    static func activityLoaderColor()-> UIColor{
        
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    }

    
    static func lightGreySeperatorColor()-> UIColor{
        
        return UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    }
    
    static func tabBarBackgroundColor()-> UIColor{
        return UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    
    
    
    
    static func sectionHeaderTextColor()-> UIColor{
        return UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    }
    
    static func paidQuizResultSectionHeaderTextColor()-> UIColor{
        return UIColor(red: 81.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    }
    
    static func sectionHeaderBackgroundColor()-> UIColor{
        return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func tableCellHeadingReadTextColor()-> UIColor{
        return UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)

    }
    
    static func tableCellHeadingDailyGkTextColor()-> UIColor{
        return UIColor(red: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func tableCellHeadingUnreadTextColor()-> UIColor{
        return UIColor(red: 3.0/255.0, green: 3.0/255.0, blue: 3.0/255.0, alpha: 1.0)
    }
    
    static func tableCellDescriptionTextColor()-> UIColor{
        return UIColor(red: 143.0/255.0, green: 142.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    }
    
    static func tableReadCellBackgroundColor()-> UIColor{
        return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    //QUIZ
    
    static func lightGreyBackgroundColor()-> UIColor{
        return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func quizAttemptColor()-> UIColor{
        return UIColor(red: 139.0/255.0, green: 195.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    static func quizGetColor()-> UIColor{
        return UIColor(red: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    static func quizViewResultColor()-> UIColor{
        return UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    }
    
    static func quizFetchingColor()-> UIColor{
        return UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
    
    static func quizResumeColor()-> UIColor{
        return UIColor(red: 255.0/255.0, green: 64.0/255.0, blue: 129.0/255.0, alpha: 1.0)
    }

    static func questionNotAttamptedColor()-> UIColor{
        return UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
    
    static func questionAttamptedColor()-> UIColor{
        return UIColor(red: 255.0/255.0, green: 147.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    }
    
    static func questionAnsweredColor()-> UIColor{
        return UIColor(red: 139.0/255.0, green: 195.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    static func questionNotAnsweredColor()-> UIColor{
        return UIColor(red: 255.0/255.0, green: 147.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    }

    static func questionMarkForReviewColor()-> UIColor{
        return UIColor(red: 134.0/255.0, green: 99.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    }
    
    static func questionDefaultColor()-> UIColor{
        return UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
    
    static func nextQuestionBtnColor()-> UIColor{
        return UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    }
    
    static func correctAnsweredColor()-> UIColor{
        return UIColor(red: 139.0/255.0, green: 195.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    static func wrongAnsweredColor()-> UIColor{
        return UIColor(red: 223.0/255.0, green: 94.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
    
    static func quizResultSubbjectWiseCellLightBlueBackgroundColor()-> UIColor{
        return UIColor(red: 243.0/255.0, green: 251.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    //#FFD9E6
    static func quizHighletedColor()-> UIColor{
        return UIColor(red: 255.0/255.0, green: 217.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    
    //#EFEFF4
    static func viewResultQuizCellBackgroundColor()-> UIColor{
        return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }

    static func packageCellBorderColor()-> UIColor{
        return UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
    
    static func comingSoonTextColor()-> UIColor{
        return UIColor(red: 143.0/255.0, green: 142.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    }
    
    //Paid result analysis
    static func paidQuizResultGreyColor()-> UIColor{
        return UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }
    
    static func paidQuizResultGreyTextColor()-> UIColor{
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    //Paid result blue text color
    static func paidQuizResultTextBlueColor()-> UIColor{
        return UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    }
    
    //Paid result blue text color
    static func paidQuizResultTextGreyColor()-> UIColor{
        return UIColor(red: 81.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    }
    
    static func paidQuizBlueTextColor()-> UIColor{
        return UIColor(red: 2.0/255.0, green: 119.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    }

    
    //Grey Border colour
    //UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    static func greyBorderColor()-> UIColor{
        return UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
}
