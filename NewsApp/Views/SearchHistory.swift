//
//  SearchHistory.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class SearchHistory: UITableView {
    private let history: [String] = ["Election", "Test 2"]
    
    init(delegate: UITableViewDelegate){
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
        self.delegate = delegate
        tableFooterView = UIView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SearchHistory: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Search History Cell")
        let index = indexPath.row
        cell.textLabel?.text = history[index]
        return cell
    }
}

