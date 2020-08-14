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
    var openedCell:  [Coordinate] = []
    var availableCell:  [Coordinate] = []
}

class Maze {
    
    // path가 그려지지 않은 cell들(방문하지 않은 셀)
    var remainingCells = [Cell]()
    
    // path의 모음
    var map = [Cell]()
    
    // path를 바탕으로 계산한 실제 미로
    var maze = [Cell]()
    
    // 미로의 크기 (size * size)
    var size: Int
    
    // size, remainingCells, maze 초기화
    init(size: Int) {
        self.size = size
        
        for yindex in 0..<size {
            for xindex in 0..<size {
                remainingCells.append(Cell(position: Coordinate(x: xindex, y: yindex), mapSize: size))
                maze.append(Cell(position: Coordinate(x: xindex, y: yindex), mapSize: size))
            }
        }
        print("remaining cells: \(remainingCells.count)")
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
            mapDraw(path: map, size: size)
            if let randomCell = remainingCells.randomElement() {
                startingCell = randomCell
            } else {
                break
            }
        }
        // 완성된 map으로 maze 생성(벽 제거)
        for index in 0..<map.count-2 {
            if isAdjacent(rhs: map[index + 1], lhs: map[index]) {
                let rightCellIndex = map[index].position.x + map[index].position.y * size
                let leftCellIndex = map[index + 1].position.x + map[index + 1].position.y * size
                (maze[rightCellIndex], maze[leftCellIndex]) = openWall(lastCell: map[index], newCell: map[index + 1])
                print("Wall breaked between \(map[index].position) and \(map[index + 1].position)")
            }
        }
    }
    
    func generatePath(startingAt startingCell: Cell) -> [Cell] {
        
        var trialPath = [Cell]()
        trialPath.append(startingCell)
        
        while true {
        
            // 새로 만들 셀을 초기화
            var newCell = Cell(position: Coordinate(x: 0, y: 0), mapSize: size)
            // 패스의 마지막 셀을 시작점으로 설정
            var lastCell = trialPath[trialPath.count - 1]
            // 패스의 마지막 셀 근처의 available한 셀을 랜덤 선택
            if let newCellPosition = lastCell.availableCell.randomElement() {
                // 선택된 셀을 새로운 셀로 설정함
                newCell = Cell(position: newCellPosition, mapSize: size)
                // 새로 만든 셀 주위 셀과의 관계 설정
                // 새로만든 셀 - 이전 셀 사이 통로 연결
                newCell.openedCell = newCell.availableCell.filter({ $0 == lastCell.position })
                //lastCell.openedCell = lastCell.availableCell.filter({ $0 == newCell.position })
                // 이미 지나온 셀은 closedcell에서 제거
                newCell.availableCell = newCell.availableCell.filter({ $0 != lastCell.position })
                //lastCell.availableCell = lastCell.availableCell.filter({$0 != newCell.position })
            }
            // path에 새로운 셀을 추가 및 이전 셀 수정
            trialPath[trialPath.count-1] = lastCell
            trialPath.append(newCell)
            
            // path가 map의 일부분에 도달했을 경우(map에 추가)
            if map.contains(newCell) {
                trialPath.forEach { cell in
                    // 아직 방문하지 않은 셀을 필터
                    remainingCells = remainingCells.filter( { $0 != cell })
                }
                print("remaining cells: \(remainingCells.count)")
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
            mapDraw(path: trialPath, size: size)
        }
            
    }
    // 입력받은 두 셀이 인접한 셀인가를 판단
    func isAdjacent(rhs: Cell, lhs: Cell) -> Bool {
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
        print("Not Adjacent Cells")
        return false
    }
    // 입력받은 두 셀간의 Wall open 상태를 처리하여 리턴
    func openWall(lastCell: Cell, newCell: Cell) -> (Cell1: Cell, Cell2: Cell) {
        
        var cell1 = lastCell
        var cell2 = newCell
        //cell1.openedCell = lastCell.availableCell.filter({ $0 == newCell.position })
        cell1.availableCell = lastCell.availableCell.filter({ $0 != newCell.position })
        //cell2.openedCell = newCell.openedCell.filter({ $0 == lastCell.position })
        cell2.availableCell = newCell.availableCell.filter({ $0 != lastCell.position })
        
        return (cell1, cell2)
    }
    // path 시각화 함수, string 형태로 반환
    func mapDraw(path: [Cell], size: Int) {
        var mazeString = ""
        var mazeRow = ""
        for _ in 0..<size {
            mazeRow.append(" ")
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
    
    func mazeDraw() {
        
    }

    
}


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
