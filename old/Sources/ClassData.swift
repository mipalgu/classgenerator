//
//  ClassData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 22/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//
//  This class stores information abou the classes to be generated
//


#if os(Linux)
import Glibc
#else
import Darwin
#endif

class ClassData {
    var baseName: String            ///< base class/input file name
    var inputFilename: String       ///< user's filename including .txt
    var preambleFile: String        ///< header file preamble (<filename>.preamble)
    var workingDirectory: String
    var wb: String                  ///< name for wb class/struct, lower case with underscores starting with wb_
    var camel: String               ///< camel case, without underscores
    var caps: String                ///< upper case, including underscores
    var cpp: String                 ///< c++ class name
    var userName: String
    var creationDate: String
    var year: Int
    
    init(workingDirectory: String, inputFilenameNoExtension: String, userName: String) {
        baseName = inputFilenameNoExtension
        inputFilename = inputFilenameNoExtension + ".txt"
        preambleFile = inputFilenameNoExtension + ".preamble"
        
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
        
        var t = time(nil)   
        var timeInfo = tm()
        localtime_r(&t, &timeInfo)
        
        self.year = Int(timeInfo.tm_year) + 1900
//      self.creationDate = String.fromCString(ctime(&t))!
        self.creationDate = "\(timeInfo.tm_hour):\(timeInfo.tm_min), \(timeInfo.tm_mday)/\(timeInfo.tm_mon+1)/\(timeInfo.tm_year+1900)"
    }
}



/**
 * This function is called when the author has not been specified
 * @return Returns the system's user name as a string
 */
func getUserName() -> String {
    guard let pw = getpwuid(getuid()),
          let name = String(validatingUTF8: pw.pointee.pw_name) else {
        print ("Could not determine system username.")
        print ("Please check the generated files.")
        return "YOUR NAME GOES HERE"
    }

    return name
}




