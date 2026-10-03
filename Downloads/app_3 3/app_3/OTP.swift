//
//  OTP.swift
//  app_3
//
//  Created by Student on 10/09/26.
//

import SwiftUI

struct OTP: View {
    var body: some View {
        VStack(){
            HStack(){
                Text("Enter your 4-digit code")
                    .font(.custom("Gilroy-Light",size: 26))
                    .fontWeight(.semibold)
                    .padding(.top,70)
                Spacer()
            }
            HStack{
                Text("Code")
                    .font(.custom("Gilroy-Light",size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle( Color(#colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 0.8470588235)))
                Spacer()
                    .padding(.top,10)
            }
            
            
        }
        .padding(.horizontal,20)
        Spacer()
            .ignoresSafeArea()
    }
}

#Preview {
    OTP()
}
