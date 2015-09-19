//
//  stringmanipulation.swift
//  classgenerator
//
//  Created by Mick Hawkins on 19/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//


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
            capWord += String(upperCase(ch))          // return an uppercase character as a String
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


func camelCaseWord(words: [String]) -> String {
    
    var camelCase: String = ""
    var wordToAdd = words[0]
    
    for word in words {
        if camelCase.characters.count > 0 {
            wordToAdd = capitalisedWord(word)
        }
        
        camelCase += wordToAdd
    }
    
    return camelCase
}

