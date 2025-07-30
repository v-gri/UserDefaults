//
//  SettingsViewController.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let sections = ["Theme", "UserDefaults Statistics"]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
private extension SettingsViewController {
    func setupUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureNavigationBar()
        configureTableView()
        addSubviews()
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.separatorStyle = .singleLine
    }
    
    func addSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Theme Management
private extension SettingsViewController {
    func updateTheme() {
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    @objc func themeDidChange() {
        DispatchQueue.main.async {
            self.updateTheme()
            self.tableView.reloadData()
        }
    }
}

// MARK: - Actions
private extension SettingsViewController {
    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func darkModeToggleChanged(_ sender: UISwitch) {
        let selectedTheme: ThemeMode = sender.isOn ? .dark : .light
        do {
            try ThemeManager.shared.saveTheme(selectedTheme)
        } catch {
            sender.setOn(!sender.isOn, animated: true)
            showAlert(title: "Error", message: "Unable to save theme preference")
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureThemeCell(for: indexPath)
        case 1:
            return configureStatisticsCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Cell Configuration
private extension SettingsViewController {
    func configureThemeCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
        cell.textLabel?.text = "Dark Mode"
        cell.switchControl.isOn = ThemeManager.shared.currentTheme == .dark
        cell.switchControl.removeTarget(nil, action: nil, for: .allEvents)
        cell.switchControl.addTarget(self, action: #selector(darkModeToggleChanged), for: .valueChanged)
        return cell
    }
    
    func configureStatisticsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = AuthManager.shared.userEmail ?? "Not specified"
        case 1:
            cell.textLabel?.text = "Login Status"
            cell.detailTextLabel?.text = AuthManager.shared.isLoggedIn ? "Logged In" : "Not Logged In"
        case 2:
            cell.textLabel?.text = "Saved Searches"
            let searchCount = SearchManager.shared.getRecentSearches().count
            cell.detailTextLabel?.text = "\(searchCount)/5"
        case 3:
            cell.textLabel?.text = "Current Theme"
            cell.detailTextLabel?.text = ThemeManager.shared.currentTheme.displayName
        default:
            break
        }
        
        cell.backgroundColor = .secondarySystemGroupedBackground
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = sections[section].uppercased()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -6)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}

// MARK: - Custom Switch Cell
class SwitchTableViewCell: UITableViewCell {
    let switchControl = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
        accessoryView = switchControl
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        switchControl.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .secondarySystemGroupedBackground
        textLabel?.textColor = .label
    }
}
