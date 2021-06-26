//
//  FiveByFiveInvoker.swift
//  XO-game
//
//  Created by Ilya on 25.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FiveByFiveInvoker {
    
    private var commands: [FiveByFiveCommand] = []
    private let macroSec: Int32 = 1000000 / 2
    
    func addCommand(command: FiveByFiveCommand) {
        if commands.count >= 10 {
            commands = []
        }
        
        commands.append(command)
        
    }
    
    func work() {
        commands.forEach { command in
            command.execute()
            
            usleep(useconds_t(macroSec))
        }
    }
}
