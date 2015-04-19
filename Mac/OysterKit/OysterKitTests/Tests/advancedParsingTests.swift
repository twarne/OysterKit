//
//  advancedParsingTests.swift
//  OysterKit Mac
//
//  Created by Tom Warne on 4/18/15.
//  Copyright (c) 2015 RED When Excited Limited. All rights reserved.
//

import OysterKit
import XCTest

class AdvancedParsingTests : XCTestCase {
 
    func testAdvancedParsing() {
        let tougherTest = "1.5 Nasty example with -10 or 10.5 maybe even 1.0e-10 \"Great \\(variableName) \\t 🐨 \\\"Nested\\\" quote\"!"
        
        let quotedCharacterBranchStates:[TokenizationState] = [
            Characters(from: "t\""), Delimited(open: "(", close: ")", states: OKStandard.word)
        ]
        let escapedCharacters = Characters(from: "\\")
        escapedCharacters.branch(quotedCharacterBranchStates)
        
        //Configure the tokenizer
        let advancedSentenceTokenizer:Tokenizer = Tokenizer()
            advancedSentenceTokenizer.branch([
            Delimited(delimiter:"\"", states:escapedCharacters, Characters(except:"\"")),
            OKStandard.blanks,
            OKStandard.number,
            OKStandard.word,
            OKStandard.punctuation,
            OKStandard.eot
            ])
        println("\nAdvanced Sentence:")
        for token in advancedSentenceTokenizer.tokenize(tougherTest) {
            print(token.characters)
        }
    }
    
    func testRPNParser() {
        let simpleMath:Tokenizer = Tokenizer()
        simpleMath.branch([
            OKStandard.operators,
            OKStandard.number,
            OKStandard.whiteSpace
            ])
        let rpnExpression = "3 -2 -"
        let rpnParser = RPNParser()
        rpnParser.parseString(rpnExpression, withTokenizer: simpleMath)
        print("\nRPN result for '"+rpnExpression+"':\n\t")
        rpnParser.execute()
    }
}
