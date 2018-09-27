//
//  ADString.swift
//  Adda247
//
//  Created by Varun Tomar on 19/04/17.
//  Copyright © 2017 Metis Eduvantures Pvt. Ltd. All rights reserved.
//

import UIKit

extension String{
    
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
    
    //- This is a computed property that returns whether the string is empty after trimming all the white spaces and newlines.
    var isBlank : Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String{
    func isEmailValid(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
}

extension String{
    func isPhoneNumberValid() -> Bool {
        if self.isAllDigits() == true {
            return true
            
//            let phoneRegex = "[235689][0-9]{6}([0-9]{3})?"
//            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//            return  predicate.evaluate(with: self)
        }else {
            return false
        }
        
    }
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
}

extension String{
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = characters.index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}

extension String {
    var int16Value: Int16 {
        return Int16((self as NSString).intValue)
    }
}

extension String {
    var int32Value: Int32 {
        return (self as NSString).intValue
    }
}

extension String {
    func matches(for regex: String!, in text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension String {
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}

//extension String {
//    func dropLast(_ n: Int = 1) -> String {
//        return String(characters.dropLast(n))
//    }
//    var dropLast: String {
//        return dropLast()
//    }
//}

