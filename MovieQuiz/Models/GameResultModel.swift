//
//  GameResultModel.swift
//  MovieQuiz
//
//  Created by Alekhina Viktoriya on 28/12/2025.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
