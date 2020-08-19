//
//  FakeLaunchScreenViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/19.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class FakeLaunchScreenViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.0,
            delay: 0.0,
            options: .allowUserInteraction,
            animations: { self.view.alpha = 0.0 },
            completion: { if $0 == .end {self.performSegue(withIdentifier: "MainView", sender: nil)} }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "MainView" {
            _ = segue.destination as! MainSceneViewController
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
