//
//  SignupViewController.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//
//

import UIKit
import SnapKit


class SignupViewController: UIViewController, SignupViewDelegate {
    // MARK: - Properties
    
    private let userEntityRepository: UserEntityRepositoryProtocol
    private let signupUseCase: SignupUseCase
    private let signupView = SignupView()
        
    
    // MARK: - init & Life cycles
    
    init(userEntityRepository: UserEntityRepositoryProtocol = UserEntityRepository()) {
        self.userEntityRepository = userEntityRepository
        self.signupUseCase = SignupUseCase(userEntityRepository: self.userEntityRepository)
        super.init(nibName: nil, bundle: nil)
        
        signupView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = signupView
        setupUI()
    }
}


// MARK: - Setup UI Layouts

extension SignupViewController {
    private func setupUI() {
        view.backgroundColor = Colors.white
    }
}


// MARK: - Action Management & Mapping

extension SignupViewController {
    
    /// 회원가입을 요청하는 메소드.
    /// - Parameters:
    ///   - username: 사용자가 입력한 사용자 아이디
    ///   - password: 사용자가 입력한 사용자 암호
    func requestSignup(username: String, nickname: String, password: String, passwordConfirm: String) {
        if password != passwordConfirm {
            let alertView = AlertView(title: "회원 가입 실패", message: "확인 패스워드가 일치하지 않습니다.")
            let _ = ModalManager.createGlobalModal(content: alertView)
            return
        }
        
        let result = signupUseCase.execute(( username: username, nickname: nickname, password: password ))
        switch result {
        case .success:
            let alertView = AlertView(title: "회원 가입 성공", message: "로그인 화면으로 돌아갑니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            let _ = ModalManager.createGlobalModal(content: alertView)
        case .failure(let error):
            let errorMessage: String = error.messages.reduce("") { "\($0)\n- \($1)" }
            print(errorMessage)
            let alertView = AlertView(title: "회원 가입 실패", message: errorMessage)
            
            let _ = ModalManager.createGlobalModal(content: alertView)
        }
    }
}
    

