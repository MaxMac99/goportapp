//
//  ImagesListView.swift
//  GoPort
//
//  Created by Max Vissing on 01.02.22.
//

import SwiftUI
import GoPortApi

struct ImagesListView: View {
    @StateObject var viewModel = ImagesListViewModel()
    
    @State var isLoading = false
    @State var loadingError: LoadFailureDetails? = nil
    
    var body: some View {
        LoadingView(isLoading: isLoading) {
            NavigationView {
                List {
                    LoadableView(loadable: viewModel.imagesLoadable) { images in
                        ForEach(images, id: \.context) { entry in
                            ImagesSectionView(viewModel: viewModel, context: entry.context, images: entry.response, isLoading: $isLoading, loadingError: $loadingError)
                        }
                    }
                }
                .alert(loadingError?.title ?? "", isPresented: Binding(get: { loadingError != nil }, set: { _ in loadingError = nil }), presenting: loadingError) { detail in
                    Button("OK", role: .cancel) {}
                } message: { detail in
                    if let details = detail.details {
                        Text(details)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Picker("Order", selection: $viewModel.order) {
                                ForEach(ImagesListViewModel.Order.allCases, id: \.self) { value in
                                    Text("Sorted \(value.rawValue)")
                                        .tag(value)
                                }
                            }
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .navigationTitle("Images")
            }
            .task {
                await viewModel.load()
            }
        }
    }
}

#if DEBUG
struct ImagesListView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesListView(viewModel: ImagesListViewModel.preview)
            .environmentObject(ServerService.preview)
    }
}
#endif
