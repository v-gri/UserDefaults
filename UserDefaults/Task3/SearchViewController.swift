//
//  SearchViewController.swift
//  UserDefaults
//
//  Created by Vika on 29.07.25.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - UI Elements
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let recentSearchesLabel = UILabel()
    private let tableView = UITableView()
    private let clearAllButton = UIButton(type: .system)
    
    private let emptyStateStackView = UIStackView()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var recentSearches: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateTheme()
        loadRecentSearches()
        
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
private extension SearchViewController {
    func setupUI() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTextField()
        configureSearchButton()
        configureLabel()
        configureTableView()
        configureClearButton()
        setupEmptyState()
        addSubviews()
    }
    
    func configureTextField() {
        searchTextField.placeholder = "Enter search term..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
    }
    
    func configureSearchButton() {
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = 12
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    func configureLabel() {
        recentSearchesLabel.text = "Recent searches (max 5):"
        recentSearchesLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.layer.cornerRadius = 8
        tableView.backgroundColor = .clear
    }
    
    func configureClearButton() {
        clearAllButton.setTitle("Clear All", for: .normal)
        clearAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        clearAllButton.backgroundColor = .systemRed
        clearAllButton.setTitleColor(.white, for: .normal)
        clearAllButton.layer.cornerRadius = 8
        clearAllButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        clearAllButton.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
    }
    
    func setupEmptyState() {
        emptyStateStackView.axis = .vertical
        emptyStateStackView.alignment = .center
        emptyStateStackView.spacing = 16
        
        emptyStateImageView.image = UIImage(systemName: "magnifyingglass.circle")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.tintColor = .systemGray3
        
        emptyStateLabel.text = "No recent searches"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        
        emptyStateStackView.addArrangedSubview(emptyStateImageView)
        emptyStateStackView.addArrangedSubview(emptyStateLabel)
    }
    
    func addSubviews() {
        [searchTextField, searchButton, recentSearchesLabel, tableView, clearAllButton, emptyStateStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            recentSearchesLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 40),
            recentSearchesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentSearchesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: recentSearchesLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: clearAllButton.topAnchor, constant: -16),
            
            clearAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clearAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearAllButton.heightAnchor.constraint(equalToConstant: 40),
            
            emptyStateStackView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateStackView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

// MARK: - Data Management
private extension SearchViewController {
    func loadRecentSearches() {
        recentSearches = SearchManager.shared.getRecentSearches()
        updateUI()
    }
    
    func updateUI() {
        tableView.reloadData()
        
        let isEmpty = recentSearches.isEmpty
        tableView.isHidden = isEmpty
        emptyStateStackView.isHidden = !isEmpty
        clearAllButton.isHidden = isEmpty
        recentSearchesLabel.isHidden = isEmpty
    }
}

// MARK: - Theme Management
private extension SearchViewController {
    func updateTheme() {
        view.backgroundColor = .systemBackground
        recentSearchesLabel.textColor = .label
    }
    
    @objc func themeDidChange() {
        DispatchQueue.main.async {
            self.updateTheme()
        }
    }
}

// MARK: - Search Actions
private extension SearchViewController {
    @objc func searchButtonTapped() {
        performSearch()
    }
    
    @objc func clearAllButtonTapped() {
        let alert = UIAlertController(
            title: "Clear History",
            message: "Delete all search queries?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            do {
                try SearchManager.shared.clearAllSearches()
                self.loadRecentSearches()
            } catch {
                self.showAlert(title: "Error", message: "Unable to clear search history")
            }
        })
        
        present(alert, animated: true)
    }
    
    func performSearch() {
        guard let searchTerm = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchTerm.isEmpty else {
            showAlert(title: "Error", message: "Enter a search term")
            return
        }
        
        do {
                try SearchManager.shared.addSearch(searchTerm)
                loadRecentSearches()
                
                searchTextField.text = ""
                searchTextField.resignFirstResponder()
                
                showSearchResult(searchTerm)
            } catch {
                showAlert(title: "Error", message: "Unable to save search")
            }
    }
    
    func showSearchResult(_ searchTerm: String) {
        let alert = UIAlertController(
            title: "Search Complete",
            message: "Query '\(searchTerm)' saved to UserDefaults!\n\nTotal saved searches: \(recentSearches.count)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        let searchTerm = recentSearches[indexPath.row]
        cell.textLabel?.text = searchTerm
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSearch = recentSearches[indexPath.row]
        searchTextField.text = selectedSearch
        
        let alert = UIAlertController(
            title: "Search Selected",
            message: "'\(selectedSearch)' added to search field",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let searchToRemove = recentSearches[indexPath.row]
            do {
                try SearchManager.shared.removeSearch(searchToRemove)
                loadRecentSearches()
            } catch {
                showAlert(title: "Error", message: "Unable to remove search")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}
