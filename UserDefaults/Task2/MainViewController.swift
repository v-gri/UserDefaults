//
//  MainViewController.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    private let welcomeLabel = UILabel()
    private let emailLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private let searchButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateTheme()
        updateUserInfo()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeManager.themeChangedNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
private extension MainViewController {
    func setupUI() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureLabels()
        configureStackView()
        configureButtons()
        addSubviews()
    }
    
    func configureLabels() {
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textAlignment = .center
        
        emailLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
    }
    
    func configureStackView() {
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 20
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
    }
    
    func configureButtons() {
        setupButton(searchButton, title: "Search", backgroundColor: .systemBlue)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        setupButton(settingsButton, title: "Settings", backgroundColor: .systemIndigo)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        setupButton(logoutButton, title: "Logout", backgroundColor: .systemRed)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        [searchButton, settingsButton, logoutButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
    }
    
    func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
    }
    
    func addSubviews() {
        [welcomeLabel, emailLabel, buttonsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            searchButton.heightAnchor.constraint(equalToConstant: 56),
            settingsButton.heightAnchor.constraint(equalToConstant: 56),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

// MARK: - Theme & UI Updates
private extension MainViewController {
    func updateUserInfo() {
        if let email = AuthManager.shared.userEmail {
            emailLabel.text = email
        }
    }
    
    func updateTheme() {
        view.backgroundColor = .systemBackground
        welcomeLabel.textColor = .label
        emailLabel.textColor = .secondaryLabel
    }
    
    @objc func themeDidChange() {
        DispatchQueue.main.async {
            self.updateTheme()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Button Actions
private extension MainViewController {
    @objc func searchButtonTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsVC)
        navigationController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        present(navigationController, animated: true)
    }
    
    @objc func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout? All data will be cleared from UserDefaults.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.performLogout()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - Authentication Flow
private extension MainViewController {
    func performLogout() {
        do {
            try AuthManager.shared.logout()
            switchToLoginScreen()
        } catch {
            showAlert(title: "Logout Failed", message: "Unable to log out. Please try again.")
        }
    }
    
    func switchToLoginScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Could not get window")
            return
        }
        
        let loginVC = LoginViewController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginVC
        }, completion: nil)
    }
}
