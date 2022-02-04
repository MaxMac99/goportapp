//
//  ImagesListViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 01.02.22.
//

import Foundation
import GoPortApi

@MainActor
class ImagesListViewModel: ObservableObject {
    enum Order: String, Equatable, CaseIterable {
        case byDate = "by Date"
        case bySize = "by Size"
    }
    
    @Published var imagesLoadable = Loadable<[(context: GoPortContext, response: [ImageSummary])]>.notStarted
    @Published var order = Order.byDate {
        didSet {
            guard let content = imagesLoadable.content else { return }
            imagesLoadable = Loadable(content
                                        .map({ context, response in
                (context, response.sorted(by: { self.sortImageSummary(left: $0, right: $1) }))
            }))
        }
    }
    
    func load() async {
        guard let server = ServerService.shared.selectedServer else {
            return
        }
        imagesLoadable = await Loadable({ try await server.images(all: true)
                .map({ context, response in
                    (context, response.sorted(by: { self.sortImageSummary(left: $0, right: $1) }))
                })
        })
    }
    
    func sortImageSummary(left: ImageSummary, right: ImageSummary) -> Bool {
        switch order {
        case .byDate:
            return left.created > right.created
        case .bySize:
            return left.size > right.size
        }
    }
}

#if DEBUG
extension ImagesListViewModel {
    static let preview: ImagesListViewModel = {
        let viewModel = ImagesListViewModel()
        let server = Server.preview.first!
        Task {
            viewModel.imagesLoadable = await Loadable({ try await server.images() })
        }
        return viewModel
    }()
}
#endif
