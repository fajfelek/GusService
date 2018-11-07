//
//  Description.swift
//  XMLParseriOS
//
//  Created by Filip Stajniak on 06/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

import Foundation

protocol Printable {
    var description : String { get }
}

class Description : Printable{
    
    var WOJ : String
    var POW : String
    var GMI : String
    var RODZ : String
    var ID_CITY : String
    var ID_NAME : String
    var CECH : String
    var CITY_NAME : String
    var NAME : String
    
    init(woj: String, pow: String, gmi: String, rodz: String, id_city: String, id_name: String, city_name: String, cech: String, name: String) {
        self.WOJ = woj
        self.POW = pow
        self.GMI = gmi
        self.RODZ = rodz
        self.ID_CITY = id_city
        self.ID_NAME = id_name
        self.CECH = cech
        self.CITY_NAME = city_name
        self.NAME = name
    }
    
    func getAttributes() -> String {
        return "Description:\nWOJ: \(WOJ)\nPOW: \(POW)\nGMI: \(GMI)\nRODZ: \(RODZ)\nID_CITY: \(ID_CITY)\nID_NAME: \(ID_NAME)\nCECH: \(CECH)\nCITY_NAME: \(CITY_NAME)\nNAME: \(NAME)"
    }
    
    var description : String {
        return "Description {\nWOJ: \(WOJ)\nPOW: \(POW)\nGMI: \(GMI)\nRODZ: \(RODZ)\nID_CITY: \(ID_CITY)\nID_NAME: \(ID_NAME)\nCECH: \(CECH)\nCITY_NAME: \(CITY_NAME)\nNAME: \(NAME)"
    }
}
