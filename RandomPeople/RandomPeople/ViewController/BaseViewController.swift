//
//  BaseViewController.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(
            title: nil,
            message: "에상치 못한 에러가 발생하였습니다.\n잠시 후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        let defaultAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(defaultAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        overrideUserInterfaceStyle = .light
        initView()
        bind()
        subscribeUI()
        setConstraints()
    }
    func initView() {}
    func setConstraints() {}
    func bind() {}
    func subscribeUI() {}
    
    func presentError() {
        present(alert, animated: true)
    }
    
}
