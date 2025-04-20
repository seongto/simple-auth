//
//  HomeViewController.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/20/25.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController, HomeViewDelegate {
    // MARK: - Properties
    
    private let homeView = HomeView()
    private let userEntityRepository: UserEntityRepositoryProtocol
    private let deleteUserUseCase: DeleteUserUseCase

    
    // MARK: - init & Life cyclesas
    
    init(userEntityRepository: UserEntityRepositoryProtocol = UserEntityRepository()) {
        self.userEntityRepository = userEntityRepository
        self.deleteUserUseCase = DeleteUserUseCase(userEntityRepository: self.userEntityRepository)
        super.init(nibName: nil, bundle: nil)
        
        homeView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = homeView
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}


// MARK: - Setup UI Layouts

extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = Colors.white
    }
}


// MARK: - Navigation Controll

extension HomeViewController {
    func navigateToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
}


// MARK: - Action Management & Mapping

extension HomeViewController {
    func logout() {
        guard let username = UserDefaults.standard.string(forKey: "currentUsername") else {
            let alertView = AlertView(title: "에러 발생", message: "다시 로그인 해주세요.")
            let _ = ModalManager.createGlobalModal(content: alertView)
            
            return
        }
        
        UserDefaults.standard.removeObject(forKey: "currentUserNickname")
        UserDefaults.standard.removeObject(forKey: "currentUsername")
        navigateToLogin()
    }
    
    func deleteUser() {
        if let username = UserDefaults.standard.string(forKey: "currentUsername") {
            let result = deleteUserUseCase.execute(username)
            switch result {
            case .success:
                UserDefaults.standard.removeObject(forKey: "lastLoginUsername")
                UserDefaults.standard.removeObject(forKey: "lastLoginPassword")
                UserDefaults.standard.removeObject(forKey: "currentUserNickname")
                UserDefaults.standard.removeObject(forKey: "currentUsername")
                
                navigateToLogin()
                
            case .failure:
                let alertView = AlertView(title: "Error", message: "다음에 다시 시도해주세요.")
                let _ = ModalManager.createGlobalModal(content: alertView)
            }
            
        } else {
            let alertView = AlertView(title: "에러 발생", message: "다시 로그인 해주세요.")
            let _ = ModalManager.createGlobalModal(content: alertView)
        }
    }
}


// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}

