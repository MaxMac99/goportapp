//
//  LoadableView.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import SwiftUI
import GoPortApi

struct LoadableView<Element, ErrorView: View, ContentView: View>: View {
    var loadable: Loadable<Element>
    var errorView: (Error) -> ErrorView
    var contentView: (Element) -> ContentView
    
    var body: some View {
        switch loadable {
        case .loading:
            ProgressView()
        case .error(let error):
            errorView(error)
        case .loaded(let content):
            contentView(content)
        }
    }
}

#if DEBUG
struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadableView(loadable: .loaded("Test")) { error in
                Text("Received: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } contentView: { item in
                Text(item)
            }
            LoadableView(loadable: Loadable<String>.loading) { error in
                Text("Received: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } contentView: { item in
                Text(item)
            }
            LoadableView(loadable: Loadable<String>.error(APIResponseError.unknown(nil))) { error in
                Text("\(error.localizedDescription)")
                    .foregroundColor(.red)
            } contentView: { item in
                Text(item)
            }
        }
    }
}
#endif
