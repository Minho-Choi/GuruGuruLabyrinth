//
//  MainSceneViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class MainSceneViewController: UIViewController {

    @IBOutlet weak var pressLabel: UILabel!
    
    override func viewDidLoad() {
        let tapAnywhereRecoginzer = UITapGestureRecognizer()
        
        tapAnywhereRecoginzer.addTarget(self, action: #selector(whenTapped(recognizer:)))
        
        view.addGestureRecognizer(tapAnywhereRecoginzer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fadeIn()
    }
    
    @objc func whenTapped(recognizer:UITapGestureRecognizer) {
        performSegue(withIdentifier: "GameView", sender: 8)
    }
    
    func fadeOut() {
        UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 1.0,
        delay: 0.0,
        options: [.curveEaseInOut,.allowUserInteraction],
        animations: { self.pressLabel.alpha = 0.0 },
        completion: { if $0 == .end { self.fadeIn() }} )
    }
    
    func fadeIn() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.0,
            delay: 0.0,
            options: [.curveEaseInOut,.allowUserInteraction],
            animations: { self.pressLabel.alpha = 1.0 },
            completion: {if $0 == .end { self.fadeOut() }} )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "GameView" {
            let gameViewController = segue.destination as! GameViewController
            gameViewController.optionalmazeSize = sender as? Int
        }
    }
        
    
}
