//
//  ADSequence.swift
//  Adda247
//
//  Created by Varun Tomar on 16/07/18.
//  Copyright © 2018 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

public extension Sequence where Iterator.Element: Hashable {
    var uniqueElements: [Iterator.Element] {
        return Array( Set(self) )
    }
}
public extension Sequence where Iterator.Element: Equatable {
    var uniqueElements: [Iterator.Element] {
        return self.reduce([]){
            uniqueElements, element in
            
            uniqueElements.contains(element)
                ? uniqueElements
                : uniqueElements + [element]
        }
    }
}
