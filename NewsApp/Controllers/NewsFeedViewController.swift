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
        newsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        newsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsList = newsList
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceSearch(delay: 3) {
            self.newsList.query = searchText
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchTimer()
        searchBar.resignFirstResponder()
        
        searchBar.text = ""
        self.newsList.query = ""
    }
}

fileprivate var searchTimer: Timer?
fileprivate func debounceSearch(delay: TimeInterval, closure: @escaping ()->()){
    clearSearchTimer()
    searchTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (_) in
        closure()
    }
}
fileprivate func clearSearchTimer(){
    if let previousTimer = searchTimer {
        previousTimer.invalidate()
        searchTimer = nil
    }
}
