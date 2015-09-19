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
        
        self.inputFilename = inputFilename
        
        let nameWithoutExtension = inputFilename.characters.split {$0 == "."}.map { String($0) }
        
        // make wb_ name
        self.wb = "wb_" + nameWithoutExtension[0] // The name not including .txt, with wb_ added
        
        let words = nameWithoutExtension[0].characters.split {$0 == "_"}.map { String($0) }
        
        // make camel case
        if words.count == 1 {
            
            // only one word in the name
            self.camel = words[0]
        }
        else {
            // more than one word, make camel case
            var camelCase: String = ""
            var wordToAdd = words[0]
            for word in words {
                if camelCase.characters.count > 0 {

                    wordToAdd = capitalisedWord(word)
                }
                
                camelCase += wordToAdd
            }
            
            self.camel = camelCase
        }
        
        self.caps = uppercaseWord(nameWithoutExtension[0])
        
        // get user name
        let pw = getpwuid(getuid())
        if pw != nil {
            self.userName = String.fromCString(pw.memory.pw_name)!
        }
        else {
            self.userName = "YOUR NAME"
        }
        
        print("user is: \(self.userName)")
        
        // get working directory
        //self.workingDirectory = "/Users/\(self.userName)/src/MiPal/GUNao/posix/classgenerator/classgenerator/"
        self.workingDirectory = getPath()
        
        var t = time(nil)    /// error check and set default value ***************
        self.creationDate = String.fromCString(ctime(&t))!
        
        self.year = 2015   /// TO DO  ***************
    }
}


func getPath() -> String {
    
    //var cwd: UnsafeMutablePointer<Int8>
    //getcwd(cwd, 1024)
    
    var cwd: [Int8] = Array(count: Int(MAXNAMLEN), repeatedValue: 0)
    let workingDirectory = getcwd(&cwd, Int(MAXNAMLEN))
    print("Working directory: \(String.fromCString(workingDirectory)!)")
    
    return String.fromCString(workingDirectory)! + "/"
}



func upperCase (ch: Character) -> Character {
    
    if ( ch >= "a" ) && ( ch <= "z" ){
        
        let scalars = String(ch).unicodeScalars      // unicode scalar(s) of the character
        let val = scalars[scalars.startIndex].value  // value of the unicode scalar
        
        return Character(UnicodeScalar(val - 32))    // return the capital
    }
    else {
        
        return ch                                    // return the character since it's not a letter
    }
}


func capitalisedWord (word: String) -> String {
    
    var capWord = ""
    var firstLetter = true
    
    for ch in word.characters {
        
        if firstLetter {
            capWord += String(upperCase(ch))    // return an uppercase character as a String
            firstLetter = false
        }
        else {
            capWord += String(ch)
        }
    }

    return capWord
}


func uppercaseWord (word: String) -> String {
    
    var uppWord = ""
    
    for ch in word.characters {
        
            uppWord += String(upperCase(ch))
    }
    
    return uppWord
}

