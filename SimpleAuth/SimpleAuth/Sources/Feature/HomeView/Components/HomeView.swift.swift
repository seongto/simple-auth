//
//  HomeView.swift.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/20/25.
//

import UIKit
import SnapKit


/// LoginView 와 AuthViewController를 연결하는 delegate
protocol HomeViewDelegate: AnyObject {
    func logout()
    func deleteUser()
}

final class HomeView: UIView {
    // MARK: - Properties
    
    let welcomeLabel = UILabel()
    
    let logoutButton = UIButton()
    let deleteUserButton = UIButton()
    
    weak var delegate: HomeViewDelegate?
   
    
    // MARK: - init & Life cycles
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        mapActionToButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Layouts

extension HomeView {
    func setupUI() {
        [
            welcomeLabel,
            logoutButton,
            deleteUserButton
        ].forEach { addSubview($0) }
        
        
        // MARK: - Components Styling & Configuration
        
        self.backgroundColor = Colors.white
        
        if let nickname = UserDefaults.standard.string(forKey: "currentUserNickname") {
            welcomeLabel.applyHeadlineStyle(text: "\(nickname) 님, 환영합니다.")
        } else {
            let alertView = AlertView(title: "에러 발생", message: "다시 로그인 해주세요.")
            let _ = ModalManager.createGlobalModal(content: alertView)
        }
        
        welcomeLabel.setLineSpacing(lineSpacing: 10)
        
        logoutButton.applyTextButtonStyle(title: "로그아웃", textColor: Colors.gray3)
        deleteUserButton.applyTextButtonStyle(title: "회원탈퇴", textColor: Colors.red)
        
        // MARK: - Layouts
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(Layouts.padding)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(200)
            $0.leading.equalToSuperview().inset(Layouts.padding)
            $0.width.equalTo(80)
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(Layouts.padding)
            $0.width.equalTo(80)
        }
    }
}


// MARK: - Action Management & Mapping

extension HomeView {
    /// 버튼 매핑
    func mapActionToButtons() {
        logoutButton.applyButtonAction(action: tapLogoutButton)
        deleteUserButton.applyButtonAction(action: tapDeleteButton)
    }
    
    /// 로그아웃 실행
    func tapLogoutButton() {
        delegate?.logout()
    }
    
    /// 회원 탈퇴 실행
    /// 경고창을 띄우고 확인 시 탈퇴처리
    func tapDeleteButton() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "정말로 탈퇴하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            self.delegate?.deleteUser()
        }))
        
        if let topVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
