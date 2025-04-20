//
//  SignupView.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import UIKit
import SnapKit


/// SignupView 와 SignupViewController를 연결하는 delegate
protocol SignupViewDelegate: AnyObject {
    func requestSignup(username: String, nickname: String, password: String, passwordConfirm: String)
}


final class SignupView: UIView {
    // MARK: - Properties
    
    let scrollView = UIScrollView() // 스크롤 기능 추가
    let contentView = UIView() // 실제 컨텐츠를 담는 공간
    
    let headerLabel = UILabel()
    let inputUsername = UITextField()
    let inputNickname = UITextField()
    let inputPassword = UITextField()
    let inputPasswordConfirm = UITextField()
    let inputLabelUsername = UILabel()
    let inputLabelNickname = UILabel()
    let inputLabelPassword = UILabel()
    let inputLabelPasswordConfirm = UILabel()
    let signupButton = UIButton()
    let lastView = UIView()
    
    weak var delegate: SignupViewDelegate?
    
    
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(frame: .zero)
        setupUI()
        mapActionToButtons()
        
        inputUsername.delegate = self
        inputPassword.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI Layouts

extension SignupView {
    func setupUI() {
        [
            headerLabel,
            inputUsername,
            inputNickname,
            inputPassword,
            inputPasswordConfirm,
            inputLabelUsername,
            inputLabelNickname,
            inputLabelPassword,
            inputLabelPasswordConfirm,
            signupButton,
            lastView
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        self.addSubview(scrollView)
        
        
        // MARK: - Components Styling & Configuration
        
        scrollView.applyVerticalStyle()
        headerLabel.applyHeadlineStyle(text: "회원 가입")
        
        inputNickname.applyInputBoxStyle(placeholder: "사용자 별명을 입력해주세요.")
        inputUsername.applyInputBoxStyle(placeholder: "이메일을 입력해주세요.")
        inputPassword.applyInputBoxStyle(placeholder: "패스워드를 입력해주세요.", isSecret: true)
        inputPassword.addShowHidePasswordButton()
        inputPasswordConfirm.applyInputBoxStyle(placeholder: "패스워드를 다시 입력해주세요.", isSecret: true)
        inputPasswordConfirm.addShowHidePasswordButton()
        
        inputLabelNickname.applyInputLabelStyle(text: "별명")
        inputLabelUsername.applyInputLabelStyle(text: "이메일")
        inputLabelPassword.applyInputLabelStyle(text: "패스워드")
        inputLabelPasswordConfirm.applyInputLabelStyle(text: "패스워드 확인")
        
        signupButton.applyFullSizeButtonStyle(title: "회원가입", bgColor: Colors.blue)
        
        
        // MARK: - Layouts
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelNickname.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputNickname.snp.makeConstraints {
            $0.top.equalTo(inputLabelNickname.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelUsername.snp.makeConstraints {
            $0.top.equalTo(inputNickname.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputUsername.snp.makeConstraints {
            $0.top.equalTo(inputLabelUsername.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelPassword.snp.makeConstraints {
            $0.top.equalTo(inputUsername.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputPassword.snp.makeConstraints {
            $0.top.equalTo(inputLabelPassword.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputLabelPasswordConfirm.snp.makeConstraints {
            $0.top.equalTo(inputPassword.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        inputPasswordConfirm.snp.makeConstraints {
            $0.top.equalTo(inputLabelPasswordConfirm.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(inputPasswordConfirm.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        lastView.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
            $0.height.greaterThanOrEqualTo(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        
    }
}


// MARK: - Action Management & Mapping

extension SignupView {
    /// 버튼 액션 매핑
    func mapActionToButtons() {
        signupButton.applyButtonAction(action: tapSignupButton)
    }
    
    /// 가입 완료 액션 매핑
    /// 사용자가 입력한 패스워드가 동일하게 맞는
    func tapSignupButton() {
        if let username: String = inputUsername.text,
           let nickname: String = inputNickname.text,
           let password: String = inputPassword.text,
           let passwordConfirm: String = inputPasswordConfirm.text {
            delegate?.requestSignup(username: username, nickname: nickname, password: password, passwordConfirm: passwordConfirm)
        }
    }
}

// MARK: - Interface Improvements

extension SignupView: UITextFieldDelegate {
    /// 입력창 이동 및 키보드 인터페이스 관리
    /// - Parameter textField: 현재 선택된 텍스트필드
    /// - Returns: 현재 텍스트필드에 따라 다름.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputUsername {
            inputNickname.becomeFirstResponder()
        } else if textField == inputNickname {
            inputPassword.becomeFirstResponder()
        } else if textField == inputPassword {
            inputPasswordConfirm.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
