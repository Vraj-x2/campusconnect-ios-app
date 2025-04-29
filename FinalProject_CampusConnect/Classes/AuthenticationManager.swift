//
//  AuthenticationManager.swift
//  FinalProject_CampusConnect
//
//  Created by Vraj Contractor.
//

import Foundation
import UIKit

class AuthenticationManager {
    static func login(email: String, password: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.authenticateUser(email: email, password: password)
    }

    static func register(studentID: String, fullName: String, email: String, password: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.insertUser(studentID: studentID, fullName: fullName, email: email, password: password)
    }
}
