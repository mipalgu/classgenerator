//
//  stringmanipulation.swift
//  classgenerator
//
//  Created by Mick Hawkins on 19/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//
//  Because this software will be ported to Linux, Swift's Foundation API can not be used.
//  This means that strings needed to be manipulated manually.
//



/**
 * This function returns the upper case version of a lower case character.
 * Any other characters are returned unchanged.
 * @param ch is a character
 * @return Returns the character, or its upper case version
 */
func upperCase(_ ch: Character) -> Character {
    
    if ( ch >= "a" ) && ( ch <= "z" ){
        
        let scalars = String(ch).unicodeScalars     // unicode scalar(s) of the character
        let s = scalars[scalars.startIndex]
        let val = s.value                           // value of the unicode scalar
        
        return Character(UnicodeScalar(val - 32) ?? s)    // return the capital
    }
    else {
        
        return ch                                    // return the character since it's not a lowercase letter
    }
}



/**
 * This function returns the lower case version of an upper case character.
 * Any other characters are returned unchanged.
 * @param ch is a character
 * @return Returns the character, or its lower case version
 */
func lowerCase(_ ch: Character) -> Character {
    
    if ( ch >= "A" ) && ( ch <= "Z" ){
        
        let scalars = String(ch).unicodeScalars         // unicode scalar(s) of the character
        let s = scalars[scalars.startIndex]
        let val = s.value                               // value of the unicode scalar

        return Character(UnicodeScalar(val + 32) ?? s)  // return the lowercase
    }
    else {
        
        return ch                                    // return the character since it's not a lowercase letter
    }
}


/**
 * This function makes the first character of a word upper case
 * The rest of the word is unchanged.
 * If the first character is not a lowercase character, it is unchanged.
 * @param word is a string
 * @return Returns the capitalised word as a string
 */
func capitalisedWord(_ word: String) -> String {
    
    var capWord = ""
    var firstLetter = true
    
    for ch in word.characters {
        
        if firstLetter {
            capWord += String(upperCase(ch))          // make an uppercase character as a String
            firstLetter = false
        }
        else {
            capWord += String(ch)
        }
    }
    
    return capWord
}



/**
 * This function makes all the characters of a word upper case
 * If any characters are not a lowercase character, they are unchanged.
 * @param word is a string
 * @return Returns the uppercase word as a string
 */
func uppercaseWord(_ word: String) -> String {
    
    var uppWord = ""
    
    for ch in word.characters {
        uppWord += String(upperCase(ch))
    }
    
    return uppWord
}

func lowercaseWord(_ word: String) -> String {
    
    var lowWord = ""
    
    for ch in word.characters {
        lowWord += String(lowerCase(ch))
    }
    
    return lowWord
}



/**
 * This function makes words into a camel case word.
 * If any characters are not a lowercase character, they are unchanged.
 * @param words is an array of strings
 * @return Returns the word as a string
 */
func camelCaseWord(_ words: [String]) -> String {
    
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


/**
 * This function makes words into a C++ struct name.
 * That is, a camel case word with the first letter also upper case.
 * If any characters are not a lowercase character, they are unchanged.
 * @param words is an array of strings
 * @return Returns the word as a string
 */
func cppWord(_ words: [String]) -> String {
    
    var cpp: String = ""
    var wordToAdd: String = ""
    
    for word in words {
            wordToAdd = capitalisedWord(word)
        
        cpp += wordToAdd
    }
    
    return cpp
}



/**
 * This function removes "// " from the front of a string.
 * @param inputText is a string
 * @return Returns the trimmed string
 */
func removeCommentNotation(_ inputText: String) -> String {
    
    var firstLetterFound = false
    var foundComment = ""
    
    for ch in inputText.characters {
        
        if firstLetterFound {
            foundComment += String(ch)
        }
        else if  ch != "/" && ch != " " {
            firstLetterFound = true
            foundComment += String(ch)
        }
    }
    
    return foundComment
}


/// String convenience extension
extension String {
    /// convert a C-style identifier with underscores to C++ camel case
    var cpp: String {
        let words = characters.split {$0 == "_"}.map { String($0) }
        return cppWord(words)
    }

    /// return the substring before the given character
    func substring(before c: Character) -> String? {
        let words = characters.split {$0 == c}.map { String($0) }
        return words.first
    }

    /// return the substring after the given character
    func substring(after c: Character) -> String? {
        let words = characters.split {$0 == c}.map { String($0) }
        let n = words.count
        guard n > 1 else { return nil }
        return words[1..<n].joined(separator: String(c))
    }
}
