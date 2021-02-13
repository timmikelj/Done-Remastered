//
//  LanguageRecognizer.swift
//  Language Recognizer
//
//  Created by Tim Mikelj on 12/02/2021.
//

import NaturalLanguage

public class LanguageRecognizer {
    
    private(set) var scheme: NLTagScheme
    private(set) var tagger: NLTagger
    
    public init() {
        scheme = .lexicalClass
        tagger = NLTagger(tagSchemes: [scheme])
    }
    
    public func findVerbs(in string: String, completion: @escaping ([String]) -> Void) {
        
        var verbs = [String]()
        
        tagger.string = string
        enumerateTags(acc: &verbs, desiredTag: .verb)
        
        completion(verbs)
    }
    
    public func findNouns(in string: String, completion: @escaping ([String]) -> Void) {
        
        var nouns = [String]()
        
        tagger.string = string
        enumerateTags(acc: &nouns, desiredTag: .noun)
        
        completion(nouns)
    }
    
    private func enumerateTags(acc: inout [String], desiredTag: NLTag) {
        
        guard let string = tagger.string,
              let stringRange = string.range(of: string) else {
            return
        }
        
        tagger.enumerateTags(in: stringRange,
                             unit: .word,
                             scheme: scheme,
                             options: .omitPunctuation) { tag, range -> Bool in
            
            if let verb = getString(from: tag, for: desiredTag, range: range) {
                acc.append(verb)
            }
            
            return true
        }
    }
    
    private func getString(from tag: NLTag?, for desiredTag: NLTag, range: Range<String.Index>) -> String? {
        
        guard tag == desiredTag, let string = tagger.string else { return nil }
        
        return String(string[range]).lowercased()
    }
}
