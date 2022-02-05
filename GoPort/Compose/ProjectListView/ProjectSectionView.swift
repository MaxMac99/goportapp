//
//  ProjectSectionView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ProjectSectionView: View {
    @ObservedObject var viewModel: ProjectListViewModel
    var context: GoPortContext?
    var projects: [ProjectSummary]
    
    var body: some View {
        Section(context?.name ?? "Stored") {
            ForEach(projects, id: \.id) { project in
                ProjectRowView(project: project)
            }
        }
    }
}

#if DEBUG
struct ProjectSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProjectSectionView(viewModel: .preview, context: GoPortContext.preview.first!, projects: ProjectSummary.previews)
            }
        }
    }
}
#endif
