//
//  ContentView.swift
//  ASton matrin
//
//  Created by Student on 04/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Form {
                Section {
                    Text("Hello, world!")
                    Text("")
                }

                Section {
                    Text("Hello, world!")
                    Text("Hello, world!")
                }
            }
        }
        NavigationStack {
                Form {
                    Section {
                        Text("Hello, world!")
                    }
                    NavigationStack {
                        Form {
                            Section {
                                Text("Hello, world!")
                            }
                        }
                        .navigationTitle("SwiftUI")
                    }
                }
            }
        }
    }


#Preview {
    ContentView()
}

