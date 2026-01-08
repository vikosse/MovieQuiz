//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Alekhina Viktoriya on 25/12/2025.
//

import Foundation
import UIKit

enum QuestionFactoryError: LocalizedError {
    case failedToLoadPoster
    
    var errorDescription: String? {
        "Не удалось загрузить постер"
    }
}

final class QuestionFactory : QuestionFactoryProtocol {
    
    // MARK: Private properties
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    /*
     private let questions: [QuizQuestion] = [
     QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true
     ),
     QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false
     ),
     QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false
     ),
     QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false
     ),
     QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false
     )
     ]
     */
    
    // MARK: Private functions
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard !self.movies.isEmpty else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: QuestionFactoryError.failedToLoadPoster)
                }
                return
            }
            
            let maxAttempts = 5
            
            for _ in 0..<maxAttempts {
                let index = (0..<self.movies.count).randomElement() ?? 0
                guard let movie = self.movies[safe: index] else { continue }
                
                let url = movie.resizedImageURL
                print("Poster URL:", url.absoluteString)
                
                guard let imageData = try? Data(contentsOf: url),
                      UIImage(data: imageData) != nil
                else {
                    continue
                }
                
                let rating = Float(movie.rating) ?? 0
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                
                let question = QuizQuestion(
                    imageData: imageData,
                    text: text,
                    correctAnswer: correctAnswer
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: question)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFailToLoadData(with: QuestionFactoryError.failedToLoadPoster)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
