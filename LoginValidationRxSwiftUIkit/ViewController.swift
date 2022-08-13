//
//  ViewController.swift
//  LoginValidationRxSwiftUIkit
//
//  Created by Putra on 11/08/22.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var btnSigninView: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var btnRegisterView: UIButton!
    @IBOutlet weak var userNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnSigninView.layer.cornerRadius = 5
        btnRegisterView.layer.borderWidth = 1
        btnRegisterView.layer.borderColor = #colorLiteral(red: 1, green: 0.6181305051, blue: 0.1645659506, alpha: 1)
        btnRegisterView.layer.cornerRadius = 5
        userNameTxt.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.usernameSubject).disposed(by: disposeBag)
        passwordTxt.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.passwordSubject).disposed(by: disposeBag)
        
        loginViewModel.isValidForm().subscribe(onNext: { [weak self] isValid in
            if isValid {
                self?.btnSigninView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.6181305051, blue: 0.1645659506, alpha: 1)
                self?.btnSigninView.isUserInteractionEnabled = true
            }else {
                self?.btnSigninView.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                self?.btnSigninView.isUserInteractionEnabled = false            }
        }).disposed(by: disposeBag)
        
    }

    @IBAction func registerAction(_ sender: Any) {
        if let vc = RegisterViewController(nibName: RegisterViewController.identifier, bundle: nil) as? RegisterViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

