//
//  UserViewController.swift
//  DALocalAuthentication
//
//  Created by Dejan on 05/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    public var currentUser: String?
    
    @IBOutlet weak var currentUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentUserLabel.text = self.currentUser ?? ""
    }
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
