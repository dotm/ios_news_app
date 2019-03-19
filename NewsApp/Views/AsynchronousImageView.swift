//
//  AsynchronousImageView.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

final class AsynchronousImageView: UIImageView {
    private let defaultImage = UIImage(named:"default")!
    init(url: URL?){
        super.init(image: defaultImage)
        
        imageURL = url
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageURL: URL? {
        didSet {
            if let url = imageURL {
                loadImageAsnychronously(url: url)
            }else{
                image = defaultImage
            }
        }
    }
    private func loadImageAsnychronously(url: URL){
        DispatchQueue.global(qos: .background).async {
            do {
                let image = try UIImage(data: Data(contentsOf: url))
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
