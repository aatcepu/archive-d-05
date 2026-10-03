//
//  ContentView.swift
//  dice_roller
//
//  Created by Student on 04/07/26.
//
import SwiftUI

struct ContentView: View {
    
    @State private var diceNumber = 1
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Dice Roller")
                .font(.largeTitle)
                .bold()
            
            Image(systemName: "die.face.\(diceNumber)")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
            
            Button(action: rollDice) {
                Text("Roll Dice 🎲")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func rollDice() {
        diceNumber = Int.random(in: 1...6)
    }
}

#Preview {
    ContentView()
}
