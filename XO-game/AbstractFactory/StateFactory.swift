//
//  StateFactory.swift
//  XO-game
//
//  Created by Ilya on 03.07.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class StateFactory {
    
    private var gameViewController: GameViewController
    private var gameBoard: Gameboard
    private var gameBoardView: GameboardView
    private var invoker: FiveByFiveInvoker
    private var versusMode: Versus
    
    init(gameViewController: GameViewController,
         gameBoard: Gameboard, gameBoardView: GameboardView,
         invoker: FiveByFiveInvoker, versusMode: Versus) {
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.invoker = invoker
        self.versusMode = versusMode
    }
    
    func create(currentState: GameState?) -> GameState {
        switch versusMode {
        case .humanVsHuman:
            return playerGameCreate(currentState: currentState)
        case .humanVsComputer:
            return computerGameCreate(currentState: currentState)
        case .fiveByFive:
            return fiveByFiveGameCreate(currentState: currentState)
        }
    }
    
    func gameOverCreate(winner: Player?) -> GameState {
        return GameEndState(winnerPlayer: winner, gameViewController: gameViewController)
    }
    
    private func playerGameCreate(currentState: GameState?) -> GameState  {
        var player: Player = .first
        
        if let playerState = currentState as? PlayerGameState {
            player = playerState.player.next
        }
        
        return PlayerGameState(player: player, gameViewController: gameViewController,
                               gameBoard: gameBoard, gameBoardView: gameBoardView,
                               markViewPrototype: player.markViewPrototype)
    }
    
    private func computerGameCreate(currentState: GameState?) -> GameState {
        var player: Player = .first
        
        if let playerState = currentState as? ComputerGameState {
            player = playerState.player.next
        }
        
        return ComputerGameState(player: player, gameViewController: gameViewController,
                                 gameBoard: gameBoard, gameBoardView: gameBoardView,
                                 markViewPrototype: player.markViewPrototype)
    }
    
    private var counter = -1
    private func fiveByFiveGameCreate(currentState: GameState?) -> GameState {
        let nextPlayer = counter < 4 ? Player.first : Player.second
        self.counter += 1
        
        return FiveByFiveState(player: nextPlayer, gameViewController: gameViewController,
                               gameBoard: gameBoard, gameBoardView: gameBoardView,
                               markViewPrototype: nextPlayer.markViewPrototype,
                               invoker: invoker)
    }
    
}
