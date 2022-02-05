//
//  ImagesRowView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ImagesRowView: View {
    var context: GoPortContext
    var image: ImageSummary
    
    var body: some View {
        NavigationLink(destination: ImageDetailView(context: context, summary: image)) {
            VStack(spacing: 4) {
                HStack {
                    if let name = image.repoTags.first {
                        Text(name)
                    } else {
                        Text(Utilities.shortId(id: image.id))
                    }
                    Spacer()
                    Text(byteCountFormatter.string(fromByteCount: image.size))
                        .foregroundColor(Color.gray)
                        .font(Font.callout)
                }
                HStack {
                    Text(Utilities.shortId(id: image.id))
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
}

struct ImagesRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ImagesRowView(context: .preview.first!, image: .previews.first!)
            }
        }
    }
}
