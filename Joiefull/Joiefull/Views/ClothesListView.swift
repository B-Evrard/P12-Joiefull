//
//  ClotheListView.swift
//  Joiefull
//
//  Created by Bruno Evrard on 13/02/2025.
//

import SwiftUI

struct ClothesListView: View {
    
    @ObservedObject var viewModel: ClothesListViewModel
    @State private var selectedClothe: Clothe? = nil
    @State private var isShowingDetail = false
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            HStack(spacing: 0) {
                    // Partie catalogue qui s'adapte
                    NavigationStack {
                        createCatalog()
                    }
                    .frame(width: selectedClothe != nil ? 734 : nil)
                    .frame(maxWidth: selectedClothe == nil ? .infinity : nil)
                    
                    // Partie détail
                    if let clothe = selectedClothe {
                        Divider()
                        
                        NavigationStack {
                            ClotheDetailView(clothe: clothe)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            
//            NavigationSplitView {
//                createCatalog()
//                    .navigationSplitViewColumnWidth(734)
//                
//            } detail: {
//                Group {
//                    if let clothe = selectedClothe {
//                        ClotheDetailView(clothe: clothe)
//                    } else {
//                        Text("Sélectionnez un vêtement")
//                            .font(.title)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//            }
        } else {
            NavigationStack {
                createCatalog()
                    .navigationDestination(isPresented: $isShowingDetail) {
                        if let clothe = selectedClothe {
                            ClotheDetailView(clothe: clothe)
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
                        .font(.custom("OpenSans-SemiBold",  size: 22))
                        .foregroundColor(.black)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.clothesByCategory[category] ?? [], id: \.id) { clothe in
                                createClotheRowView(for: clothe)
                                    .onTapGesture {
                                        selectedClothe = clothe
                                        isShowingDetail = true
                                    }
                            }
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .background(Color.white)
        .listStyle(PlainListStyle())
        .onAppear {
            Task {
                await viewModel.fetchClothes()
            }
        }
    }
    
    @ViewBuilder
    func createClotheRowView(for clothe: Clothe) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            ClotheRowIpadView(clothe: clothe)
        } else {
            ClotheRowPhoneView(clothe: clothe)
        }
    }
    
}





#Preview {
    let viewModel = ClothesListViewModel(apiService: APIClient())
    ClothesListView(viewModel: viewModel)
}
