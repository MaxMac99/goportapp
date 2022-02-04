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
    
    struct LoadFailureDetails {
        var title: String
        var details: String?
    }
    
    @State var isLoading = false
    @State var loadingError: LoadFailureDetails? = nil
    
    var body: some View {
        LoadingView(isLoading: isLoading) {
            NavigationView {
                List {
                    LoadableView(loadable: viewModel.imagesLoadable) { images in
                        ForEach(images, id: \.context) { entry in
                            Section {
                                ForEach(entry.response, id: \.id) { image in
                                    NavigationLink(destination: ImageDetailView(context: entry.context, summary: image)) {
                                        VStack(spacing: 4) {
                                            HStack {
                                                if let name = image.repoTags.first {
                                                    Text(name)
                                                } else {
                                                    Text(image.shortId)
                                                }
                                                Spacer()
                                                Text(byteCountFormatter.string(fromByteCount: image.size))
                                                    .foregroundColor(Color.gray)
                                                    .font(Font.callout)
                                            }
                                            HStack {
                                                Text(image.shortId)
                                                    .foregroundColor(Color.gray)
                                                    .font(Font.subheadline)
                                                Spacer()
                                                Text(relativeDateFormatter.localizedString(for: image.created, relativeTo: Date()))
                                                    .foregroundColor(Color.gray)
                                                    .font(Font.subheadline)
                                            }
                                        }
                                        .padding(.vertical, 6)
                                    }
                                }
                            } header: {
                                HStack {
                                    Text(entry.context.name)
                                    Spacer()
                                    Menu {
                                        Button {
                                            Task {
                                                do {
                                                    isLoading = true
                                                    try await entry.context.pruneImages()
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

extension ImageSummary {
    var shortId: String {
        Utilities.shortId(id: id)
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
