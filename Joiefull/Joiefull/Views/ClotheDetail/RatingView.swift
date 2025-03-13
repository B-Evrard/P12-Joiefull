//
//  RatingView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 24/02/2025.
//

import SwiftUI

struct RatingView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Binding var rating: Int
    let starNotationWidth: CGFloat
    let starNotationHeight: CGFloat

    var body: some View {
        HStack(spacing: 20) {
            ForEach(1..<5 + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    
                    if (number > rating) {
                        Image(systemName: "star")
                            .resizable()
                            .accessibilityScaledFrame(dynamicTypeSize: dynamicTypeSize, width: starNotationWidth, height: starNotationHeight)
                            .foregroundStyle(Color.gray)
                            
                    }
                    else {
                        Image(systemName: "star.fill")
                            .resizable()
                            .accessibilityScaledFrame(dynamicTypeSize: dynamicTypeSize, width: starNotationWidth, height: starNotationHeight)
                            .foregroundStyle(Color.yellow)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    

}

