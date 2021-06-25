//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private var counter: Int = 0
    private(set) var versusMode: Versus = .humanVsComputer //
    
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
        
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.currentState.addSign(at: position)
        
            if self.currentState.isMoveCompleted {
         
                self.nextPlayerTurn()
            }
//            self.gameboardView.placeMarkView(XView(), at: position)
        }
    }
    
    func firstPlayerTurn() {
        let firstPlayer: Player = .first
        
        switch versusMode {
        case .humanVsHuman:
            currentState = PlayerGameState(player: firstPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: firstPlayer.markViewPrototype)
        case .humanVsComputer:
            currentState = ComputerGameState(player: firstPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: firstPlayer.markViewPrototype)
        }
    }
    
    func nextPlayerTurn() {
        self.counter += 1
        
        if let winner = referee.determineWinner() {
            Logger.shared.log(action: .gameFinish(winner: winner))
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinish(winner: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
        }
        
        if let playerState = currentState as? PlayerGameState {
            let nextPlayer = playerState.player.next
            currentState = PlayerGameState(player: nextPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: nextPlayer.markViewPrototype)
        }
        
        if let playerState = currentState as? ComputerGameState {
            let nextPlayer = playerState.player.next
            currentState = ComputerGameState(player: nextPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: nextPlayer.markViewPrototype)
            if nextPlayer == .second {
                nextPlayerTurn()
            }
        }
        
     
      
    }
    
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.log(action: .restartGame)
        
        restartGame()
    }
    
    private func restartGame() {
        gameboardView.clear()
        gameBoard.clear()
        counter = 0
        
        firstPlayerTurn()
    }
    
    @IBAction func openSettingsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ToOpenSettings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToOpenSettings" {
            if let destionation = segue.destination as? SettingsViewController {
                destionation.delegate = self
            }
        }
    }
    
    
}

extension GameViewController: SettingsDelegate {
    func data(versusMode: Versus) {
        self.versusMode = versusMode
        self.restartGame()
    }
}
