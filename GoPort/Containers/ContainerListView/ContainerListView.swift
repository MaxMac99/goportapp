//
//  ContainerListView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI

struct ContainerListView: View {
    @StateObject var viewModel: ContainerListViewModel
    
    init(viewModel: ContainerListViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: ContainerListViewModel())
        }
    }
    
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
                .refreshable {
                    await viewModel.reload()
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
        .task {
            await viewModel.load()
        }
    }
}

#if DEBUG
struct ContainerListView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerListView(viewModel: .preview)
    }
}
#endif
