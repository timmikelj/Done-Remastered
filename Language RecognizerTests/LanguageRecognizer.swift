//
//  LanguageRecognizer.swift
//  Language Recognizer
//
//  Created by Tim Mikelj on 12/02/2021.
//

import NaturalLanguage

public class LanguageRecognizer {
    
    private(set) var tagger: NLTagger
    
    public init(with tagScheme: NLTagScheme) {
        tagger = NLTagger(tagSchemes: [tagScheme])
    }
}
