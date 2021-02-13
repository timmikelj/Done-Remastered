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
        
        let testStrings: [String] = ["I went running.",
                                     "Joined clubhouse",
                                     "Just eating my dinner",
                                     "Looking through the window while driving"]
        
        let expectedVerbs = [["went"],
                             ["joined"],
                             ["eating"],
                             ["looking", "driving"]]
        
        testStrings.enumerated().forEach { index, string in
            sut.findVerbs(in: string) { verbs in
                XCTAssertEqual(verbs, expectedVerbs[index])
                XCTAssert(Thread.isMainThread)
            }
            
            XCTAssertEqual(sut.tagger.string, string)
        }
    }
    
    // Helpers
    
    private func makeSUT(tagScheme: NLTagScheme) -> LanguageRecognizer {
        let tagScheme = NLTagScheme(rawValue: tagScheme.rawValue)
        return LanguageRecognizer(with: tagScheme)
    }
}
