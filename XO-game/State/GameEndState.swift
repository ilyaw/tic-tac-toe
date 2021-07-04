//
//  GameEndState.swift
//  XO-game
//
//  Created by Ilya on 24.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameEndState: GameState {
    var isMoveCompleted: Bool = false
    
    public let winnerPlayer: Player?
    weak var gameViewController: GameViewController?
    
    init(winnerPlayer: Player?, gameViewController: GameViewController) {
        self.winnerPlayer = winnerPlayer
        self.gameViewController = gameViewController
    }
    
    func addSign(at position: GameboardPosition) {}
    
    func begin() {
        gameViewController?.winnerLabel.isHidden = false
        
        if let winnerPlayer = winnerPlayer {
            gameViewController?.winnerLabel.text = setPlayerName(player: winnerPlayer) + " won"
        } else {
            gameViewController?.winnerLabel.text = "No winner"
        }
        
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    private func setPlayerName(player: Player) -> String {
        
        
        let mode = gameViewController?.versusMode
        
        switch player {
        case .first:
            return "First"
        case .second:
            return mode == .humanVsHuman || mode == .fiveByFive ? "Second" : "Computer"
        }
    }
}
