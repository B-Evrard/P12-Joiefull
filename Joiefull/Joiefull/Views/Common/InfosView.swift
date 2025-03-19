
//
//  infosView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 24/02/2025.
//

import SwiftUI
struct InfosView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var contentHeight: CGFloat = 0
    let clotheDisplay: ClotheDisplay
    let displayParam : DisplayParam.Type
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(clotheDisplay.clothe.name)
                    .font(displayParam.infosFont)
                Spacer()
                etoile(taille: displayParam.heartWidth)
                //Text(clotheDisplay.clothe.rate.formattedRate())
                Text("\(contentHeight)")
                    .font(displayParam.infosFont)
            }
            
            
            HStack {
                Text(clotheDisplay.clothe.price.formattedPrice())
                    .font(displayParam.infosFont)
                Spacer()
                Text(clotheDisplay.clothe.original_price.formattedPrice())
                    .font(displayParam.infosFont)
                    .strikethrough(true)
            }
        }
        .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
        } action: {size in
            etoile(taille: 10)
            self.contentHeight = size.height
        }
        .padding(.horizontal,5)
        .accessibilityHidden(true)
    }
}

#Preview {
    
let category: ClotheCategory = .bottoms
let clotheNote = ClotheNote(id: 1, rating: 0, comment: "", favorite: false)
let clothe = Clothe(
    id: 1,
        picture: Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"), name: "Jean pour femme",
        category: category,
        likes: 100,
        price: 44.99,
        original_price: 59.99
    )
    InfosView(clotheDisplay: clothe.toDisplayModel(clotheNote: nil), displayParam: DisplayParamFactory.clotheDetailParam)
}
    
@ViewBuilder
func etoile(taille: CGFloat) -> some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: taille, height: taille)
            .foregroundColor(Color("OrangeJoieFull"))
    
}
