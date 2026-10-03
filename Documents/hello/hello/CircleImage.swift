//
//  CircleImage.swift
//  hello
//
//  Created by Student on 25/07/26.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(.circle)
            .overlay{
                Circle().stroke(.gray,lineWidth:4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage()
}
