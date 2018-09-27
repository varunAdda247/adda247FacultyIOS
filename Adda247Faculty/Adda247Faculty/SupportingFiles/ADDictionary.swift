//
//  ADDictionary.swift
//  Adda247
//
//  Created by Varun Tomar on 24/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import Foundation

extension Dictionary
{
    /**
     Method to add key-value pairs in Dictionary. We cannot add optionals in a dictionary. So to avoid checking while adding optional values in dictionary, this method can be used.
     If the optional is nil, no key-value pair added
     If the optional has some value, it is unwrapped and a key-value pair is added
     
     -warning: Can only be used with Optional Values
     
     - parameter key:   Key of the key-value pair to be added
     - parameter value: Optional value of the key-value pair to be added
     */
    mutating func addObject(_ key : Key, value : Value?)
    {
        if let object = value
        {
            self[key] = object
        }
    }
    
    /**
     Method to create a url string from a dictionary. This method converts key-value pairs of a dictionary into a string that represents a url. This url is then used in the API hit
     
     - returns: urlString - string corresponding to the dictionary key-value pairs
     */
    func urlString() -> String
    {
        var string : String = ""
        
        for key in self.keys
        {
            string += "&\(key)=\(self[key]!)"
        }
        return string
    }
    
    /**
     This method either return value or nil for a particular key in the dictionary. It checks for empty string/only whitespaces string. If the string is empty/only white space, it returns nil.
     
     ** Initially it is only handled for String. If required for any other Types you can add to the function itself.
     
     - returns: value - corresponsing to key in the dictionary
     */
    func valueOrNilForKey(_ key : Key) -> Value?
    {
        if let value = self[key]
        {
            if let stringValue = value as? String, !stringValue.isBlank
            {
                return stringValue as? Value
            }
        }
        return nil
    }
    
    func jsonFromDictionary(params: Dictionary) -> String {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            return theJSONText!
        }
        return ""
    }
}
