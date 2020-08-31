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
    
    var minimumClearTime: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let tapAnywhereRecoginzer = UITapGestureRecognizer()
        
        tapAnywhereRecoginzer.addTarget(self, action: #selector(whenTapped(recognizer:)))
        
        view.addGestureRecognizer(tapAnywhereRecoginzer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fadeIn()
    }
    
    @objc func whenTapped(recognizer:UITapGestureRecognizer) {
        performSegue(withIdentifier: "SelectView", sender: nil)
    }
    
    func fadeOut() {
        UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 1.0,
        delay: 0.5,
        options: [.allowUserInteraction],
        animations: { self.pressLabel.alpha = 0.0 },
        completion: { if $0 == .end { self.fadeIn() }} )
    }
    
    func fadeIn() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.0,
            delay: 0.0,
            options: [.allowUserInteraction],
            animations: { self.pressLabel.alpha = 1.0 },
            completion: {if $0 == .end { self.fadeOut() }} )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "SelectView" {
            let _ = segue.destination as! SelectLevelViewController
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
