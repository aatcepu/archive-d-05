//
//  ContentView.swift
//  app_3
//
//  Created by Student on 07/08/26.
//

import SwiftUI
import iPhoneNumberField

struct ContentView: View {
    @State private var text: String = "   "
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            Image("Mask Group")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .padding(.bottom, 10)
            
            VStack {
                HStack {
                    Text("Get your groceries\nwith  nectar")
                        .foregroundStyle(Color(#colorLiteral(red: 0.01176470588, green: 0.01176470588, blue: 0.01176470588, alpha: 1)))
                        .font(.custom("Gilroy-Light", size: 26))
                        .fontWeight(.medium)
                    Spacer()
                }
                HStack {
                    Text("Mobile Number")
                        .padding(.top, 1)
                        
                    Spacer()
                }
                HStack(spacing: 8) {
                    iPhoneNumberField("", text: $text)
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
                Text("Or connect with Social Media")
                    .foregroundStyle(Color(#colorLiteral(red: 0.5815095305, green: 0.5815094709, blue: 0.5815094709, alpha: 1)))
                    .font(.caption)
                    .padding(.top,10)
                HStack{
                    Button(action: {
                        
                    }){
                        HStack(){
                            Image("icons8-google-48")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24,height:24)
                            Spacer()
                            Text("Continue with Google" )
                                .padding()
                                .font(.custom("Gilroy-Light", size: 16))
                                .fontWeight(.medium)
                                .foregroundStyle(Color(#colorLiteral(red: 0.9906775355, green: 0.9906774163, blue: 0.9906774163, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal,40)
                    }
                    .background(
                        Color(#colorLiteral(red: 0.3254901961, green: 0.5137254902, blue: 0.9254901961, alpha: 1)),
                        in: RoundedRectangle(cornerRadius: 19)
                    )
                    .padding(.top,20)
                }
                HStack{
                    Button(action: {
                        
                    }){
                        HStack(){
                            Image("communication")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24,height:24)
                            Spacer()
                            Text("Continue with Facebook" )
                                .padding()
                                .font(.custom("Gilroy-Light", size: 16))
                                .fontWeight(.medium)
                                .foregroundStyle(Color(#colorLiteral(red: 0.9906775355, green: 0.9906774163, blue: 0.9906774163, alpha: 1)))
                            Spacer()
                        }
                        .padding(.horizontal,40)
                    }
                    .background(
                        Color(#colorLiteral(red: 0.2901960784, green: 0.4, blue: 0.6745098039, alpha: 1)),
                        in: RoundedRectangle(cornerRadius: 19)
                    )
                    .padding(.top,10)
                }
                
            }
            .padding(.horizontal,20)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
