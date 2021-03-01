//
//  NaturalLanguageRecognizer.swift
//  Language Recognizer
//
//  Created by Tim Mikelj on 12/02/2021.
//

import NaturalLanguage
import Combine

public class NaturalLanguageRecognizer {
    
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
    
    public func findTags(withType tag: NLTag, in string: String) -> WordPublisher {
        
        guard !string.isEmpty else {
            return Fail(error: .emptyString).eraseToAnyPublisher()
        }
        
        tagger.string = string
        
        return tagsPublisher(desiredTag: tag)
    }
}

private extension NaturalLanguageRecognizer {
    
    func tagsPublisher(desiredTag: NLTag) -> WordPublisher {
        Future<String, Error> { [unowned self] promise in
            guard let string = self.tagger.string,
                  let stringRange = string.range(of: string) else {
                return
            }
            
            tagger.enumerateTags(in: stringRange,
                                 unit: .word,
                                 scheme: scheme,
                                 options: .omitPunctuation) { tag, range -> Bool in
                
                if let verb = getString(from: tag, for: desiredTag, range: range) {
                    promise(.success(verb))
                }
                
                return true
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getString(from tag: NLTag?,
                   for desiredTag: NLTag,
                   range: Range<String.Index>) -> String? {
        
        guard tag == desiredTag, let string = tagger.string else { return nil }
        
        return String(string[range]).lowercased()
    }
}
