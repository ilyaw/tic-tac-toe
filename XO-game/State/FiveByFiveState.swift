//
//  FiveByFiveState.swift
//  XO-game
//
//  Created by Ilya on 25.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FiveByFiveState: GameState {
    var isMoveCompleted: Bool = false
    
    public let player: Player
    var gameViewController: GameViewController?
    var gameBoard: Gameboard
    var gameBoardView: GameboardView
    var invoker: FiveByFiveInvoker
    
    let markViewPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController,
         gameBoard: Gameboard, gameBoardView: GameboardView,
         markViewPrototype: MarkView, invoker: FiveByFiveInvoker) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markViewPrototype = markViewPrototype
        self.invoker = invoker
    }
    
    
    func addSign(at position: GameboardPosition) {
        guard gameBoardView.canPlaceMarkView(at: position) else { return }
        
        invoker.addCommand(command: FiveByFiveCommand(player: player,
                                                       position: position,
                                                       gameBoard: gameBoard,
                                                       gameBoardView: gameBoardView))
        
        gameBoard.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)
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
