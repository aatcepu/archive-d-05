//
//  FunctionView.swift
//  grocery store
//
//  Created by Student on 22/07/26.
//

import SwiftUI

struct FunctionView: View {
    var body: some View {
        VStack{
            Image("banana")
                .frame(width: 150, height: 100)
                .padding()
            Text("organic bananas")
                .fontWeight(.semibold)
                .font(.system(size:25))
            Text("7pcs, price")
                .foregroundStyle(.gray)
                .padding(.trailing, 90)
            
            HStack{
                Text("$1.99")
                    .font(.system(size:25))
                    .padding(.trailing, 100)
                Text("+")
                   .foregroundStyle(.red)
                   .font(.system(size: 25))
                   .padding(.leading,-20)
                   .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .background(.green)
                   )
                
            }
        }
        .frame(width: 190, height: 250)
//        .background(.gray.opacity(0.1))
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
//        .border(Color.gray,width: 2 )
////        .cornerRadius(20)
    }
}

#Preview {
    FunctionView()
}
