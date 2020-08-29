//
//  SelectLevelViewController.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/29.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class SelectLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    let level1 = LevelData(size: 4, levelName: "Easy", fogDistance: 0, skyBrightness: "Day")
    let level2 = LevelData(size: 8, levelName: "Normal", fogDistance: 20, skyBrightness: "Sunset")
    let level3 = LevelData(size: 12, levelName: "Hard", fogDistance: 15, skyBrightness: "Gray")
    let level4 = LevelData(size: 16, levelName: "Extreme", fogDistance: 10, skyBrightness: "Night")
    let level5 = LevelData(size: 20, levelName: "Impossible", fogDistance: 5, skyBrightness: "Space")
    
    lazy var levelArray: [LevelData] = [level1, level2, level3, level4, level5]

    @IBOutlet weak var LevelSelection: UICollectionView! {
        didSet {
            LevelSelection.dataSource = self
            LevelSelection.delegate = self
        }
    }
    
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
        performSegue(withIdentifier: "GameView", sender: levelArray[indexPath.item] )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameView" {
            let gameViewController = segue.destination as! GameViewController
            gameViewController.gameData = sender as? LevelData
        }
    }
}

struct LevelData {
    
    var mazeSize: Int
    var levelName: String
    
    var fogDistance: CGFloat
    var skyType: String
    
    init(size: Int, levelName: String, fogDistance: Int, skyBrightness: String) {
        self.mazeSize = size
        self.levelName = levelName
        self.fogDistance = CGFloat(fogDistance)
        self.skyType = skyBrightness
    }
}
