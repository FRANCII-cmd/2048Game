//
//  main.swift
//  2048-Game
//
//  Created by Michael Francis on 2021-06-10.
//

import Foundation

extension String {
    func pad(length: Int) -> String {
        let paddingLength = length - self.count
        let padding = [String](repeating: " ", count: paddingLength).joined()
        return self + padding
    }
}

func printBoard(board: [[Int]]) {
    var boardTemplate = """
    +----+----+----+----+
    |A|B|C|D|
    +----+----+----+----+
    |E|F|G|H|
    +----+----+----+----+
    |I|J|K|L|
    +----+----+----+----+
    |M|N|O|P|
    +----+----+----+----+
    """
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"]
    var i = 0
    for j in board {
        for k in j {
            boardTemplate = boardTemplate.replacingOccurrences(of: letters[i], with: "\(k)".pad(length: 4))
            i += 1
        }
    }
    print(boardTemplate)
}

func swipeLeft(board: [[Int]]) -> [[Int]] {
    func swipeLeftRow(row: [Int]) -> [Int] {
        var newRow = row
        for value in 0..<newRow.count - 1 {
            if newRow[value] == 0 {
                continue
            }
            if newRow[value] == newRow[value + 1] {
                newRow[value] *= 2
                newRow[value + 1] = 0
            }
        }
        newRow = newRow.filter { $0 != 0 }
        newRow.append(contentsOf: repeatElement(0, count: 4 - newRow.count))
        return newRow
    }
    var newBoard = board
    for row in 0..<board.count {
        newBoard[row] = swipeLeftRow(row: board[row])
    }
    return newBoard
}

func swipeRight(board: [[Int]]) -> [[Int]] {
    swipeLeft(board: board.map { $0.reversed() }).map { $0.reversed() }
}

func transpose(board: [[Int]]) -> [[Int]] {
    var newBoard = [[Int]](repeating: [0, 0, 0, 0], count: 4)
    for row in 0..<board.count {
        for value in 0..<board[row].count {
            newBoard[row][value] = board[value][row]
        }
    }
    return newBoard
}

func swipeUp(board: [[Int]]) -> [[Int]] {
    transpose(board: swipeLeft(board: transpose(board: board)))
}

func swipeDown(board: [[Int]]) -> [[Int]] {
    transpose(board: swipeRight(board: transpose(board: board)))
}

func placeTile(board: [[Int]]) -> [[Int]]? {
    var zeros: [(Int, Int)] = []
    for row in 0..<board.count {
        for col in 0..<board[row].count {
            if board[row][col] == 0 {
                zeros.append((row, col))
            }
        }
    }
    guard let index = zeros.randomElement() else { return nil }
    let newTile = [2, 2, 2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
    var newBoard = board
    newBoard[index.0][index.1] = newTile
    return newBoard
}

func canMove(board: [[Int]]) -> Bool {
    board != swipeRight(board: board) || board != swipeLeft(board: board) || board != swipeUp(board: board) || board != swipeDown(board: board)
}

var board = [[Int]](repeating: [Int](repeating: 0, count: 4), count: 4)
board = placeTile(board: placeTile(board: board)!)!
while true {
    printBoard(board: board)
    //let direction = ["left", "right", "up", "down"].randomElement()!
    let direction = readLine()!
    let originalBoard = board
    switch direction {
    case "left":
        board = swipeLeft(board: board)
    case "right":
        board = swipeRight(board: board)
    case "up":
        board = swipeUp(board: board)
    case "down":
        board = swipeDown(board: board)
    default:
        print("Invalid direction")
        continue
    }
    if board != originalBoard  {
        board = placeTile(board: board)!
    } else {
        if placeTile(board: board) == nil && !canMove(board: board) {
            print("You Lose!")
            break
        }
    }
}
