//
//  File.swift
//  Adda247
//
//  Created by Moazzam Ali Khan on 16/07/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

protocol ADFilterQuizTableViewCellProtocol {
    func populate(_ quizStatus:String,selected: Bool)
    func populate(_ title:String,subTitle:String,selected: Bool)
}

