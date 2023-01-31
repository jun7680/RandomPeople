//
//  UserListModel.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/30.
//

import Foundation

struct UserListModel: Codable {
    let results: [UserResult]
    let info: ResultInfo
}

struct UserResult: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: Dob
    let phone: String
    let cell: String
    let picture: Picture
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Location: Codable {
        let street: Street
        let city: String
        let state: String
        let country: String

        struct Street: Codable {
            let number: Int
            let name: String
        }
    }
    
    struct Login: Codable {
        let uuid: String
        let username: String
    }
    
    struct Dob: Codable {
        let age: Int
    }
    
    struct Picture: Codable {
        let thumbnail: String
    }
}

extension UserResult {
    var userInfo: String {
        let name = name.title + ". " + name.first + " " + name.last
        
        return name
    }
    
    var age: Int {
        return dob.age
    }
    
    var locationDesciption: String {
        return location.country + " / " + location.city
    }
}

struct ResultInfo: Codable {
    let results: Int
    let page: Int
}
