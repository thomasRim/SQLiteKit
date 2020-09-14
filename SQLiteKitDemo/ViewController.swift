//
//  ViewController.swift
//  dbTest
//
//  Created by Vladimir Evdokimov on 2020-06-23.
//  Copyright © 2020 RootHome. All rights reserved.
//

import UIKit

import SQLiteKit
//import SQLiteSwift

class ViewController: UIViewController {

    let dbPath = NSHomeDirectory().appending("/Documents/db.sqlite")
    var db: SQLiteConnection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if FileManager.default.fileExists(atPath: dbPath) {
            db = try? SQLiteConnection(databasePath: dbPath, openFlags: .readWrite)
        } else {
            db = try? SQLiteConnection(databasePath: dbPath, openFlags: [.readWrite, .create])
        }
        
        
        try? db.createTable(User.self)
        
        demo()
    }

    
    func demo() {
        queryUser()
    }

    fileprivate func queryUser() {
        let userQuery:SQLiteTableQuery<User> = db.table(of: User.self)
        let count = userQuery.count
        print("find users count:\(count)")
        var users: [User] = userQuery.limit(3).toList()
        print(users)
        
        if let res: [User] = userQuery.filter(using: NSPredicate(format: "userID = 2")), res.count > 0 {
            
            var ru = res[0]
            
//            try? db.delete(res[0])

            ru.items = ["asfasdfasdfasdf", "\(Date().timeIntervalSince1970)"]
            do {
            try db.insertOrReplace(ru)
            } catch let err {
                print("\(err)")
            }
        }
        
        let u = User()
        u.name = "222"
        u.age = 30
        u.items = ["wef","qwef"]
        u.birthday = Date()

        try? db.insert(u)
        
        users = userQuery.limit(30).toList()
        print(users)
    }
}

class User: SQLiteCodable {
    
    var userID: Int 
    var name: String
    var age: Int
    var items = [String]()
    var birthday: Date
    var avatarData: Data?
        
    static func attributes() -> [SQLiteAttribute] {
        return [
            SQLiteAttribute(name: "userID", attribute: .isPK),
            SQLiteAttribute(name: "userID", attribute: .autoInc)
        ]
    }
    
    required init() {
        userID = 0
        name = ""
        age = 0
        birthday = Date()
    }
}

