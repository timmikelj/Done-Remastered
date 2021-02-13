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
        
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.tagger)
        XCTAssertEqual(sut.tagger.tagSchemes, [.lexicalClass])
        XCTAssertEqual(sut.scheme, .lexicalClass)
    }
    
    func test_findVerbsInAString_assignsStringToTheTagger_andReturnsVerbsInClosure() {
        
        let sut = makeSUT()
        
        let testStrings: [String] = ["I went running.",
                                     "Joined clubhouse",
                                     "Just EATING my dinner",
                                     "Looking through the window while driVIng"]
        
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
    
    func test_findNounsInAString_assignsStringToTheTagger_andReturnsVerbsInClosure() {

        let sut = makeSUT()

        let testStrings: [String] = ["I went running.",
                                     "Joined clubhouse",
                                     "Just EATING my dinner",
                                     "Looking through the window while driVIng"]

        let expectedNouns = [["running"],
                             ["clubhouse"],
                             ["dinner"],
                             ["window"]]

        testStrings.enumerated().forEach { index, string in
            sut.findNouns(in: string) { verbs in
                XCTAssertEqual(verbs, expectedNouns[index])
                XCTAssert(Thread.isMainThread)
            }

            XCTAssertEqual(sut.tagger.string, string)
        }
    }
    
    // Helpers
    
    private func makeSUT() -> LanguageRecognizer {
        return LanguageRecognizer()
    }
}
