//
//  UserAPI.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/30.
//

import Foundation

enum UserListAPI {
    case fetch(page: Int, result: Int, target: Gender)
}

extension UserListAPI: APIType {
    var baseURL: URL {
        guard let url = URL(string: "https://randomuser.me")
        else { fatalError("UserListAPI BaseURL not exist...") }
        
        return url
    }
    
    var path: String {
        switch self {
        case .fetch: return "/api"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case let .fetch(page, result, target):
            return [
                "page": page,
                "results": result,
                "gender": target.rawValue
            ]
        }
    }
}

enum Gender: String {
    case male
    case female
}
