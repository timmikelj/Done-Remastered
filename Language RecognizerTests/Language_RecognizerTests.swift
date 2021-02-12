//
//  Language_RecognizerTests.swift
//  Language RecognizerTests
//
//  Created by Tim Mikelj on 12/02/2021.
//

import XCTest
import NaturalLanguage
@testable import Language_Recognizer

class Language_RecognizerTests: XCTestCase {

    func test_initTakesTagScheme_andInstatiatesNLTagger() {
        
        let sut = makeSUT(tagScheme: .lexicalClass)
        
        XCTAssertNotNil(sut.tagger)
        XCTAssertEqual(sut.tagger.tagSchemes, [.lexicalClass])
        XCTAssertEqual(sut.scheme, .lexicalClass)
    }
    
    func test_findVerbsInAString_assignsStringToTheTagger() {
        
        let sut = makeSUT(tagScheme: .lexicalClass)
        
        let testString = "I went running."
        
        sut.findVerbs(in: testString) { verbs in
            XCTAssertEqual(verbs, ["running"])
        }
        
        XCTAssertEqual(sut.tagger.string, testString)
    }
    
    // Helpers
    
    private func makeSUT(tagScheme: NLTagScheme) -> LanguageRecognizer {
        let tagScheme = NLTagScheme(rawValue: tagScheme.rawValue)
        return LanguageRecognizer(with: tagScheme)
    }

}
