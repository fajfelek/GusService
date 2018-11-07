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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var wojButtonOut: UIButton!
    @IBOutlet weak var powButtonOut: UIButton!
    @IBOutlet weak var searchButtonOut: UIButton!
    @IBOutlet weak var textFieldOut: UITextField!
    @IBOutlet weak var tableViewOut: UITableView!

    
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
        
        tableViewOut.delegate = self
        tableViewOut.dataSource = self
        tableViewOut.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
    }
    
    @IBAction func wojButtonPressed(_ sender: Any) {
        wojDropDown.show()
    }
    @IBAction func powButtonPressed(_ sender: Any) {
        powDropDown.show()
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        let ulica = textFieldOut.text
        var woj = wojButtonOut.title(for: .normal)
        var pow = powButtonOut.title(for: .normal)
        
//        if ulica == "" {
//            ulica = nil
//        }
        if woj == "Wszystkie" || woj == "Województwo" {
            woj = nil
        } else {
            woj = wojewDict[woj!.uppercased()]
        }
        if pow == "Wszystkie" || pow == "Powiat" {
            pow = nil
        } else {
            let innerPowiatDict = outerPowiatMapDict[woj!]
            for (number, name) in innerPowiatDict! {
                if name == pow {
                    pow = number
                }
            }
        }
//        if ulica == nil && woj == nil && pow == nil {
//            print("Nie można rozpocząc wyszukiwania")
//        } else {
        if ulica != nil || woj != nil || pow != nil {
            if let result = handlerChooser.XMLChooser(woj: woj, pow: pow, ulica: ulica) {
                for all in result {
                    print(all.getAttributes())
                }
            }
        }
        print(woj)
        print(pow)
        print(ulica)
        
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
    var Item1 = ["Item1","Item1","Item1","Item1"]
    var Item2 = ["Item2","Item2","Item2","Item2"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let messageArray = ["First message", "Second message", "Third message"]
        
        cell.nazwa.text = messageArray[indexPath.row]
        return cell
    }
    
    func configureTableView() {
        tableViewOut.rowHeight = UITableView.automaticDimension
        tableViewOut.estimatedRowHeight = 120.0
    }
    


}

