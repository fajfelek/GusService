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
import ChameleonFramework

extension UIViewController {
    func hideKeyboard() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var wojButtonOut: UIButton!
    @IBOutlet weak var powButtonOut: UIButton!
    @IBOutlet weak var searchButtonOut: UIButton!
    @IBOutlet weak var textFieldOut: UITextField!
    @IBOutlet weak var tableViewOut: UITableView!

    
    var wojewDict = [String : String]()
    var outerPowiatMapDict = [String : [String : String]]()
    
    let handlerChooser = HandlerChooser()
    var results = [Description]()
    
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
        self.hideKeyboard()
    }
    
    @IBAction func wojButtonPressed(_ sender: Any) {
        wojDropDown.show()
    }
    @IBAction func powButtonPressed(_ sender: Any) {
        powDropDown.show()
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        let ulica = textFieldOut.text
        var woj = wojButtonOut.title(for: .normal)
        var pow = powButtonOut.title(for: .normal)
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if ulica != nil || woj != nil || pow != nil {
                if let result = self.handlerChooser.XMLChooser(woj: woj, pow: pow, ulica: ulica) {
                    self.results = result
                    self.configureTableView()
                    self.tableViewOut.reloadData()
                }
            }
        
        SVProgressHUD.dismiss()
        }
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
                    powDropDown.dataSource.append("Wszystkie")
                    for (_,name) in innerPowiatDict {
                        if name != "" {
                            powDropDown.dataSource.append(name)
                        }
                    }
                }
            }
        }
        
        powDropDown.selectionAction = { [weak self] (index, item) in
            self?.powButtonOut.setTitle(item, for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        if indexPath.row == 0 {
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            cell.nazwa.text = "Nazwa"
            cell.cecha.text = "Cecha"
            cell.nazwaMsc.text = "Nazwa miejscowości"
            cell.wojewodztwo.text = "Województwo"
            cell.powiat.text = "Powiat"
            cell.identyfikatorMiejscowosci.text = "Identyfikator miejscowości"
            cell.rodziajGminy.text = "Rodzaj gminy"
        } else {
            cell.messageBackground.backgroundColor = UIColor.clear
            cell.nazwa.text = results[indexPath.row-1].NAME
            cell.cecha.text = results[indexPath.row-1].CECH
            cell.nazwaMsc.text = results[indexPath.row-1].CITY_NAME
            for (name, number) in wojewDict {
                if results[indexPath.row-1].WOJ == number {
                    cell.wojewodztwo.text = name.prefix(1).uppercased() + name[1..<name.count].lowercased()
                }
            }
            cell.powiat.text = results[indexPath.row-1].POW
            cell.identyfikatorMiejscowosci.text = results[indexPath.row-1].ID_CITY
            cell.rodziajGminy.text = results[indexPath.row-1].RODZ
        }
        return cell
    }
    
    func configureTableView() {
        tableViewOut.rowHeight = UITableView.automaticDimension
        tableViewOut.estimatedRowHeight = 120.0
    }
    


}

