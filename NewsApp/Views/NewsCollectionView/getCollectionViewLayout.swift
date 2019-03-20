//
//  getCollectionViewLayout.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 20/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

func getCollectionViewLayout() -> UICollectionViewFlowLayout {
    let spacing = CGFloat(20)
    let margins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    let cellsPerRow: Int
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let deviceOrientation_isLandscape = screenWidth > screenHeight
    if deviceOrientation_isLandscape {
        cellsPerRow = 4
    }else{
        cellsPerRow = 1
    }
    
    let layout = ColumnFlowLayout(cellsPerRow: cellsPerRow, minimumInteritemSpacing: spacing, minimumLineSpacing: spacing, sectionInset: margins)
    return layout
}
