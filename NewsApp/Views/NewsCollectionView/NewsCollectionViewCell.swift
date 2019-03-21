//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var news: NewsViewModel = NewsViewModel(model: defaultNewsModel){
        didSet {
            newsTitleLabel.text = news.title
            newsDateLabel.text = news.date
            newsSnippet.text = news.snippet
            
            //always set .key before the .imageURL for correct caching behavior
            newsImageView.key = news._id
            newsImageView.imageURL = news.imageURL
        }
    }
    
    //MARK: Outlets
    private weak var newsTitleLabel: UILabel!
    private weak var newsImageView: AsynchronousImageView!
    private weak var newsDateLabel: UILabel!
    private weak var newsSnippet: UITextView!
    
    //MARK: Lifecycle Hook
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK: Setup Layout
    private func setupLayout(){
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
        setupNewsTitleLabel()
        setupNewsImageView(previousElement: newsTitleLabel)
        setupNewsDate(previousElement: newsImageView)
        setupNewsSnippet(previousElement: newsDateLabel)
    }
    private func setupNewsTitleLabel(){
        let label = UILabel()
        label.text = news.title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        let parent = self
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
        self.newsTitleLabel = label
    }
    private func setupNewsImageView(previousElement: UIView){
        let imageView = AsynchronousImageView(url: news.imageURL)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let parent = self
        parent.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor, multiplier: 0.5).isActive = true
        
        self.newsImageView = imageView
    }
    private func setupNewsDate(previousElement: UIView){
        let label = UILabel()
        label.text = news.date
        
        let parent = self
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        label.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
        self.newsDateLabel = label
    }
    private func setupNewsSnippet(previousElement: UIView){
        let snippet = UITextView()
        snippet.isEditable = false
        snippet.isScrollEnabled = false
        snippet.isSelectable = false
        snippet.isUserInteractionEnabled = false
        
        snippet.text = news.snippet
        snippet.font = UIFont.systemFont(ofSize: 20)
        
        let parent = self
        parent.addSubview(snippet)
        snippet.translatesAutoresizingMaskIntoConstraints = false
        snippet.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        snippet.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        snippet.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        snippet.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor).isActive = true
        
        self.newsSnippet = snippet
    }
}
