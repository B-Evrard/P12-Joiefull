//
//  RatingView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 24/02/2025.
//

import SwiftUI

struct RatingView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Binding var clotheNote: ClotheNote
    let starNotationWidth: CGFloat
    let starNotationHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(1..<5 + 1, id: \.self) { number in
                Button {
                    clotheNote.rating = number
                } label: {
                    
                    if (number > clotheNote.rating) {
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: starNotationWidth * dynamicTypeSize.scaleFactor, height: starNotationHeight * dynamicTypeSize.scaleFactor)
                            .foregroundStyle(Color.gray)
                        
                    }
                    else {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: starNotationWidth * dynamicTypeSize.scaleFactor, height: starNotationHeight * dynamicTypeSize.scaleFactor)
                            .foregroundStyle(Color.yellow)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

