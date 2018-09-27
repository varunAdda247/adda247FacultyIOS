//
//  ADError.swift
//  Adda247
//
//  Created by Varun Tomar on 05/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

class ADError: Error {
    
    open var domain: String = ""
    open var code: Int = 0
    open var localizedDescription: String = ""
    
    init(errorDomain domain:String,errorCode code:Int, localizedDescription description:String) {
        
        self.domain = domain
        self.code = code
        self.localizedDescription = description
    }
    
    
    convenience init(description:String) {
        
        self.init(errorDomain: "",errorCode: 1, localizedDescription: "")
        self.localizedDescription = description
        
    }
    
    convenience init(code:Int) {
        
        self.init(errorDomain: "",errorCode: 1, localizedDescription: "Something went wrong")
        self.code = code
        
    }
}
