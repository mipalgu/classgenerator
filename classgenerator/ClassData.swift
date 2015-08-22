//
//  ClassData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 22/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Foundation
import Darwin

class ClassData {
    
    var inputFilename: String     // user's filename including .txt
    var workingDirectory: String
    var wb: String          // name for wb class/struct, lower case with underscores starting with wb_
    var camel: String       // camel case, without underscores
    var caps: String        // upper case, including underscores
    var userName: String
    var creationDate: String
    var year: Int
    
    init(inputFilename: String) {
        
        self.inputFilename = inputFilename
        
        let nameWithoutExtension = split(inputFilename) {$0 == "."}
        // for swift 2... split(inputFilename.characters){$0 == " "}.map{String($0)}
        
        self.wb = "wb_" + nameWithoutExtension[0] // The name not including .txt, with wb_ added
        
        let words = split(nameWithoutExtension[0]) {$0 == "_"}
        
        if words.count == 1 {
            
            // only one word in the name
            self.camel = words[0]
        }
        else {
            
            // more than one word, make camel case
            var camelCase: String = ""
            var wordToAdd = words[0]
            for word in words {
                if count(camelCase) > 0 {
                    wordToAdd = word.capitalizedString     // don't use: FOUNDATION
                }
                camelCase += wordToAdd
            }
            
            self.camel = camelCase
        }
        
        self.caps = nameWithoutExtension[0].uppercaseString    // don't use: FOUNDATION
        
        let pw = getpwuid(getuid())
        if pw != nil {
            self.userName = String.fromCString(pw.memory.pw_name)!
        }
        else {
            self.userName = "YOUR NAME"
        }
        
        println("user is: \(self.userName)")
        
        // get working directory  **** DO AUTOMATICALLY INCL LINUX ****
        self.workingDirectory = "/Users/\(self.userName)/src/MiPal/GUNao/posix/classgenerator/classgenerator/"
        
        var t = time(nil)    /// error check  ***************
        var currentTime = ctime(&t)
        self.creationDate = String.fromCString(currentTime)!
        
        self.year = 2015   /// TO DO  ***************
    }
}
