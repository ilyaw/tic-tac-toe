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
    private var factory: StateFactory?
    
    private var invoker = FiveByFiveInvoker()
        
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
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
        factory = StateFactory(gameViewController: self, gameBoard: gameBoard,
                               gameBoardView: gameboardView, invoker: invoker,
                               versusMode: versusMode)
                
        currentState = factory?.create(currentState: currentState)
    }
    
    func nextPlayerTurn() {
        self.counter += 1
        
        let winner = referee.determineWinner()
        
        if winner != nil || counter >= 9 {
            currentState = factory?.gameOverCreate(winner: winner)
            return
        }
        
        versusMode == .humanVsHuman ? playGameState() : computerGameState()
    }
    
    
    private func fiveByFiveState() {
        
        if counter == 4 {
            allGameBoardClear()
        }
        
        currentState = factory?.create(currentState: currentState)
        
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
                self.currentState = self.factory?.gameOverCreate(winner: winner)
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    private func playGameState() {
        currentState = factory?.create(currentState: currentState)
    }
    
    private func computerGameState() {
        if let playerState = currentState as? ComputerGameState {
            let nextPlayer = playerState.player.next
            
            currentState = factory?.create(currentState: currentState)
            
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
                destionation.versusMode = versusMode
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
