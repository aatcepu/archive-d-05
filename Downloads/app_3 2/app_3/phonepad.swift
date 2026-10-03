//
//  phonepad.swift
//  app_3
//
//  Created by general on 31/08/26.
//

import SwiftUI
import iPhoneNumberField

struct phonepad: View {
    @State private var text: String = "   "
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(){
            NavigationStack{
                HStack{
                    Text("Enter your mobile number")
                        .padding(.top,60)
                        .font(.custom("Gilroy-Light", size: 26))
                        .fontWeight(.semibold)
                    Spacer()
                    
                }
                HStack{
                    Text("Mobile number")
                        .padding(.top)
                        .font(.custom("Gilroy-Light", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(#colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1)))
                    Spacer()
                }
                    HStack(spacing: 8) {
                        iPhoneNumberField("Contact Number", text: $text)
                            .flagHidden(false)
                            .flagSelectable(true)
                            .font(UIFont(size: 20, weight: .bold))
                            .padding(.bottom, 2)
                            .keyboardType(.phonePad)
                            .focused($isFocused)
                            .overlay(alignment:.leading){
                                HStack{
                                    Color.clear.frame(width: 24)
                                    Image(systemName: "chevron.down")
                                        .offset(x: -4)
                                        .opacity(0.8)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.blue)
                                }
                                .allowsHitTesting(false)
                            }
                    }
                    Divider()
                        .background(isFocused ? Color.blue : Color.gray)
                    Spacer()
                
                Spacer()
            }
                
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    phonepad()
}
