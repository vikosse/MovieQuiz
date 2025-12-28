//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alekhina Viktoriya on 28/12/2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Properties
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect)
            let total = storage.integer(forKey: Keys.bestGameTotal)
            if let date = storage.object(forKey: Keys.bestGameDate) as? Date {
                return GameResult(correct: correct, total: total, date: date)
            } else {
                return GameResult(correct: 0, total: 0, date: Date())
            }
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect)
            storage.set(newValue.date, forKey:Keys.bestGameDate)
            storage.set(newValue.total, forKey: Keys.bestGameTotal)
        }
    }
    
    var totalAccuracy: Double {
        totalQuestionsAsked == 0 ? 0 : Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100
    }
    
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked)
        }
    }
    
    // MARK: - Functions
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
        
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
    }
}
