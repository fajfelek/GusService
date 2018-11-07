//
//  XMLParser.swift
//  XMLParseriOS
//
//  Created by Filip Stajniak on 05/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

// cos nie tak z tablica outer!!!!! puste elementy w slowniku

import Foundation
import UIKit

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0,range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }

}

class TERCHandler : NSObject, XMLParserDelegate {
    
    
    var wojFlag : Bool = false
    var powFlag : Bool = false
    var nazwaFlag : Bool = false
    var nazwaDodFlag : Bool = false
    
    var wojewDict = [String : String]()
    var outerPowiatMapDict = [String : [String : String]]()
    var innerPowiatMapDict = [[String : String]](repeating: ["" : ""] , count: 16)
    
    var parser = XMLParser()
    var fileURL : String
    
    init(filePath: String) {
        self.fileURL = filePath
    }
    
    var woj : String? = nil
    var pow : String? = nil
    var nazwa : String = ""
    
    func addMap(woj : String, kod : String) {
        wojewDict.updateValue(kod, forKey: woj)
    }
    
    func getWojewDict() -> Dictionary<String, String> {
        return wojewDict
    }
    
    func getOuterPowiatMapDict() -> Dictionary<String, Dictionary<String, String>> {
        return outerPowiatMapDict
    }
    
    func createPowiatMap(woj : String) {
        innerPowiatMapDict[(Int(woj)!/2)-1].updateValue((nazwa.prefix(1).uppercased()) + nazwa[1..<nazwa.count].lowercased(), forKey: pow!)
        outerPowiatMapDict.updateValue(innerPowiatMapDict[(Int(woj)!/2)-1], forKey: woj)
    }
    
    func startSAX() {
        parser = XMLParser(data: fileURL.data(using: String.Encoding.utf8)!)
        parser.delegate = self
        
        let success : Bool = parser.parse()
        
        if success {
            print("Parse TERC success!")
        } else {
            print("Parse TERC failure!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "WOJ" {
            wojFlag = true
        }
        if elementName == "POW" {
            powFlag = true
        }
        if elementName == "NAZWA" {
            nazwaFlag = true
        }
        if elementName == "NAZWA_DOD" {
            nazwaDodFlag = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "WOJ" {
            wojFlag = false
        }
        if elementName == "POW" {
            powFlag = false
        }
        if elementName == "NAZWA" {
            nazwaFlag = false
        }
        if elementName == "NAZWA_DOD" {
            nazwaDodFlag = false
            self.nazwa = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if wojFlag {
            self.woj = string
        }
        if powFlag {
            self.pow = string
        }
        if nazwaFlag {
            self.nazwa = self.nazwa + string
        }
        if nazwaDodFlag {
            let nazwaDod : String = string
            let spr : String = "wojew"
            if nazwaDod == spr {
                addMap(woj: self.nazwa, kod: self.woj!)
            }
            if nazwaDod == "powiat" || nazwaDod == "miasto na prawach powiatu" {
                createPowiatMap(woj: woj!)
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Failure error: ", parseError)
    }
    
    
}
