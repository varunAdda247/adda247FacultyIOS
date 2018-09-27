//
//  ADFont.swift
//  Adda247
//
//  Created by Varun Tomar on 23/05/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

extension UIFont{
    
    static func navigationBarFont()-> UIFont{
        return UIFont(name: "Avenir-Heavy", size: 17.0)!
    }
    
    static func sectionHeaderFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 13.0)!
    }
    
    static func paidQuizresultSectionHeaderFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 16.0)!
    }

    
    static func tableCellHeadingFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 15.0)!
    }
    
    static func tableUnreadCellHeadingFont()-> UIFont{
        return UIFont(name: "Avenir-Heavy", size: 15.0)!
    }

    static func tableCellDescriptionFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 13.0)!
    }
    
    static func navigationBarSubHeadingFont()-> UIFont{
        return UIFont(name: "Avenir-Book", size: 11.0)!
    }
    
    static func navigationBarHeadingFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 15.0)!
    }
    
    static func homeNavigationBarItemFont()-> UIFont{
        return UIFont(name: "Avenir-Heavy", size: 17.0)!
    }
    
    static func questionTextFont()-> UIFont{
        return UIFont(name: "Avenir-Book", size: 14.0)!
    }

    static func paidQuizDetailedResultOverviewLargeTextFont()-> UIFont{
        return UIFont(name: "Avenir-Heavy", size: 32.0)!
    }

    static func paidQuizDetailedResultOverviewSmallTextFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 20.0)!
    }
    
    static func paidQuizDetailedResultOverviewPercentileTextFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 24.0)!
    }
    
    static func paidQuizDetailedResultOverviewPercentTextFont()-> UIFont{
        return UIFont(name: "Avenir-Medium", size: 16.0)!
    }
}
