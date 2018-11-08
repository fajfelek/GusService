//
//  ULICHandler2.swift
//  XMLParseriOS
//
//  Created by Filip Stajniak on 06/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

import Foundation

class ULICHandler2 : NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var fileURL : String = ""
    
    var wojFlag : Bool = false
    var powFlag : Bool = false
    var nameFlag : Bool = false
    var gmiFlag : Bool = false
    var rodzFlag : Bool = false
    var idCityFlag : Bool = false
    var idNameFlag : Bool = false
    var cechFlag : Bool = false
    var wojNameFlag : Bool = false
    var powNameFlag : Bool = false
    
    var woj : String = ""
    var name : String = ""
    var pow : String = ""
    var miastaDict = [String : String]()
    var rodzGmiDict = [String : String]()
    var wojewDict = [String : String]()
    var outerPowiatDict = [String : [String : String]]()
    var innerPowiatDict = [String : String]()
    
    var counter : Int = 0
    
    var WOJ : String? = nil
    var POW : String? = nil
    var GMI : String? = nil
    var RODZ : String? = nil
    var ID_CITY : String? = nil
    var ID_NAME : String? = nil
    var CECH : String? = nil
    var NAME : String? = nil
    var CITY_NAME : String? = nil
    
    var streetDescription = [Description]()
    
    func getStreetDescription() -> [Description] {
        return streetDescription
    }
    
    func getCounter() -> Int {
        return counter
    }
    
    func getInnerPowiatDict(key: String) -> Dictionary<String,String>? {
        let innerMap = outerPowiatDict[key]
        if (innerMap?.isEmpty)! {
            return nil
        }
        return innerMap
    }
    
    init(filePath: String, woj: String, pow: String, name: String, miastaDict: [String : String], wojewDict: [String : String], rodzGmiDict: [String : String], outerPowiatDict: [String : [String : String]]) {
        self.fileURL = filePath
        self.woj = woj
        self.pow = pow
        self.name = name
        self.miastaDict = miastaDict
        self.rodzGmiDict = rodzGmiDict
        self.wojewDict = wojewDict
        self.outerPowiatDict = outerPowiatDict
    }
    
    func startSAX() {
        
        parser = XMLParser(data: fileURL.data(using: String.Encoding.utf8)!)
        parser.delegate = self
        
        let success : Bool = parser.parse()
        
        if success {
            print("Parse ULIC2 success!")
        } else {
            print("Parse ULIC2 failure!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "WOJ" {
            wojFlag = true
        }
        if elementName == "POW" {
            powFlag = true
        }
        if elementName == "GMI" {
            gmiFlag = true
        }
        if elementName == "RODZ_GMI" {
            rodzFlag = true
        }
        if elementName == "SYM" {
            idCityFlag = true
        }
        if elementName == "SYM_UL" {
            idNameFlag = true
        }
        if elementName == "CECHA" {
            cechFlag = true
        }
        if elementName == "NAZWA_1" {
            nameFlag = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "WOJ" {
            wojFlag = false
        }
        if elementName == "POW" {
            powFlag = false
        }
        if elementName == "GMI" {
            gmiFlag = false
        }
        if elementName == "RODZ_GMI" {
            rodzFlag = false
        }
        if elementName == "SYM" {
            idCityFlag = false
        }
        if elementName == "SYM_UL" {
            idNameFlag = false
        }
        if elementName == "CECHA" {
            cechFlag = false
        }
        if elementName == "NAZWA_1" {
            nameFlag = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if wojFlag {
            let wojLocal : String = string
            if wojLocal == self.woj {
                self.WOJ = self.woj
                wojNameFlag = true
            }
        }
        if wojNameFlag && powFlag {
            let powLocal : String = string
            
            if powLocal == self.pow {
                powNameFlag = true
                self.POW = powLocal
            }
            wojNameFlag = false
        }
        if gmiFlag {
            self.GMI = string
        }
        if rodzFlag {
            self.RODZ = string
        }
        if idCityFlag {
            self.ID_CITY = string
        }
        if idNameFlag {
            self.ID_NAME = string
        }
        if cechFlag {
            self.CECH = string
        }
        if powNameFlag && nameFlag {
            let nameLocal : String = string
            if (nameLocal.range(of: self.name) != nil) {
                counter = counter + 1
                self.NAME = nameLocal
                self.CITY_NAME = miastaDict[self.ID_CITY!]
                self.RODZ = rodzGmiDict[self.RODZ!]
                innerPowiatDict = getInnerPowiatDict(key: self.WOJ!)!
                self.POW = innerPowiatDict[self.POW!]
                guard self.POW != nil else {
                    self.POW = ""
                    return
                }
                for (value, key) in wojewDict {
                    if value == self.WOJ! {
                        self.WOJ = key
                    }
                }
                streetDescription.append(Description(woj: self.WOJ!, pow: self.POW!, gmi: self.GMI!, rodz: self.RODZ!, id_city: self.ID_CITY!, id_name: self.ID_NAME!, city_name: self.CITY_NAME!, cech: self.CECH!, name: self.NAME!))
            }
            powNameFlag = false
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Failure error: ", parseError)
    }
    
    
}
