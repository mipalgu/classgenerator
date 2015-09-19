//
//  ClassData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 22/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//


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
        
        self.inputFilename = inputFilename + ".txt"
        
        //let nameWithoutExtension = inputFilename.characters.split {$0 == "."}.map { String($0) }
        
        // make wb_ name : the name not including .txt, with wb_ added
        self.wb = "wb_" + inputFilename
        
        // split the name into words, delimited by underscore
        let words = inputFilename.characters.split {$0 == "_"}.map { String($0) }
        
        self.camel = camelCaseWord(words)
        self.caps = uppercaseWord(inputFilename)
        
        // get user name
        self.userName = getUserName()   // might need to read the username as a command line arg
        
        // get working directory
        self.workingDirectory = getPath()
        
        var t = time(nil)    /// error check and set default value ***************
        self.creationDate = String.fromCString(ctime(&t))!
        
        self.year = 2015   /// TO DO  ***************
    }
}


func getUserName() -> String {
    
    let pw = getpwuid(getuid())
    
    if pw != nil {
        return String.fromCString(pw.memory.pw_name)!
    }
    else {
        return "YOUR NAME"
    }
}


func getPath() -> String {
    
    var cwd: [Int8] = Array(count: Int(MAXPATHLEN), repeatedValue: 0)
    let path = getcwd(&cwd, Int(MAXPATHLEN))                               /// error check ***************
    //print("Working directory: \(String.fromCString(path)!)")
    
    return String.fromCString(path)! + "/"
}

