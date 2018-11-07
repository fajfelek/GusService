//
//  SIMCHandler.swift
//  XMLParseriOS
//
//  Created by Filip Stajniak on 06/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

import Foundation
import UIKit

class SIMCHandler : NSObject, XMLParserDelegate {
    
    var nazwaFlag : Bool = false
    var symFlag : Bool = false
    var symPodFlag : Bool = false
    
    var miastaDict = [String : String]()
    
    var parser = XMLParser()
    var fileURL : String
    
    init(filePath: String) {
        self.fileURL = filePath
    }
    
    var sym : String? = nil
    var nazwa : String = ""
    var symPod : String? = nil
    
    func addMap(city : String, kod : String) {
        miastaDict.updateValue(city, forKey: kod)
    }
    
    func getMiastaDict() -> Dictionary<String,String> {
        return miastaDict
    }
    
    func startSAX() {
        parser = XMLParser.init(data: fileURL.data(using: String.Encoding.utf8)!)
        parser.delegate = self
        
        let success : Bool = parser.parse()
        
        if success {
            print("Parse SIMC success!")
        } else {
            print("Parse SIMC failure!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "NAZWA" {
            nazwaFlag = true
        }
        if elementName == "SYM" {
            symFlag = true
        }
        if elementName == "SYMPOD" {
            symPodFlag = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "NAZWA" {
            nazwaFlag = false
        }
        if elementName == "SYM" {
            symFlag = false
            self.nazwa = ""
        }
        if elementName == "SYMPOD" {
            symPodFlag = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if nazwaFlag {
            self.nazwa = self.nazwa + string
        }
        if symFlag {
            self.sym = string

            addMap(city: nazwa, kod: sym!)
        }
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Failure error: ", parseError)
    }
    
    
}

