//
//  UserListViewModel.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/31.
//

import Foundation
import RxSwift
import RxRelay

protocol UserListViewModelInput {
    func fetchUserList(isRefresh: Bool, gender: Gender)
    func fetchMoreUserList(index: Int, gender: Gender)
    
    var userListRelay: PublishRelay<[UserResult]> { get }
    var errorRelay: PublishRelay<Void> { get }
}

protocol UserListViewModelOutput {
    var userListItemsObservable: Observable<[UserResult]> { get }
    var errorObservable: Observable<Void> { get }
}

class UserListViewModel: UserListViewModelInput, UserListViewModelOutput {
    
    // DisposeBag
    private let disposeBag = DisposeBag()
    
    var inputs: UserListViewModelInput { return self }
    var outputs: UserListViewModelOutput { return self }
    
    // MARK: - input property
    var userListRelay: PublishRelay<[UserResult]> = PublishRelay<[UserResult]>()
    var errorRelay: PublishRelay<Void> = PublishRelay<Void>()
    
    // MARK: - ouput property
    var userListItemsObservable: Observable<[UserResult]> {
        return userListRelay.asObservable()
    }
    
    var errorObservable: Observable<Void> {
        return errorRelay.asObservable()
    }
    
    // MARK: - private property
    private var page = 1
    private var limit = 20
    private var isMoreItems = true
    private var isRequesting = false
    private var items: [UserResult] = []
        
    private func makeSnippets(with item: [UserResult]) {
        items.append(contentsOf: item)
        
        userListRelay.accept(items)
    }
    
    private func refresh() {
        page = 1
        items.removeAll()
        userListRelay.accept([])
    }
}

// MARK: - input Function
extension UserListViewModel {
    func fetchUserList(isRefresh: Bool, gender: Gender) {
        
        if isRefresh {
            refresh()
        }
        
        // 중복 호출 방지
        guard !isRequesting, isMoreItems else { return }
        isRequesting = true
        
        UserListService.fetchUserList(page: page, result: limit, target: gender)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .debug()
            .subscribe(with: self, onSuccess: { owner, result in
                if result.info.results < owner.limit {
                    owner.isMoreItems = false
                } else {
                    owner.page += 1
                    owner.isMoreItems = true
                }
                owner.makeSnippets(with: result.results)
            }, onFailure: { owner, error in
                owner.errorRelay.accept(())
            }, onDisposed: { owner in
                owner.isRequesting = false
            })
            .disposed(by: disposeBag)
    }

    func fetchMoreUserList(index: Int, gender: Gender) {
        if items.count - 3 <= index {
            fetchUserList(isRefresh: false, gender: gender)
        }
    }
}
