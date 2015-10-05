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
    var cpp: String         // c++ class
    var userName: String
    var creationDate: String
    var year: Int
    
    init(workingDirectory: String, inputFilenameNoExtension: String, userName: String) {
        
        self.inputFilename = inputFilenameNoExtension + ".txt"
        
        // make wb_ name : the name not including .txt, with wb_ added
        self.wb = "wb_" + lowercaseWord(inputFilenameNoExtension)
        
        // split the name into words, delimited by underscore
        let words = inputFilenameNoExtension.characters.split {$0 == "_"}.map { String($0) }
        
        self.camel = camelCaseWord(words)
        self.caps = uppercaseWord(inputFilenameNoExtension)
        self.cpp = cppWord(words)
        
        // get user name
        self.userName = userName
        
        // get working directory
        self.workingDirectory = workingDirectory
        
        var t = time(nil)     // ********* error check *********
        var timeInfo = tm()
        localtime_r(&t, &timeInfo)
        
        self.year = Int(timeInfo.tm_year) + 1900
//        self.creationDate = String.fromCString(ctime(&t))!
        self.creationDate = "\(timeInfo.tm_hour):\(timeInfo.tm_min), \(timeInfo.tm_mday)/\(timeInfo.tm_mon+1)/\(timeInfo.tm_year+1900)"
    }
}







