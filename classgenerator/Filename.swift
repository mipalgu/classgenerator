//
//  Filename.swift
//  classgenerator
//
//  Created by Mick Hawkins on 22/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//


class Filename {
    
    var inputFilename: String     // filename including
    var workingDirectory: String
    var wb: String          // name for wb class/struct, lower case with underscores starting with wb_
    var camel: String       // camel case, without underscores
    var caps: String        // upper case, including underscores
    
    
    init(inputFilename: String) {
        
        self.inputFilename = inputFilename
        
        // get working directory
        self.workingDirectory = "/Users/mick/src/MiPal/GUNao/posix/classgenerator/classgenerator/"
        
        let nameWithoutExtension = split(inputFilename) {$0 == "."}
        // for swift 2... split(inputFilename.characters){$0 == " "}.map{String($0)}
        
        self.wb = "wb_" + nameWithoutExtension[0] // The name not including .txt
        
        let words = split(nameWithoutExtension[0]) {$0 == "_"}
        
        if words.count == 1 {
            
            // only one word in the name
            self.camel = words[0]
        }
        else {
            
            // more than one word, make camel case
            
            
        }
        
        
        
    }
    
    
    func camelCase (name: String) -> String {
        
        // create wb filename
        var fileNameParts = inputFileName.componentsSeparatedByString(".")
        
        // just need the first part
        var structName = "wb_" + fileNameParts[0]
        
        println(structName)
        return structName
        
    }
    
    
    
    // var cFilePath : String = workingDirectory + "/" + structName + ".h"
    
    
    
    
}
