//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet weak var nazwa: UILabel!
    @IBOutlet weak var cecha: UILabel!
    @IBOutlet weak var wojewodztwo: UILabel!
    @IBOutlet weak var powiat: UILabel!
    @IBOutlet weak var gmina: UILabel!
    @IBOutlet weak var rodziajGminy: UILabel!
    @IBOutlet weak var nazwaMsc: UILabel!
    @IBOutlet weak var identyfikatorMsc: UILabel!
    @IBOutlet weak var IdentyfikatorUlicy: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
