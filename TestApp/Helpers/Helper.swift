//
//  Helper.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

let db = Database.database().reference()

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let startVC = storyboard.instantiateViewController(withIdentifier: "startVC")

let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
