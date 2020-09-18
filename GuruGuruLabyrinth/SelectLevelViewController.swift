//
//  SelectLevelViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/29.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class SelectLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var levelArray: [Level] = DataSet().levelArray

    @IBOutlet weak var LevelSelection: UICollectionView! {
        didSet {
            LevelSelection.dataSource = self
            LevelSelection.delegate = self
        }
    }
    
    @IBAction func unwindGameVC(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newlevelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath)
        if let level = newlevelCell as? LevelSelectCollectionViewCell {
            level.levelData = levelArray[indexPath.item]
        }
        return newlevelCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 256, height: 256)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BallView", sender: levelArray[indexPath.item] )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BallView" {
            let ballViewController = segue.destination as! BallSelectViewController
            ballViewController.levelData = sender as? Level
        }
    }
}
