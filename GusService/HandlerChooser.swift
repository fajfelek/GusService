//
//  HandlerChooser.swift
//  XMLParseriOS
//
//  Created by Filip Stajniak on 06/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

import Foundation
import SVProgressHUD

class HandlerChooser {
    
    var wojewDict = [String : String]()
    var miastaDict = [String : String]()
    var rodzGmiDict = [String : String]()
    var outerPowiatMapDict = [String : [String : String]]()
    var counter : Int = 0
    var TERCisOK : Bool = false
    var SIMCisOK : Bool = false
    var ULICisOK : Bool = false
    
    func getWojewDict() -> Dictionary<String,String> {
        return wojewDict
    }
    
    func getOuterPowiatMapDict() -> Dictionary<String, Dictionary<String, String>> {
        return outerPowiatMapDict
    }
    
    func createRodzGmiDict() {
        rodzGmiDict.updateValue("miejska", forKey: "1")
        rodzGmiDict.updateValue("wiejska", forKey: "2")
        rodzGmiDict.updateValue("miejsko-wiejska", forKey: "3")
        rodzGmiDict.updateValue("miasto w gminie miejsko-wiejskiej", forKey: "4")
        rodzGmiDict.updateValue("obszar wiejski w gminie miejsko-wiejskiej", forKey: "5")
        rodzGmiDict.updateValue("dzielnica Warszawy", forKey: "8")
        rodzGmiDict.updateValue("delegatury miast: Kraków, Łódź, Poznań, Wrocław", forKey: "9")
    }
    
    func XMLChooser(woj: String?, pow: String?, ulica ulic: String?) -> [Description]? {
        do {
            guard let path = Bundle.main.path(forResource: "ULIC", ofType: "xml") else {
                print("ULIC path error")
                print("Error XML files")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SVProgressHUD.showError(withStatus: "Error XML files")
                }
                ULICisOK = false
                return nil
            }
            let fileURL = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            ULICisOK = true
        
            if checkFiles() {
                // <WOJ>
                if (woj != nil) && (pow == nil) && (ulic != nil) {
                    let parser = ULICHandler1(filePath: fileURL, woj: woj!, name: ulic!, miastaDict: miastaDict, wojewDict: wojewDict, rodzGmiDict: rodzGmiDict, outerPowiatDict: outerPowiatMapDict)
                    parser.startSAX()
                    counter = parser.getCounter()
                    return parser.getStreetDescription()
                }
                // <WOJ/POW>
                if (woj != nil) && (pow != nil) && (ulic != nil) {
                    let parser = ULICHandler2(filePath: fileURL, woj: woj!, pow: pow!, name: ulic!, miastaDict: miastaDict, wojewDict: wojewDict, rodzGmiDict: rodzGmiDict, outerPowiatDict: outerPowiatMapDict)
                    parser.startSAX()
                    counter = parser.getCounter()
                    return parser.getStreetDescription()
                }
                // <ulica>
                if (woj == nil) && (pow == nil) && (ulic != nil) {
                    let parser = ULICHandler3(filePath: fileURL, name: ulic!, miastaDict: miastaDict, wojewDict: wojewDict, rodzGmiDict: rodzGmiDict, outerPowiatDict: outerPowiatMapDict)
                    parser.startSAX()
                    counter = parser.getCounter()
                    return parser.getStreetDescription()
                }
            } else {
                print("Error XML files")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SVProgressHUD.showError(withStatus: "Error XML files")
                }
            }
            
        } catch let error as NSError {
            print("Error XMLChooser pathRead %@ - \(error.localizedDescription)")
        }
        return nil
    }
    
    init() {
        do {
            guard let path = Bundle.main.path(forResource: "TERC", ofType: "xml") else {
                print("TERC path error")
                TERCisOK = false
                return
            }
            let fileURL = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            TERCisOK = true
            let parser = TERCHandler(filePath: fileURL)
            parser.startSAX()
            
            wojewDict = parser.getWojewDict()
            outerPowiatMapDict = parser.getOuterPowiatMapDict()
            
        } catch let error as NSError {
            print("Error HandlerChooser constructor pathRead TERC %@ - \(error.localizedDescription)")
        }
        
        do {
            guard let path = Bundle.main.path(forResource: "SIMC", ofType: "xml") else {
                print("SIMC path error")
                SIMCisOK = false
                return
            }
            let fileURL = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            SIMCisOK = true
            let parser = SIMCHandler(filePath: fileURL)
            parser.startSAX()
            
            miastaDict = parser.getMiastaDict()
            
        } catch let error as NSError {
            print("Error HandlerChooser constructor pathRead TERC %@ - \(error.localizedDescription)")
        }
        
        createRodzGmiDict()
    }
    
    func checkFiles() -> Bool {
        if TERCisOK && SIMCisOK && ULICisOK {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    
    
}
