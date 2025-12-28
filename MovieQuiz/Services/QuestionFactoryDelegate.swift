//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alekhina Viktoriya on 27/12/2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
