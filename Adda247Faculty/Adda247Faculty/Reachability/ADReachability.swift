//
//  ADReachability.swift
//  Adda247
//
//  Created by Varun Tomar on 31/03/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

extension Reachability
{
    static func connectionAvailable() -> Bool
    {
        let reachability:Reachability? = Reachability()
        guard let rbility = reachability else
        {
            return false
        }
        return rbility.isReachable
    }
}
