//
//  PictureView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 26/02/2025.
//

import SwiftUI
struct PictureView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @Binding var clotheDisplay: ClotheDisplay
    let displayParam : DisplayParam.Type
    
    @State private var isShowingFullScreen = false
    
    var body: some View {
        ZStack {
            
            AsyncImageView(
                url: clotheDisplay.clothe.picture.url,
                dynamicTypeSize: dynamicTypeSize,
                displayParam: displayParam,
                isShowingFullScreen: $isShowingFullScreen
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(clotheDisplay.accessibilityPicture)
            .accessibilityHint(displayParam.isDetail ? "Toucher 2 fois pour agrandir l'image" : "Toucher 2 fois rapidement pour afficher le détail")
            .overlay(
                NotationView(
                    clotheDisplay: $clotheDisplay,
                    displayParam: displayParam
                ),
                alignment: .bottomTrailing
            )
            
        }
        .sheet(isPresented: $isShowingFullScreen) {
            FullScreenImageView(imageURL: clotheDisplay.clothe.picture.url, description: clotheDisplay.accessibilityDescription)
        }
        
        
    }
    
    struct AsyncImageView: View {
        let url: String
        let dynamicTypeSize: DynamicTypeSize
        let displayParam: DisplayParam.Type
        @Binding  var isShowingFullScreen: Bool
        
        
        var body: some View {
            AsyncImage(url: URL(string: url))  { image in
                image
                    .resizable()
                    .scaledToFill()
                    .accessibilityScaledFrame(
                        dynamicTypeSize: dynamicTypeSize,
                        width: displayParam.pictureWidth,
                        height: displayParam.pictureHeight
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .clipped()
                    .tappable(displayParam.isDetail) {
                        isShowingFullScreen = true
                    }
                
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            
            
        }
    }
    
    struct FullScreenImageView: View {
        
        @State private var scale: CGFloat = 1.0
        @State private var lastScale: CGFloat = 1.0
        @State private var offset: CGSize = .zero
        @State private var lastOffset: CGSize = .zero
        
        let imageURL: String
        let description: String
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastOffset = offset
                                    }
                            )
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let newScale = lastScale * value
                                        scale = min(max(newScale, 1), 5)
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    }
                            )
                            .onTapGesture(count: 2) {
                                withAnimation {
                                    scale = 1.0
                                    lastScale = 1.0
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                        
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(description)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    let category: ClotheCategory = .bottoms
    let clothe = Clothe(
        id: 10,
        picture: Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
        name: "Jean pour femme",
        category: category,
        likes: 10,
        price: 10.50,
        original_price: 15
    )
    let clotheDisplay = clothe.toDisplayModel(clotheNote: nil)
    PictureView(clotheDisplay: .constant(clotheDisplay), displayParam: DisplayParamFactory.clotheRowParam)
    
}

