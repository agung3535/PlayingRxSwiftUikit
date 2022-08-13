//
//  LoginViewModel.swift
//  LoginValidationRxSwiftUIkit
//
//  Created by Putra on 11/08/22.
//

import Foundation
import RxSwift

class LoginViewModel: ObservableObject {
    
    var usernameSubject = PublishSubject<String>()
    var passwordSubject = PublishSubject<String>()
    
    
    func isValidForm() -> Observable<Bool> {
        return Observable.combineLatest(usernameSubject.asObservable().startWith(""), passwordSubject.asObservable().startWith("")).map { username, password in
            return username.count > 4 && password.count > 8
        }.startWith(false)
    }
    
    
}
