//
//  LogInvoker.swift
//  XO-game
//
//  Created by Ilya on 24.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class LogInvoker {
    public static let shared = LogInvoker()
    
    private let receiver = LogReceiver()
    private let bufferSize = 100
    private var commands: [LogCommand] = []
    
    private init() {}
    
    func addLogCommand(command: LogCommand) {
        commands.append(command)
        execute()
    }
    
    private func execute() {
        guard !commands.isEmpty, commands.count >= bufferSize else { return }
        
        commands.forEach { receiver.sendMessage(message: $0.logMessage) }
        commands = []
    }
}
