//
//  ImagesSectionView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ImagesSectionView: View {
    @ObservedObject var viewModel: ImagesListViewModel
    var context: GoPortContext
    var images: [ImageSummary]
    
    @Binding var isLoading: Bool
    @Binding var loadingError: LoadFailureDetails?
    
    var body: some View {
        Section {
            ForEach(images, id: \.id) { image in
                ImagesRowView(context: context, image: image)
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
                                try await context.pruneImages()
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

struct ImagesSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ImagesSectionView(viewModel: .preview, context: .preview.first!, images: ImageSummary.previews, isLoading: .constant(false), loadingError: .constant(nil))
            }
        }
    }
}
