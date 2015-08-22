//
//  Filename.swift
//  classgenerator
//
//  Created by Mick Hawkins on 22/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//


class Filename {
    
    var inputFilename: String     // user's filename including .txt
    var workingDirectory: String
    var wb: String          // name for wb class/struct, lower case with underscores starting with wb_
    var camel: String       // camel case, without underscores
    var caps: String        // upper case, including underscores
    
    
    init(inputFilename: String) {
        
        self.inputFilename = inputFilename
        
        // get working directory  **** DO AUTOMATICALLY  ****
        self.workingDirectory = "/Users/mick/src/MiPal/GUNao/posix/classgenerator/classgenerator/"
        
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
                    wordToAdd = word.capitalizedString
                }
                camelCase += wordToAdd
            }
            
            self.camel = camelCase
        }
        
        self.caps = nameWithoutExtension[0].uppercaseString
    }
}
