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
    private(set) var versusMode: Versus = .humanVsHuman
    
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var invoker = FiveByFiveInvoker()
        
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
                self.versusMode == .fiveByFive ? self.fiveByFiveState() : self.nextPlayerTurn()
            }
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
        case .fiveByFive:
            currentState = FiveByFiveState(player: firstPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: firstPlayer.markViewPrototype,
                                           invoker: invoker)
        }
    }
    
    func nextPlayerTurn() {
        self.counter += 1
        
        let win = referee.determineWinner()
        
        if win != nil || counter >= 9 {
            currentState = GameEndState(winnerPlayer: win, gameViewController: self)
            return
        }
    
        switch versusMode {
        case .humanVsHuman:
            playGameState()
        case .humanVsComputer:
            computerGameState()
        case .fiveByFive:
            break
        }
    }
    
    
    private func fiveByFiveState() {
        
        let nextPlayer = counter < 4 ? Player.first : Player.second
        
        if counter == 4 {
            allGameBoardClear()
        }
        
        currentState = FiveByFiveState(player: nextPlayer, gameViewController: self,
                                       gameBoard: gameBoard, gameBoardView: gameboardView,
                                       markViewPrototype: nextPlayer.markViewPrototype,
                                       invoker: invoker)
        self.counter += 1
        
        if counter >= 10 {
            
            allGameBoardClear()
            
            self.view.isUserInteractionEnabled = false
            
            let dispatchGroup = DispatchGroup()
            DispatchQueue.global().async(group: dispatchGroup) {
                self.invoker.work()
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                let winner = self.referee.determineWinner()
                self.currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    private func playGameState() {
        if let playerState = currentState as? PlayerGameState {
            let nextPlayer = playerState.player.next
            currentState = PlayerGameState(player: nextPlayer, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: nextPlayer.markViewPrototype)
        }
    }
    
    private func computerGameState() {
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
        restartGame()
    }
    
    private func restartGame() {
        allGameBoardClear()
        counter = 0
        
        firstPlayerTurn()
    }
    
    private func allGameBoardClear() {
        gameboardView.clear()
        gameBoard.clear()
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
