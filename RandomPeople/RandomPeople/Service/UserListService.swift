//
//  UserListService.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/31.
//

import Foundation
import RxSwift

class UserListService {
    
    static func fetchUserList(page: Int, result: Int, target: Gender) -> Single<UserListModel> {
        return SessionManger.shared.request(
            UserListModel.self,
            apiType: UserListAPI.fetch(
                page: page,
                result: result,
                target: target
            )
        )
    }
}
