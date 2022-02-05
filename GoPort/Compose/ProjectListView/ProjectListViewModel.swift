//
//  ProjectListViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import Foundation
import GoPortApi

@MainActor
class ProjectListViewModel: ObservableObject {
    @Published fileprivate(set) var projectsLoadable: Loadable<(stored: [ProjectSummary]?, remote: [(context: GoPortContext, response: [ProjectSummary])])> = .notStarted
    
    func load() async {
        guard case .notStarted = projectsLoadable, ServerService.shared.selectedServer != nil else {
            return
        }
        projectsLoadable = .loading
        await reload()
    }
    
    func reload() async {
        guard let server = ServerService.shared.selectedServer else {
            return
        }
        projectsLoadable = await Loadable({ try await server.projects(all: true) })
    }
}

#if DEBUG
extension ProjectListViewModel {
    static let preview: ProjectListViewModel = {
        let viewModel = ProjectListViewModel()
        let server = Server.preview.first!
        Task {
            viewModel.projectsLoadable = await Loadable({ try await server.projects() })
        }
        return viewModel
    }()
}
#endif
