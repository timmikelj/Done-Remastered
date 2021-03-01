//
//  LanguageRecognizer.swift
//  Language Recognizer
//
//  Created by Tim Mikelj on 01/03/2021.
//

import Combine

public protocol LanguageRecognizer {
    func findTags(withType tag: TagType, in string: String) -> AnyPublisher<String, Error>
}
