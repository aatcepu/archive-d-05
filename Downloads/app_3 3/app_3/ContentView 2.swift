//
//  ContentView.swift
//  App
//
//  Created by Student on 03/08/26.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        VStack {
            Image("Group 1")
                .resizable()
                .frame(width: 267,height: 68)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView2()
}
