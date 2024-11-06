//
//  ViewModel.swift
//  MentalSubtractions
//
//  Created by Chaher Machhour on 06/11/2024.
//

import SwiftUI
import Observation

@Observable
class ViewModel {
    var score = 0
    var currentQuestionIndex = 0
    var questions: [Questions]
    var isGameFinished: Bool = false
    let optionCount = UIScreen.main.bounds.width > 375 ? 6 : 5

    init() {
        self.questions = ViewModel.generateQuestions()
    }
    
    func submitAnswer(_ answer: Int) -> Bool {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == answer
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }
        currentQuestionIndex += 1

        // Vérifier si toutes les questions ont été répondues
        if currentQuestionIndex >= questions.count {
            isGameFinished = true
        }
        return isCorrect
    }
    
    func reset() {
        score = 0
        currentQuestionIndex = 0
        questions = ViewModel.generateQuestions()
        isGameFinished = false
    }

    func getCurrentQuestion() -> Questions? {
        // Empêche l'accès en dehors des limites de questions
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    static func generateQuestions() -> [Questions] {
        var questions = [Questions]()
        for _ in 1...500 {  // Limite le nombre de questions à générer pour éviter les ralentissements
            let firstTerm = Int.random(in: 0...999999)
            let secondTerm = Int.random(in: 0...999999)
            questions.append(Questions(firstTerm: firstTerm, secondTerm: secondTerm))
        }
        return questions.shuffled()
    }
}
