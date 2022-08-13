//
//  RegisterViewController.swift
//  LoginValidationRxSwiftUIkit
//
//  Created by Putra on 11/08/22.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {

    static let identifier = "RegisterViewController"
    let registerViewModel = RegisterViewModel()
    @IBOutlet weak var emailCaution: UILabel!
    @IBOutlet weak var registerBtnView: UIButton!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!

    @IBOutlet weak var confirmPassCaution: UILabel!
    @IBOutlet weak var passwordCaution: UILabel!
    @IBOutlet weak var usernameCaution: UILabel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerBtnView.layer.cornerRadius = 5
        emailCaution.isHidden = true
        confirmPassCaution.isHidden = true
        usernameCaution.isHidden = true
        passwordCaution.isHidden = true
        emailTxt.rx.text.map { $0 ?? "" }.bind(to: registerViewModel.emailSubject).disposed(by: disposeBag)
        usernameTxt.rx.text.map { $0 ?? ""}.bind(to: registerViewModel.nameSubject).disposed(by: disposeBag)
        passwordTxt.rx.text.map { $0 ?? ""}.bind(to: registerViewModel.passwordSubject).disposed(by: disposeBag)
        confirmPasswordTxt.rx.text.map { $0 ?? ""}.bind(to: registerViewModel.confirmPasswordSubject).disposed(by: disposeBag)
        registerViewModel.checkName().bind(to: usernameCaution.rx.isHidden).disposed(by: disposeBag)
        registerViewModel.checkPasswordCharacter().bind(to: passwordCaution.rx.isHidden).disposed(by: disposeBag)
        registerViewModel.checkConfirmPassword().bind(to: confirmPassCaution.rx.isHidden).disposed(by: disposeBag)
        registerViewModel.passwordCheckResult.subscribe(onNext: {[weak self] value in
            self?.passwordCaution.text = value
        }).disposed(by: disposeBag)
        registerViewModel.hideEmail.subscribe(onNext: {[weak self] value in
            self?.emailCaution.isHidden = value
        }).disposed(by: disposeBag)
        registerViewModel.isCekEmail().subscribe(onNext: { [weak self] value in
            self?.emailCaution.text = value
        }).disposed(by: disposeBag)
        registerViewModel.isEditingEmailField().subscribe(onNext: { [weak self] value in
            self?.emailCaution.isHidden = value
        }).disposed(by: disposeBag)
        registerViewModel.isValidForm().subscribe(onNext: {[weak self] value in
            if value {
                self?.registerBtnView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.6181305051, blue: 0.1645659506, alpha: 1)
            }else {
                self?.registerBtnView.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }).disposed(by: disposeBag)
//        registerViewModel.isValidEmail().bind(to: emailCaution.rx.isHidden).disposed(by: disposeBag)
    }

}

