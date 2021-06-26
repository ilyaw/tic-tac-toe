//
//  FiveByFiveCommand.swift
//  XO-game
//
//  Created by Ilya on 25.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FiveByFiveCommand {
    
    private var player: Player
    private var position: GameboardPosition
    private var gameBoard: Gameboard
    private var gameBoardView: GameboardView

    init(player: Player, position: GameboardPosition,
         gameBoard: Gameboard, gameBoardView: GameboardView) {
        self.player = player
        self.position = position
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
    }
    
    func execute() {
        DispatchQueue.main.async {
            let signView = self.player == .first ? XView() : OView()
            
            self.gameBoardView.removeMarkView(at: self.position)
         
            self.gameBoard.setPlayer(self.player, at: self.position)
            self.gameBoardView.placeMarkView(signView, at: self.position)
        }
    }
}
