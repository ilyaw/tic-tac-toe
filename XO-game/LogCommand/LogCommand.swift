//
//  LogCommand.swift
//  XO-game
//
//  Created by Ilya on 24.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class LogCommand {
    let action: LogAction
    
    init(action: LogAction) {
        self.action = action
    }
    
    var logMessage: String {
        switch action {
        case .playerSetSign(let player, let position):
            return "\(player) поставил знак на позиции \(position)"
        case .gameFinish(let winner):
            if let winner = winner {
                return "\(winner) выиграл игру"
            } else {
                return "Нет победителя"
            }
        case .restartGame:
            return "Игра перезапустилась"
        }
    }
}
