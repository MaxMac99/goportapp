//
//  ContainerListView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI

struct ContainerListView: View {
    @StateObject var viewModel = ContainerListViewModel.preview
    
    @State var isLoading = false
    @State var loadingError: LoadFailureDetails? = nil
    
    var body: some View {
        LoadingView(isLoading: isLoading) {
            NavigationView {
                List {
                    LoadableView(loadable: viewModel.containersLoadable) { containers in
                        ForEach(containers, id: \.context) { entry in
                            ContainerSectionView(viewModel: viewModel, context: entry.context, containers: entry.response, isLoading: $isLoading, loadingError: $loadingError)
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
                .navigationTitle("Containers")
            }
        }
    }
}

struct ContainerListView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerListView(viewModel: .preview)
    }
}
