//
//  SavedNewsViewController.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class SavedNewsViewController: UIViewController {
    //MARK: Outlets
    private weak var newsList: SavedNewsList!
    
    //MARK: Lifecycle Hooks
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newsList.newsList = SavedNewsStorage.getNewsList()
    }
    
    //MARK: Layout
    final private func setupLayout(){
        self.view.backgroundColor = .white
        navigationItem.title = "Saved News"
        
        setupNewsList()
    }
    final private func setupNewsList(){
        let newsList = SavedNewsList()
        view.addSubview(newsList)
        
        newsList.translatesAutoresizingMaskIntoConstraints = false
        newsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.newsList = newsList
    }
    
}
