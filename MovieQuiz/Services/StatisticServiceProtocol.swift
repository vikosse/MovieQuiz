//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Alekhina Viktoriya on 28/12/2025.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
