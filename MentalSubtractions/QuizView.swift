//
//  QuizView.swift
//  MentalSubtractions
//
//  Created by Chaher Machhour on 06/11/2024.
//

import SwiftUI

struct QuizView: View {
    @State var viewModel = ViewModel()
    @State private var feedbackMessage = ""
    @State private var feedbackColor: Color = .clear
    @State private var showFeedback = false
    @State private var timeElapsed: TimeInterval = 99
    @State private var isRunning = false
    @State private var showResultScreen = false
    @State private var isPreparing = true
    @State private var isRotating = false
    let optionCount = UIScreen.main.bounds.width > 375 ? 6 : 5

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), center: .center, startRadius: 0, endRadius: 500)
                .ignoresSafeArea()

            VStack {
                if !showResultScreen {
                    if isPreparing {
                        Image("MentalSubtractions")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 65))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation {
                                        self.isPreparing = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.startTimer()
                                    }
                                }
                            }
                    } else {
                        HStack() {
                            Image("MentalSubtractions")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                                .rotationEffect(.degrees(isRotating ? 360 : 0))
                            Spacer()
                            Text("\(Int(timeElapsed))")
                                .foregroundStyle(LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                ))
                        }
                        .font(.system(size: 65))
                        .bold()
                        .padding(.vertical, 16)

                        Spacer()

                        if let question = viewModel.getCurrentQuestion() {
                            Text("\(question.firstTerm) - \(question.secondTerm)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .bold()
                                .padding(.vertical, 20)
                        }
                        Spacer()
                        VStack {
                            Text(" ")
                            ForEach(viewModel.getCurrentQuestion()?.options ?? [], id: \.self) { option in
                                Button(action: {
                                    handleAnswerSelection(option)
                                }) {
                                    Text("\(option)")
                                        .padding()
                                        .frame(maxWidth: .infinity, minHeight: 70)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 1.5, y: 5)
                                }
                            }
                            
                            if showFeedback {
                                Text(feedbackMessage)
                                    .foregroundColor(feedbackColor)
                                    .font(.title)
                                    .bold()
                            }
                        }
                        .frame(height: optionCount == 5 ? 330 : 400)
                        Spacer()
                        Spacer()
                        Spacer()
                        HStack {
                            Text(" ")
                            Spacer()
                            Text(" ")
                            Spacer()
                            Text(" ")
                        }
                        .font(.system(size: 2))
                        .bold()
                    }
                } else {
                    ResultView(score: viewModel.score, onRestart: {
                        resetGame()
                    })
                }
            }
            .padding()
            .onDisappear(perform: stopTimer)
        }
    }

    private func startTimer() {
        guard !isPreparing else { return }
        
        isRunning = true
        timeElapsed = 99
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard self.isRunning else {
                timer.invalidate()
                return
            }
            if self.timeElapsed > 1 {
                self.timeElapsed -= 1
            } else {
                self.showResultScreen = true
                self.isRunning = false
            }
        }
    }

    private func stopTimer() {
        isRunning = false
    }

    private func handleAnswerSelection(_ answer: Int) {
        // Réinitialise l'animation de feedback si elle est déjà affichée
        if showFeedback {
            feedbackMessage = ""
            showFeedback = false
        }
        
        let isCorrect = viewModel.submitAnswer(answer)
        feedbackMessage = isCorrect ? "+1" : "-1"
        feedbackColor = isCorrect ? .green : Color.red.opacity(0.8)
        
        showFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if showFeedback {
                withAnimation(.easeInOut(duration: 1)) {
                    showFeedback = false
                }
            }
        }
    }

    private func resetGame() {
        viewModel.reset()
        showResultScreen = false
        isPreparing = true
        timeElapsed = 99
        stopTimer()
    }
}
