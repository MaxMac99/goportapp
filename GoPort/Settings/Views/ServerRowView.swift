//
//  ServerRowView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

struct ServerRowView: View {
    var server: Server
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(server.name)
                    .font(.headline)
                Text(server.host.relativeString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.accentColor)
            }
        }
        .padding(.vertical, 5)
    }
}

#if DEBUG
struct ServerRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ServerRowView(server: Server.preview.first!)
            ServerRowView(server: Server.preview[2], isSelected: true)
        }
    }
}
#endif
