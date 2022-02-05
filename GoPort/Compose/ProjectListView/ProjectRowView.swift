//
//  ProjectRowView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ProjectRowView: View {
    var project: ProjectSummary
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
            if let status = project.status {
                Text(status)
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG
struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProjectRowView(project: ProjectSummary.previews.first!)
            }
        }
    }
}
#endif
