//
//  ViewController.swift
//  CleanArchitecture
//
//  Created by Su Ho V. on 12/16/18.
//  Copyright © 2018 mlsuho. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let bag: DisposeBag = DisposeBag()
    var navi: NavigationController? {
        return navigationController as? NavigationController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    func bindViewModel() {}

    func setupUI() {
        view.backgroundColor = App.Theme.current.package.viewBackground
    }
}
