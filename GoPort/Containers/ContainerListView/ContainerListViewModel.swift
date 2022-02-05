//
//  ContainerListViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import Foundation
import GoPortApi

@MainActor
class ContainerListViewModel: ObservableObject {
    @Published fileprivate(set) var containersLoadable: Loadable<[(context: GoPortContext, response: [ContainerSummaryResponseItem])]> = .notStarted
    
    func load() async {
        guard let server = ServerService.shared.selectedServer else {
            return
        }
        containersLoadable = await Loadable({ try await server.containers(all: true) })
    }
}

#if DEBUG
extension ContainerListViewModel {
    static let preview: ContainerListViewModel = {
        let viewModel = ContainerListViewModel()
        let server = Server.preview.first!
        Task {
            viewModel.containersLoadable = await Loadable({ try await server.containers() })
        }
        return viewModel
    }()
}
#endif
