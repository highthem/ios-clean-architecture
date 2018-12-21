//
//  SigninViewModel.swift
//  CleanArchitecture
//
//  Created by Su Ho V. on 12/18/18.
//  Copyright © 2018 mlsuho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SigninViewModel: ViewModel {
    struct Input {
        let token: Driver<String>
        let done: Driver<Void>
        let webButton: Driver<Void>
    }

    struct Output {
        let signin: Driver<Void>
        let error: Driver<Error>
    }

    private let navigator: SigninNavigator
    private let authUseCase: AuthUseCase
    private let credentialUseCase: CredentialUseCase

    init(navigator: SigninNavigator,
         authUseCase: AuthUseCase,
         credentialUseCase: CredentialUseCase) {
        self.navigator = navigator
        self.authUseCase = authUseCase
        self.credentialUseCase = credentialUseCase
    }

    func transform(input: SigninViewModel.Input) -> SigninViewModel.Output {
        let rxError = RxError()
        let indicator = RxIndicator()
        let trigger = input.done.withLatestFrom(input.token)
        let signin: Driver<Void> = trigger
            .map { Credential(uid: $0) }
            .flatMapLatest { credentail -> Driver<Credential> in
                return self.authUseCase
                    .signin(credential: credentail)
                    .indicate(indicator)
                    .trackError(into: rxError)
                    .emptyDriverIfError()
                    .map { _ in return credentail }
            }
            .flatMapLatest { credential -> Driver<Credential> in
                return self.credentialUseCase
                    .save(credential: credential)
                    .emptyDriverIfError()
                    .map { cred in return cred }
            }
            .do(onNext: { credential in
                Session.current.token = credential.uid
                userDefaults[.didLogin] = true
                self.navigator.showHome()
            })
            .map { _ in return }
        let error = rxError
            .asDriver()
            .do(onNext: { (error) in
                self.navigator.showError(error)
            })
        _ = input.webButton
            .do(onNext: { _ in
                self.navigator.presentWeb()
            }).drive()
        return Output(signin: signin,
                      error: error)
    }
}
