//
//  ProjectListView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI

struct ProjectListView: View {
    @StateObject var viewModel: ProjectListViewModel
    
    init(viewModel: ProjectListViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: ProjectListViewModel())
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if let stored = viewModel.projectsLoadable.content?.stored {
                    ProjectSectionView(viewModel: viewModel, context: nil, projects: stored)
                }
                LoadableView(loadable: viewModel.projectsLoadable) { projects in
                    ForEach(projects.remote, id: \.context) { entry in
                        if !entry.response.isEmpty {
                            ProjectSectionView(viewModel: viewModel, context: entry.context, projects: entry.response)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.reload()
            }
            .navigationTitle("Compose")
        }
        .task {
            await viewModel.load()
        }
    }
}

#if DEBUG
struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(viewModel: .preview)
    }
}
#endif
