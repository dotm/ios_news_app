//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    //MARK: Outlets
    private weak var searchBar: UISearchBar!
    private weak var newsList: NewsList!
    private weak var searchHistory: SearchHistory!

    //MARK: Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLayout()
    }
    
    //MARK: Action
    final private func goToNewsDetailPage(){
        let newsDetail = NewsDetailViewController()
        self.navigationController?.pushViewController(newsDetail, animated: true)
    }

    //MARK: Layout
    final private func setupLayout(){
        setupSearchBar()
        setupNewsList()
        setupSearchHistory()
    }
    final private func setupSearchBar(){
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search News"
        searchBar.showsCancelButton = true
        let searchBarCancelButtonColor = UIColor.blue
        UIBarButtonItem
            .appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes(
                [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): searchBarCancelButtonColor],
                for: .normal
            )
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar

        self.searchBar = searchBar
    }
    final private func setupNewsList(){
        let newsList = NewsList()
        view.addSubview(newsList)
        
        newsList.translatesAutoresizingMaskIntoConstraints = false
        newsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsList = newsList
    }
    final private func setupSearchHistory(){
        let searchHistory = SearchHistory(delegate: self)
        view.addSubview(searchHistory)
        
        searchHistory.translatesAutoresizingMaskIntoConstraints = false
        searchHistory.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchHistory.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchHistory.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchHistory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        searchHistory.isHidden = true
        self.searchHistory = searchHistory
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchHistory.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchHistory.isHidden = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.text = ""
        self.newsList.query = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.newsList.query = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        SearchHistoryData.save(query: searchBar.text)
        searchHistory.reloadData()
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
    }
}
