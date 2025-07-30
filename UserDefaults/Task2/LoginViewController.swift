//
//  LoginViewController.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateTheme()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeManager.themeChangedNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
private extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        configureLabels()
        configureTextField()
        configureButton()
        addSubviews()
    }
    
    func configureLabels() {
        titleLabel.text = "Welcome!"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Enter your email to continue"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
    }
    
    func configureTextField() {
        emailTextField.placeholder = "example@email.com"
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self
    }
    
    func configureButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func addSubviews() {
        [titleLabel, subtitleLabel, emailTextField, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            loginButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

// MARK: - Theme Management
private extension LoginViewController {
    func updateTheme() {
        view.backgroundColor = .systemBackground
        titleLabel.textColor = .label
        subtitleLabel.textColor = .secondaryLabel
    }
    
    @objc func themeDidChange() {
        DispatchQueue.main.async {
            self.updateTheme()
        }
    }
}

// MARK: - Authentication Actions
private extension LoginViewController {
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email")
            return
        }
        
        guard AuthManager.shared.isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return
        }
        
        do {
            try AuthManager.shared.login(email: email)
            switchToMainScreen()
        } catch {
            showAlert(title: "Login failed", message: "Unable to log in. Please try again.")
        }
    }
    
    func switchToMainScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Could not get window")
            return
        }
        
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navigationController
        }, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginButtonTapped()
        return true
    }
}
