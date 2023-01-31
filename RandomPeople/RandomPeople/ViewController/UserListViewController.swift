//
//  ViewController.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/29.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class UserListViewController: BaseViewController {
    
    private let viewModel = UserListViewModel()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(
            items: [Gender.male.rawValue, Gender.female.rawValue]
        )
        
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private let userListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .white
        
        tableView.refreshControl = .init()
        
        return tableView
    }()
    
    private var gender: Gender {
        return selectedGender(index: segmentedControl.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList(isRefresh: false)
    }
    
    private func initNavigationController() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "유저 리스트"
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = .white
        initNavigationController()
    }
    
    override func initView() {
        super.initView()
        
        let views = [
            segmentedControl,
            userListTableView
        ]
        
        view.addSubviews(views)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        userListTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    override func bind() {
        super.bind()
        // 유저 리스트 바인딩
        viewModel.outputs.userListItemsObservable
            .bind(to: userListTableView.rx.items(
                cellIdentifier: UserListCell.identifier,
                cellType: UserListCell.self)
            ) { _, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.userListItemsObservable
            .bind(with: self) { owner, _ in
                owner.userListTableView.refreshControl?.endRefreshing()
            }.disposed(by: disposeBag)
        
        viewModel.outputs.errorObservable
            .bind(with: self) { owner, _ in
                owner.presentError()
            }.disposed(by: disposeBag)
    }
    
    override func subscribeUI() {
        userListTableView.rx.willDisplayCell
            .bind(with: self) { owner, cell in
                owner.viewModel.inputs.fetchMoreUserList(
                    index: cell.indexPath.row,
                    gender: owner.gender
                )
            }.disposed(by: disposeBag)
        
        userListTableView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.inputs.fetchUserList(isRefresh: true, gender: owner.gender)
            }.disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .bind(with: self) { owner, index in
                owner.viewModel.inputs.fetchUserList(isRefresh: true, gender: owner.gender)
            }.disposed(by: disposeBag)
    }
    
    private func fetchList(isRefresh: Bool) {
        viewModel.inputs.fetchUserList(isRefresh: isRefresh, gender: gender)
    }
    
    private func selectedGender(index: Int) -> Gender {
        if index == 0 { return .male }
        else if index == 1 { return .female }
        else { return .male }
    }
}

