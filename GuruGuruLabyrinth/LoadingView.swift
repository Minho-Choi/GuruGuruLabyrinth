//
//  LoadingView.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var loadingBar = UIProgressView()
    var stautsLabel = UILabel()
    let attribute: [NSAttributedString.Key : Any] = [.font : UIFont(name: "Chalkduster", size: 22.0) as Any, .foregroundColor : UIColor.white]
    
    override func addSubview(_ view: UIView) {
        
        let labelwidth = view.frame.width - 100
        let barwidth = view.frame.width - 140
        
        loadingBar.progress = 0.0
        loadingBar.progressTintColor = .white
        stautsLabel.frame = CGRect(x: view.frame.midX - labelwidth / 2, y: view.frame.midY - 100, width: labelwidth, height: 40)
        stautsLabel.attributedText = NSAttributedString(string: "", attributes: attribute)
        stautsLabel.textAlignment = .center
        loadingBar.frame = CGRect(x: view.frame.midX - barwidth / 2, y: view.frame.midY - 30, width: barwidth, height: 40)
        view.addSubview(loadingBar)
        view.addSubview(stautsLabel)
    }
    
    func setLoadingStatus(description: String, percent: String) {
        if let floatPercent = Float(percent) {
            loadingBar.setProgress(floatPercent, animated: true)
        }
        stautsLabel.attributedText = NSAttributedString(string: description, attributes: attribute)
    }
    
    func remove() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.0,
            delay: 1.0,
            options: .curveLinear,
            animations: {
                self.stautsLabel.alpha = 0
                self.loadingBar.alpha = 0
        },
            completion: { if $0 == .end {
                    self.stautsLabel.removeFromSuperview()
                    self.loadingBar.removeFromSuperview()
                }
                
        })
    }

}
