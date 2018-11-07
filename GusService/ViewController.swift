//
//  ViewController.swift
//  GusService
//
//  Created by Filip Stajniak on 06/11/2018.
//  Copyright © 2018 Filip Stajniak. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var wojButtonOut: UIButton!
    @IBOutlet weak var powButtonOut: UIButton!
    @IBOutlet weak var searchButtonOut: UIButton!
    @IBOutlet weak var textFieldOut: UITextField!
    
    var wojewDict = [String : String]()
    var outerPowiatMapDict = [String : [String : String]]()
    
    let handlerChooser = HandlerChooser()
    
    let wojDropDown = DropDown()
    let powDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.wojDropDown,
            self.powDropDown
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any}
        wojewDict = handlerChooser.getWojewDict()
        outerPowiatMapDict = handlerChooser.getOuterPowiatMapDict()
    }
    
    @IBAction func wojButtonPressed(_ sender: Any) {
        wojDropDown.show()
    }
    @IBAction func powButtonPressed(_ sender: Any) {
        powDropDown.show()
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        var ulica = textFieldOut.text
        var woj = wojButtonOut.title(for: .normal)
        var pow = powButtonOut.title(for: .normal)
        
        print(ulica!)
        print(woj!)
        print(pow!)
    }
    
    func setupDropDowns() {
        setupWojDropDown()
    }
    
    func setupWojDropDown() {
        wojDropDown.anchorView = wojButtonOut

        wojDropDown.bottomOffset = CGPoint(x: 0, y: wojButtonOut.bounds.height)
        wojDropDown.dataSource = [
            "Wszystkie", "Podkarpackie", "Świętokrzyskie", "Wielkopolskie", "Opolskie",
            "Kujawsko-Pomorskie", "Małopolskie", "Warmińsko-Mazurskie", "Lubuskie", "Lubelskie",
            "Zachodniopomorskie", "Śląskie", "Łódzkie", "Mazowieckie", "Podlaskie", "Pomorskie", "Dolnośląskie"
        ]
        
        wojDropDown.selectionAction = { [weak self] (index, item) in
            self?.wojButtonOut.setTitle(item, for: .normal)
            self?.setupPowDropDown()
            self?.powButtonOut.setTitle("Powiat", for: .normal)
        }
    }
    
    
    
    func setupPowDropDown() {
        powDropDown.anchorView = powButtonOut
        powDropDown.bottomOffset = CGPoint(x: 0, y: powButtonOut.bounds.height)
        if let text : String = wojButtonOut.title(for: .normal) {
            powDropDown.dataSource.removeAll(keepingCapacity: false)
            if text == "Wszystkie" {
                powButtonOut.setTitle("Powiat", for: .normal)
                powButtonOut.isEnabled = false
            } else {
                powButtonOut.isEnabled = true
            }
            if let wojChoosen = wojewDict[text.uppercased()] {
                if let innerPowiatDict = outerPowiatMapDict[wojChoosen]{
                    for (_,name) in innerPowiatDict {
                        if name != "" {
                            powDropDown.dataSource.append(name)
                        }
                    }
                }
            }
        }
        
//        powDropDown.dataSource = [
//            "Auto",
//            "Rower",
//            "Rolki"
//        ]
        
        powDropDown.selectionAction = { [weak self] (index, item) in
            self?.powButtonOut.setTitle(item, for: .normal)
        }
    }
    


}

