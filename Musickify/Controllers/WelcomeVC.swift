//
//  WelcomeVC.swift
//  Musickify
//
//  Created by Nwachukwu Ejiofor on 18/07/2021.
//

import UIKit

class WelcomeVC: UIViewController {
    
    private let signInBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Musickify"
        view.backgroundColor = .systemGreen
        // Do any additional setup after loading the view.
        view.addSubview(signInBtn)
        signInBtn.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInBtn.frame = CGRect(x: 20, y: view.height-60-view.safeAreaInsets.bottom, width: view.width-40, height: 50)
    }
    
    @objc func signInTapped() {
        let vc = LoginVC()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log in user or notify for error
        guard success else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let mainTabVC = TabBarVC()
        mainTabVC.modalPresentationStyle = .fullScreen
        present(mainTabVC, animated: true, completion: nil)
    }

}
