//
//  NewsList.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class NewsList: UIView {
    //MARK: Properties
    private let CELL_ID = "My news cell"
    
    //MARK: Outlets
    private weak var newsCollectionView: UICollectionView!

    //MARK: Initializers
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    //MARK: Layout
    final private func setupLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(setCollectionViewColumns), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        setupCollectionView()
    }
    final private func setupCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.newsCollectionView = collectionView
    }
    @objc final private func setCollectionViewColumns(){
        newsCollectionView.collectionViewLayout = getCollectionViewLayout()
    }
    final private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing = CGFloat(10)
        let margins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        var cellsPerRow = 1
        
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation.isPortrait {
            cellsPerRow = 1
        }else if deviceOrientation.isLandscape {
            cellsPerRow = 4
        }
        
        let layout = ColumnFlowLayout(cellsPerRow: cellsPerRow, minimumInteritemSpacing: spacing, minimumLineSpacing: spacing, sectionInset: margins)
        return layout
    }
}

extension NewsList: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! NewsCollectionViewCell
        
        cell.news = defaultNewsViewModel
        
        return cell
    }
}
extension NewsList: UICollectionViewDelegate {
    
}


final class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    var news: NewsViewModel = defaultNewsViewModel{
        didSet {
            newsTitleLabel.text = news.title
            newsImageView.image = news.image
        }
    }
    
    //MARK: Outlets
    private weak var newsTitleLabel: UILabel!
    private weak var newsImageView: UIImageView!
    private weak var newsDateLabel: UILabel!
    
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
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = CGFloat(2)
        
        setupNewsTitleLabel()
        setupNewsImageView(previousElement: newsTitleLabel)
        setupNewsDate(previousElement: newsImageView)
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
        let imageView = UIImageView()
        imageView.image = news.image
        
        let parent = self
        parent.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor).isActive = true
        
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
}
final class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
