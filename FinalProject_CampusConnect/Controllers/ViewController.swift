//
//  ViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Default User on 4/11/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        print("⬅️ Unwound back to landing page from \(segue.source)")
    }
}

