//
//  RegisterViewModel.swift
//  LoginValidationRxSwiftUIkit
//
//  Created by Putra on 11/08/22.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: ObservableObject {
    private(set) var emailSubject = PublishSubject<String>()
    private(set) var emailCheckResult = BehaviorSubject<String>(value: "")
    private(set) var hideEmail = BehaviorSubject<Bool>(value: false)
    private(set) var nameSubject = PublishSubject<String>()
    private(set) var nameCheckResult = BehaviorSubject<String>(value: "")
    private(set) var hideName = BehaviorSubject<Bool>(value: false)
    private(set) var passwordSubject = PublishSubject<String>()
    private(set) var passwordCheckResult = BehaviorSubject<String>(value: "")
    private(set) var hidePassword = BehaviorSubject<Bool>(value: false)
    private(set) var confirmPasswordSubject = PublishSubject<String>()
    private(set) var confirmPasswordCheckResult = BehaviorSubject<String>(value: "")
    private(set) var confirmHidePassword = BehaviorSubject<Bool>(value: false)
    private(set) var capitalizeCheck = PublishSubject<String>()
    private(set) var charactersCheck = PublishSubject<String>()
    private(set) var numberCheck = PublishSubject<String>()
    private(set) var emailIsValid = BehaviorSubject<Bool>(value: false)
    private(set) var usernameIsValid = BehaviorSubject<Bool>(value: false)
    private(set) var passwordIsValid = BehaviorSubject<Bool>(value: false)
    private(set) var confirmIsValid = BehaviorSubject<Bool>(value: false)
    private var tempEmail = ""
    private var isErrorEmail = true
    private(set) var confirmValue = ""
    private(set) var disposeBag = DisposeBag()
    private var stilEdit = true
    
//    func isValidEmail() -> Observable<Bool> {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailSubject.map { emailPred.evaluate(with: $0) }
//    }
    
    func checkName() -> Observable<Bool> {
        return nameSubject.map {
            self.usernameIsValid.onNext($0.count > 0)
            return $0.count > 0
        }
    }
    
    func isCekEmail() -> Observable<String> {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        emailSubject.subscribe(onNext: { [weak self] value in
            if value.isEmpty {
                self?.emailCheckResult.onNext("email cannot be empty")
                self?.isErrorEmail = false
            }else if !emailPred.evaluate(with: value) {
                self?.emailCheckResult.onNext("email is invalid")
                self?.isErrorEmail = true
            }else if emailPred.evaluate(with: value) {
                self?.emailCheckResult.onNext("")
                self?.hideEmail.onNext(true)
                self?.emailIsValid.onNext(true)
                self?.isErrorEmail = true
            }
        }).disposed(by: disposeBag)
        return emailCheckResult.map { $0 }
    }
    
    func isEditingEmailField() -> Observable<Bool> {
        emailSubject.subscribe(onNext: { [weak self] value in
            if value != self?.tempEmail {
                self?.hideEmail.onNext(true)
                self?.tempEmail = value
                if value == self?.tempEmail && self?.isErrorEmail == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.hideEmail.onNext(false)
                    })
                }
            }else {
                self?.hideEmail.onNext(false)
            }
        }).disposed(by: disposeBag)
        return self.hideEmail.map{ $0 }
    }
    
    func checkPasswordCharacter() -> Observable<Bool> {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capilatCheck = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numberCheck = NSPredicate(format:"SELF MATCHES %@", numberRegEx)

        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let specialCharCheck = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        return passwordSubject.map { [weak self] value in
            if value.count <= 8 {
                self?.passwordCheckResult.onNext("minimum password length is 8")
            }else if !capilatCheck.evaluate(with: value) {
                self?.passwordCheckResult.onNext("password must contains capital character")
            }else if !numberCheck.evaluate(with: value) {
                self?.passwordCheckResult.onNext("password must contains number")
            }else if !specialCharCheck.evaluate(with: value) {
                self?.passwordCheckResult.onNext("password must contains special character")
            }
            self?.passwordIsValid.onNext(capilatCheck.evaluate(with: value) && numberCheck.evaluate(with: value) && specialCharCheck.evaluate(with: value))
            return capilatCheck.evaluate(with: value) && numberCheck.evaluate(with: value) && specialCharCheck.evaluate(with: value)
        }
    }
    
    func checkPassword() -> Observable<Bool> {
        return passwordSubject.map { [weak self] value in
            self?.passwordIsValid.onNext(value.count >= 0)
            return value.count >= 8
        }
    }
    
    func checkConfirmPassword() -> Observable<Bool> {
        return Observable.combineLatest(passwordSubject.asObservable().startWith(""), confirmPasswordSubject.asObservable().startWith("")).map { password, confirm in
            self.confirmIsValid.onNext(password == confirm)
            return password == confirm
        }.startWith(false)
    }
    
    func isValidForm() -> Observable<Bool> {
        return Observable.combineLatest(emailIsValid.asObservable(), passwordIsValid.asObservable(), confirmIsValid.asObservable(), usernameIsValid.asObservable()).map {email, password, confirm, name in
            return email && password && confirm && name
        }.startWith(false)
    }
    
    
}
