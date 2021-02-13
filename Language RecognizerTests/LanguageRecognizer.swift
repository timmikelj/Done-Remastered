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
    
    public init(with tagScheme: NLTagScheme) {
        scheme = tagScheme
        tagger = NLTagger(tagSchemes: [tagScheme])
    }
    
    public func findVerbs(in string: String, completion: @escaping ([String]) -> Void) {
        
        var verbs = [String]()
        
        tagger.string = string
        enumerateVerbs(acc: &verbs)
        
        completion(verbs)
    }
    
    public func findNouns(in string: String, completion: @escaping ([String]) -> Void) {
        
        var nouns = [String]()
        
        tagger.string = string
        enumerateNouns(acc: &nouns)
        
        completion(nouns)
    }
    
    private func enumerateVerbs(acc: inout [String]) {
        
        guard let string = tagger.string,
              let stringRange = string.range(of: string) else {
            return
        }
        
        tagger.enumerateTags(in: stringRange,
                             unit: .word,
                             scheme: scheme,
                             options: .omitPunctuation) { tag, range -> Bool in
            
            if let verb = getVerb(from: tag, range: range) {
                acc.append(verb)
            }
            
            return true
        }
    }
    
    private func enumerateNouns(acc: inout [String]) {
        
        guard let string = tagger.string,
              let stringRange = string.range(of: string) else {
            return
        }
        
        tagger.enumerateTags(in: stringRange,
                             unit: .word,
                             scheme: scheme,
                             options: .omitPunctuation) { tag, range -> Bool in
            
            if let noun = getNoun(from: tag, range: range) {
                acc.append(noun)
            }
            
            return true
        }
    }
    
    private func getVerb(from tag: NLTag?, range: Range<String.Index>) -> String? {
        
        guard tag == .verb, let string = tagger.string else { return nil }
        
        return String(string[range]).lowercased()
    }
    
    private func getNoun(from tag: NLTag?, range: Range<String.Index>) -> String? {
        
        guard tag == .noun, let string = tagger.string else { return nil }
        
        return String(string[range]).lowercased()
    }
}
