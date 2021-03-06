//
//  Language_RecognizerTests.swift
//  Language RecognizerTests
//
//  Created by Tim Mikelj on 12/02/2021.
//

import XCTest
import NaturalLanguage
import Combine
@testable import Language_Recognizer

class NaturalLanguageRecognizerTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []

    func test_init_instatiatesNLTagger_andSetsUpScheme() {
        
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.tagger)
        XCTAssertEqual(sut.tagger.tagSchemes, [.lexicalClass])
        XCTAssertEqual(sut.scheme, .lexicalClass)
    }
    
    func test_emitErrorForEmptyString() {
        
        let sut = makeSUT()
        sut.findTags(withType: .verb, in: "")
            .sink { error in
                switch error {
                case .failure(let error):
                    XCTAssertEqual(error, .emptyString)
                case .finished:
                    XCTFail("finished instead of returning an error")
                }
            } receiveValue: { noun in
                XCTFail("expected to fail with error got \(noun) instead")
            }
            .store(in: &cancellables)
    }
    
    func test_findVerbsInAString_assignsStringToTheTagger_andEmitVerbsInClosure() {
        
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
            sut.findTags(withType: .verb, in: string)
                .collect()
                .receive(on: DispatchQueue.main)
                .sink { error in
                    XCTFail("failed with error \(error)")
                } receiveValue: { verbs in
                    XCTAssertEqual(verbs, expectedVerbs[index])
                    XCTAssert(Thread.isMainThread)
                }
                .store(in: &cancellables)

            XCTAssertEqual(sut.tagger.string, string)
        }
    }
    
    func test_findNounsInAString_assignsStringToTheTagger_andEmitsNounsInClosure() {

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
            
            sut.findTags(withType: .noun, in: string)
                .collect()
                .receive(on: DispatchQueue.main)
                .sink { error in
                    XCTFail("failed with error \(error)")
                } receiveValue: { verbs in
                    XCTAssertEqual(verbs, expectedNouns[index])
                    XCTAssert(Thread.isMainThread)
                }
                .store(in: &cancellables)

            XCTAssertEqual(sut.tagger.string, string)
        }
    }
    
    // Helpers
    
    private func makeSUT() -> NaturalLanguageRecognizer {
        return NaturalLanguageRecognizer()
    }
}
