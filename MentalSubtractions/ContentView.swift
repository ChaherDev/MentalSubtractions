//
//  ContentView.swift
//  MentalSubtractions
//
//  Created by Chaher Machhour on 01/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        QuizView(viewModel: ViewModel())
    }
}

#Preview {
    ContentView()
}
