//
//  LanguageRecognizer.swift
//  Language Recognizer
//
//  Created by Tim Mikelj on 12/02/2021.
//

import NaturalLanguage
import Combine

public class LanguageRecognizer {
    
    public enum Error: Swift.Error {
        case emptyString
    }
    
    private(set) var scheme: NLTagScheme
    private(set) var tagger: NLTagger
    
    public init() {
        scheme = .lexicalClass
        tagger = NLTagger(tagSchemes: [scheme])
    }
    
    public typealias WordPublisher = AnyPublisher<String, Error>
    
    public func getVerbs(from string: String) -> WordPublisher {
        findTag(.verb, in: string)
    }
    
    public func getNouns(from string: String) -> WordPublisher {
        findTag(.noun, in: string)
    }
    
    private func findTag(_ tag: NLTag, in string: String) -> WordPublisher {
        
        guard !string.isEmpty else {
            return Fail(error: .emptyString).eraseToAnyPublisher()
        }
        
        tagger.string = string
        
        return enumerateTags(desiredTag: tag)
    }
    
    private func enumerateTags(desiredTag: NLTag) -> WordPublisher {
        Future<String, Error> { [weak self] promise in
            guard let self = self,
                  let string = self.tagger.string,
                  let stringRange = string.range(of: string) else {
                return
            }
            
            self.tagger.enumerateTags(in: stringRange,
                                 unit: .word,
                                 scheme: self.scheme,
                                 options: .omitPunctuation) { tag, range -> Bool in
                
                if let verb = self.getString(from: tag, for: desiredTag, range: range) {
                    promise(.success(verb))
                }
                
                return true
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getString(from tag: NLTag?,
                           for desiredTag: NLTag,
                           range: Range<String.Index>) -> String? {
        
        guard tag == desiredTag, let string = tagger.string else { return nil }
        
        return String(string[range]).lowercased()
    }
}
