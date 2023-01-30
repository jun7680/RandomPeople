//
//  UserListModel.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/30.
//

import Foundation

struct UserListModel: Codable {
    let result: [UserResult]
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
        let postCode: String
        
        struct Street: Codable {
            let number: Double
            let name: String
        }
        
        enum CodingKeys: String, CodingKey {
            case street, city, state, country
            case postCode = "postcode"
        }
    }
    
    struct Login: Codable {
        let uuid: String
        let userName: String
        
        enum CodingKeys: String, CodingKey {
            case uuid
            case userName = "username"
        }
    }
    
    struct Dob: Codable {
        let age: Int
    }
    
    struct Picture: Codable {
        let thumbnail: String
    }
}

struct ResultInfo: Codable {
    let results: Double
    let page: Double
}
