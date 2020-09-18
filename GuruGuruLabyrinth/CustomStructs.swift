//
//  CustomStructs.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/09/01.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation
import UIKit

struct Level {
    
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

struct Ball {
    var name: String
    var diffuse: String?
    var metallic: String?
    var normal: String?
    var roughness: String?
    var occlusion: String?
    var displacement: String?
    var emissive: String?
    var mask: String?
    var alpha: String?
    
    var mass: CGFloat
    var friction: CGFloat
    var damping: CGFloat
    var angularDamping: CGFloat
}

struct WallTexture {
    var name: String
    var diffuse: String?
    var metallic: String?
    var normal: String?
    var roughness: String?
    var occlusion: String?
    var displacement: String?
    var emissive: String?
    var mask: String?
    var alpha: String?
}

// Cell 위치 구조체
struct Coordinate: Equatable {
    var x: Int
    var y: Int
}


// Cell 구조체
struct Cell: Equatable {
    // 두 셀의 위치가 같으면 같은 셀로 정의함(덮어쓰기 가능하도록)
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        if lhs.position == rhs.position {
            return true
        } else {
            return false
        }
    }
    // 셀의 위치에 따라 Wall을 좌표 array 형태로 생성
    init(position: Coordinate, mapSize: Int) {
        self.position = position
        self.mapSize = mapSize
        
        if position.x >= 0 && position.x < mapSize - 1{
            self.availableCell.append(Coordinate(x: position.x + 1, y: position.y))
        }
        if position.x <= mapSize && position.x > 0 {
            self.availableCell.append(Coordinate(x: position.x - 1, y: position.y))
        }
        if position.y >= 0 && position.y < mapSize - 1{
            self.availableCell.append(Coordinate(x: position.x, y: position.y + 1))
        }
        if position.y <= mapSize && position.y > 0 {
            self.availableCell.append(Coordinate(x: position.x, y: position.y - 1))
        }
    }
    
    var mapSize: Int
    
    var position: Coordinate
    var availableCell:  [Coordinate] = []
}


// 벽 구조체
struct Wall {
    
    init(pos: (Float, Float), dir: direction) {
        self.position = pos
        self.direction = dir
    }
    
    var position: (Float, Float)
    var isOpened = false
    var direction: direction
}


// 벽 방향 enum
enum direction {
    case horizontal
    case vertical
}


