//
//  AppDelegate.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit
import SQLite3
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - SQLite Variables
    var window: UIWindow?
    var databaseName: String? = "CampusConnect.db"
    var databasePath: String?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Setup SQLite for authentication
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        createDatabaseIfNeeded()

        // 🔍 Check if Core Data model exists
        if let modelURL = Bundle.main.url(forResource: "CampusConnectModel", withExtension: "momd") {
            print("✅ Found Core Data model at: \(modelURL)")
        } else {
            print("❌ Core Data model NOT found in bundle")
        }

        return true
    }

    // MARK: - Create SQLite User Table
    func createDatabaseIfNeeded() {
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            let createUserTable = """
            CREATE TABLE IF NOT EXISTS Users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                studentID TEXT NOT NULL UNIQUE,
                fullName TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL
            );
            """
            if sqlite3_exec(db, createUserTable, nil, nil, nil) == SQLITE_OK {
                print("✅ User table created")
            } else {
                print("❌ Failed to create Users table")
            }
            sqlite3_close(db)
        } else {
            print("❌ Unable to open SQLite database")
        }
    }

    // MARK: - Insert User (SQLite)
    func insertUser(studentID: String, fullName: String, email: String, password: String) -> Bool {
        var db: OpaquePointer? = nil
        var result = false
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            let insertQuery = "INSERT INTO Users (studentID, fullName, email, password) VALUES (?, ?, ?, ?);"
            var stmt: OpaquePointer?
            if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
                sqlite3_bind_text(stmt, 1, (studentID as NSString).utf8String, -1, nil)
                sqlite3_bind_text(stmt, 2, (fullName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(stmt, 3, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(stmt, 4, (password as NSString).utf8String, -1, nil)
                if sqlite3_step(stmt) == SQLITE_DONE {
                    result = true
                    print("✅ User inserted.")
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(db)
        }
        return result
    }

    // MARK: - Authenticate User (SQLite)
    func authenticateUser(email: String, password: String) -> Bool {
        var db: OpaquePointer? = nil
        var found = false
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            let query = "SELECT * FROM Users WHERE email = ? AND password = ?;"
            var stmt: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                sqlite3_bind_text(stmt, 1, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)
                if sqlite3_step(stmt) == SQLITE_ROW {
                    found = true
                    print("✅ Authentication successful")
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(db)
        }
        return found
    }

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CampusConnectModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("❌ Core Data load error: \(error), \(error.userInfo)")
            } else {
                print("✅ Core Data loaded: \(storeDescription)")
            }
        })
        return container
    }()

    // MARK: - Core Data Save
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data context saved")
            } catch {
                let nserror = error as NSError
                fatalError("❌ Core Data save error: \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Scene Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
