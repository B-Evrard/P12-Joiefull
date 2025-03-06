//
//  CatalogView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 26/02/2025.
//

import SwiftUI

struct CatalogView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    @ObservedObject var viewModel: ClothesListViewModel
    
    @State private var selectedClothe: Clothe?
    @State private var isShowingDetail = false
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            HStack(spacing: 0) {
                NavigationStack {
                    createCatalog()
                }
                .frame(width: selectedClothe != nil ? calculWidth(730): nil)
                .frame(maxWidth: selectedClothe == nil ? .infinity : nil)
                
                if let clothe = selectedClothe {
                    
                        NavigationStack {
                            ZStack (alignment: .topLeading) {
                                ClotheDetailView(viewModel: ClotheDetailViewModel(clothe: clothe), param: DisplayParamFactory.clotheDetailParam)
                                Button(action: {
                                        withAnimation {
                                            selectedClothe = nil
                                        }
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Circle().fill(Color.white.opacity(0.5)))
                                            .shadow(radius: 3)
                                    }
                                    .padding(10)
                            }
                            
                        }
                    
                    
                }
            }
            
        } else {
            NavigationStack {
                createCatalog()
                    .navigationDestination(isPresented: $isShowingDetail) {
                        if let clothe = selectedClothe {
                            ClotheDetailView(viewModel: ClotheDetailViewModel(clothe: clothe), param: DisplayParamFactory.clotheDetailParam)
                        }
                    }
                
                
            }
        }
    }
    
    @ViewBuilder
    func createCatalog() -> some View {
        List {
             ForEach(viewModel.clothesByCategory.keys.sorted(), id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.localized)
                        .font(Font.system(size: UIFontMetrics.default.scaledValue(for: 22), weight: .semibold))
                        .dynamicTypeSize(.xSmall ... .accessibility3)
                        .foregroundColor(.black)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Catégories de vetements \(category.localized)" )
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: DisplayParamFactory.clotheRowParam.rowHeight.scaledFont()))], spacing: 15) {
                            ForEach(viewModel.clothesByCategory[category] ?? [], id: \.id) { clothe in
                                ClotheRowView(clothe: clothe, param: DisplayParamFactory.clotheRowParam)
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        selectedClothe = clothe
                                        isShowingDetail = true
                                    }
                                }
                        }
                        
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchClothes()
            }
        }
        .onOpenURL { incomingURL in
                    print("App was opened via URL: \(incomingURL)")
                handleDeepLink(url: incomingURL)
                }

        .background(Color.white)
        .listStyle(PlainListStyle())
    }
    
    private func handleDeepLink(url: URL) {
        guard url.scheme == "joiefull",
              url.host == "clothe",
              let idString = url.pathComponents.last,
              let id = Int(idString) else { return }

        if let clothe = viewModel.clothesByCategory.values.flatMap({ $0 }).first(where: { $0.id == id }) {
            selectedClothe = clothe
            isShowingDetail = true
        }
    }
    
    private func calculWidth(_ catalogWidth: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let detailWidth = screenWidth - CGFloat(720)
        let diff = detailWidth.scaledFont() - detailWidth
        return catalogWidth - diff
    }
}

#Preview {
    let viewModel = ClothesListViewModel(apiService: APIClient())
    CatalogView(viewModel: viewModel)
}
