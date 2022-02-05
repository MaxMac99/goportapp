//
//  ContainerSectionView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ContainerSectionView: View {
    @ObservedObject var viewModel: ContainerListViewModel
    var context: GoPortContext
    var containers: [ContainerSummaryResponseItem]
    
    @Binding var isLoading: Bool
    @Binding var loadingError: LoadFailureDetails?
    
    var body: some View {
        Section {
            ForEach(containers, id: \.id) { container in
                ContainerRowView(container: container)
            }
        } header: {
            HStack {
                Text(context.name)
                Spacer()
                Menu {
                    Button {
                        Task {
                            do {
                                isLoading = true
                                try await context.pruneContainers()
                                await viewModel.load()
                                isLoading = false
                            } catch {
                                isLoading = false
                                loadingError = LoadFailureDetails(title: "Prune Failed", details: error.localizedDescription)
                            }
                        }
                    } label: {
                        Label("Prune", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .textCase(nil)
            }
        }
    }
}

#if DEBUG
struct ContainerListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ContainerSectionView(viewModel: .preview, context: GoPortContext.preview.first!, containers: ContainerSummaryResponseItem.previews, isLoading: .constant(false), loadingError: .constant(nil))
            }
        }
    }
}
#endif
