//
//  onBoarding.swift
//  App
//
//  Created by Student on 03/08/26.
//

import SwiftUI

struct onBoarding: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Image("onbording")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Image("Group")
                    Text("Welcome\n to our Store")
                        .font(.custom("Gilroy-ExtraBold", size: 50))
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                    Text("Get your groceries in as fast as one hour")
                        .fontWeight(.medium)
                        .font(.custom("Gilroy-Light",size:15))
                        .foregroundStyle(Color(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)))
                        .padding(.top,-30)
//                    Button(action: SignIN(){
//                        print("Tapped")
//                    })
                    NavigationLink(destination: ContentView()){
                        Text("Get Started")
                            .padding(.horizontal,120)
                            .padding(.vertical,20)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color(#colorLiteral(red: 0.3848803043, green: 0.7366343737, blue: 0.5329580903, alpha: 1))))
                            .foregroundStyle(Color(#colorLiteral(red: 1, green: 0.9823095202, blue: 1, alpha: 1)))
                            .font(.custom("Gilroy-Light", size: 20))
                            .fontWeight(.medium)
                            .padding(.top,10)
                    }
                    
                }
                .padding(.top, 370)
            }
            
        }
    }
}

#Preview {
    onBoarding()
}
