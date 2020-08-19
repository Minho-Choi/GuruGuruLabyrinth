//
//  MazeModel.swift
//  GuruGuruLabyrinth
//
//  Created by Minho Choi on 2020/08/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation


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



class Maze {
    
    // path가 그려지지 않은 cell들(방문하지 않은 셀)
    var remainingCells = [Cell]()
    
    var passedCells = [Cell]()
    
    // path의 모음
    var map = [Cell]()
    
    // path를 바탕으로 계산한 실제 미로벽
    var maze = [Wall]()
    
    // 미로의 크기 (size * size)
    var size: Int
    
    // size, remainingCells, maze 초기화
    init(size: Int) {
        self.size = size
        
        for yindex in 0..<size {
            for xindex in 0..<size {
                remainingCells.append(Cell(position: Coordinate(x: xindex, y: yindex), mapSize: size))
            }
        }
        
        for yindex in 0...size {
            for xindex in 0..<size {
                maze.append(Wall(pos: (Float(xindex), Float(yindex) - 0.5), dir: .horizontal))
            }
        }
        for yindex in 0..<size {
            for xindex in 0...size {
                maze.append(Wall(pos: (Float(xindex) - 0.5, Float(yindex)), dir: .vertical))
            }
        }
    }
    
    
    // Implemented Wilson's Algorithm for maze generation
    // Reference: https://en.wikipedia.org/wiki/Maze_generation_algorithm
    
    func generateMaze() {
        // 양 끝 셀을 입구, 출구로 설정
        var startingCell = Cell(position: Coordinate(x: 0, y: 0), mapSize: size)
        let finishingCell = Cell(position: Coordinate(x: size - 1, y: size - 1), mapSize: size)
        // 출구를 map에 추가
        map.append(finishingCell)
        // remainingCells가 없어질 동안 path를 랜덤하게 새로 생성하여 map에 추가
        while true {
            let addedPath = generatePath(startingAt: startingCell)
            map += addedPath
            //mapDraw(path: map, size: size)
            if let randomCell = remainingCells.randomElement() {
                startingCell = randomCell
            } else {
                break
            }
        }
        // 완성된 map으로 maze 생성(벽 제거)
        for index in 0..<map.count-2 {
            let cellPos1 = map[index].position
            let cellPos2 = map[index + 1].position
            // path의 두 셀이 인접한 경우(하나의 path 안)
            if isAdjacent(rhs: map[index + 1], lhs: map[index]) {
                let wallPosition = (Float(cellPos1.x + cellPos2.x)/2, Float(cellPos1.y + cellPos2.y)/2)
                var wallAddress = 0
                if Int(wallPosition.0 * 2)%2 == 0 { // horizontal wall
                    wallAddress = Int((wallPosition.1 + 0.5) * Float(size) + wallPosition.0)
                } else {
                    wallAddress = Int(wallPosition.0 + 0.5 + wallPosition.1 * Float(size+1)) + size*(size+1)
                }
                maze[wallAddress].isOpened = true
            }
        }
    }
    
    private func generatePath(startingAt startingCell: Cell) -> [Cell] {
        
        var trialPath = [Cell]()
        trialPath.append(startingCell)
        
        while true {
        
            // 새로 만들 셀을 초기화
            var newCell = Cell(position: Coordinate(x: 0, y: 0), mapSize: size)
            // 패스의 마지막 셀을 시작점으로 설정
            let lastCell = trialPath[trialPath.count - 1]
            // 패스의 마지막 셀 근처의 available한 셀을 랜덤 선택
            if let newCellPosition = lastCell.availableCell.randomElement() {
                // 선택된 셀을 새로운 셀로 설정함
                newCell = Cell(position: newCellPosition, mapSize: size)
                // 새로 만든 셀 주위 셀과의 관계 설정

                // 이미 지나온 셀은 closedcell에서 제거
                newCell.availableCell = newCell.availableCell.filter({ $0 != lastCell.position })
            }
            // path에 새로운 셀을 추가
            trialPath.append(newCell)
            
            // path가 map의 일부분에 도달했을 경우(map에 추가)
            if map.contains(newCell) {
                trialPath.forEach { cell in
                    // 아직 방문하지 않은 셀을 필터
                    passedCells += remainingCells.filter({ $0 == cell })
                    print(passedCells.count)
                    remainingCells = remainingCells.filter( { $0 != cell })
                }
                return trialPath
            }
            
            // path에 loop 만들어진 경우
            for index in 0..<trialPath.count - 2 {
                if newCell.position == trialPath[trialPath.count - index - 2].position {
                    // loop의 시작점부터 끝까지 지움
                    trialPath = trialPath.dropLast(index + 1)
                    break
                }
            }
            // 현재 만들어진 path를 시각화해주는 함수
            //mapDraw(path: trialPath, size: size)
        }
            
    }
    // 입력받은 두 셀이 인접한 셀인가를 판단
    private func isAdjacent(rhs: Cell, lhs: Cell) -> Bool {
        if abs(rhs.position.x - lhs.position.x) == 1 {
            if rhs.position.y == lhs.position.y {
                return true
            }
        }
        if abs(rhs.position.y - lhs.position.y) == 1 {
            if rhs.position.x == lhs.position.x {
                return true
            }
        }
        return false
    }

    // path 시각화 함수, string 형태로 반환
    private func mapDraw(path: [Cell], size: Int) {
        var mazeString = ""
        var mazeRow = ""
        for _ in 0..<size {
            mazeRow.append("-")
        }
        mazeRow.append("\n")
        for _ in 0..<size {
            mazeString.append(mazeRow)
        }
        for index in path.indices {
            let xCoord = path[index].position.x
            let yCoord = path[index].position.y
            
            let replacingIndex =  mazeString.index(mazeString.startIndex, offsetBy: xCoord + yCoord * (size + 1))
            mazeString.remove(at: replacingIndex)
            mazeString.insert("#", at: replacingIndex)
        }
        print(mazeString)
    }
}


// 랜덤 숫자 리턴
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
