//
//  ContentView.swift
//  Groceries App
//
//  Created by Student on 26/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack{
            Color.red.opacity(0.9)
                .ignoresSafeArea()
            
            VStack{
                Image(.zomato)
                    .resizable()
                    .scaledToFit()
                    .frame(width:250)
                    .padding(6)
                
                
            }
               
        }
        
    }
    
}

#Preview{
 ContentView()
    }
    
    
