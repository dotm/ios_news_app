//
//  NewsDetail.swift
//  NewsApp
//
//  Created by Yoshua Elmaryono on 19/03/19.
//  Copyright © 2019 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class NewsDetail: UIView {

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
        self.backgroundColor = .gray
        loadNews()
        
        let previousNewsRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftPanEdge))
        previousNewsRecognizer.edges = .left
        previousNewsRecognizer.minimumNumberOfTouches = 1
        self.addGestureRecognizer(previousNewsRecognizer)
        
        let nextNewsRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightPanEdge))
        nextNewsRecognizer.edges = .right
        nextNewsRecognizer.minimumNumberOfTouches = 1
        self.addGestureRecognizer(nextNewsRecognizer)
    }
    final private func loadNews(){
        print(NewsDetailPointer.getCurrentNews()?.webURL)
    }
    
    final private var panTriggered = false
    @objc final private func handleLeftPanEdge(gesture: UIScreenEdgePanGestureRecognizer){
        singlePanEvent (gesture: gesture) {
            print(NewsDetailPointer.moveToPreviousNews()?.webURL)
        }
    }
    @objc final private func handleRightPanEdge(gesture: UIScreenEdgePanGestureRecognizer){
        singlePanEvent (gesture: gesture) {
            print(NewsDetailPointer.moveToNextNews()?.webURL)
        }
    }
    final private func singlePanEvent(gesture: UIScreenEdgePanGestureRecognizer, closure: ()->()){
        switch gesture.state {
        case .began, .changed:
            if !panTriggered {
                let threshold: CGFloat = 100  // you decide this
                let translation = abs(gesture.translation(in: self).x)
                if translation >= threshold  {
                    closure()
                    panTriggered = true
                }
            }
            
        case .ended, .failed, .cancelled:
            panTriggered = false
            
        default: break
        }
    }

}
