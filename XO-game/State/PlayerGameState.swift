//
//  PlayerGameState.swift
//  XO-game
//
//  Created by Ilya on 24.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerGameState: GameState {
    var isMoveCompleted: Bool = false
    
    public let player: Player
    weak var gameViewController: GameViewController?
    weak var gameBoard: Gameboard?
    weak var gameBoardView: GameboardView?
    
    init(player: Player, gameViewController: GameViewController,
         gameBoard: Gameboard, gameBoardView: GameboardView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
    }
    
    
    func addSign(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView, gameBoardView.canPlaceMarkView(at: position) else { return }
        
        let markView: MarkView
        
        switch player {
        case .first:
            markView = XView()
        case .second:
            markView = OView()
        }
        
        gameBoard?.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markView, at: position)
        isMoveCompleted = true //ход завершен
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    
}
