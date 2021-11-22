//
//  Human.swift
//  CoreDataDemoApp
//
//  Created by Vasile Vornic on 11/10/21.
//

import Foundation

struct Human {
    var name: String?
    var age: Int
    let id: String
    let userId: UUID?
    let cars: [Car]
}
