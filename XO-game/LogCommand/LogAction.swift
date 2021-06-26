//
//  LogAction.swift
//  XO-game
//
//  Created by Ilya on 24.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum LogAction {
    case playerSetSign(player: Player, position: GameboardPosition)
    case gameFinish(winner: Player?)
    case restartGame
}
