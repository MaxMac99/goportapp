//
//  LoadableView.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import SwiftUI
import GoPortApi

struct LoadableView<Element, ErrorView: View, ContentView: View, LoadingView: View>: View {
    var loadable: Loadable<Element>
    var contentView: (Element) -> ContentView
    var errorView: (Error) -> ErrorView
    var loadingView: () -> LoadingView
    
    var body: some View {
        switch loadable {
        case .notStarted:
            EmptyView()
        case .loading:
            ProgressView()
        case .error(let error):
            errorView(error)
        case .loaded(let content):
            contentView(content)
        }
    }
    
    init(loadable: Loadable<Element>, _ contentView: @escaping (Element) -> ContentView, errorView: @escaping (Error) -> ErrorView, loadingView: @escaping () -> LoadingView) {
        self.loadable = loadable
        self.contentView = contentView
        self.errorView = errorView
        self.loadingView = loadingView
    }
}

extension LoadableView where ErrorView == EmptyView {
    init(loadable: Loadable<Element>, _ contentView: @escaping (Element) -> ContentView, loadingView: @escaping () -> LoadingView) {
        self.loadable = loadable
        self.contentView = contentView
        self.errorView = { _ in EmptyView() }
        self.loadingView = loadingView
    }
}

extension LoadableView where LoadingView == EmptyView {
    init(loadable: Loadable<Element>, _ contentView: @escaping (Element) -> ContentView, errorView: @escaping (Error) -> ErrorView) {
        self.loadable = loadable
        self.contentView = contentView
        self.errorView = errorView
        self.loadingView = { EmptyView() }
    }
}

extension LoadableView where ErrorView == EmptyView, LoadingView == EmptyView {
    init(loadable: Loadable<Element>, _ contentView: @escaping (Element) -> ContentView) {
        self.loadable = loadable
        self.contentView = contentView
        self.errorView = { _ in EmptyView() }
        self.loadingView = { EmptyView() }
    }
}

#if DEBUG
struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoadableView(loadable: .loaded("Test")) { item in
                Text(item)
            } errorView: { error in
                Text("Received: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
            LoadableView(loadable: Loadable<String>.loading) { item in
                Text(item)
            } errorView: { error in
                Text("Received: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
            LoadableView(loadable: Loadable<String>.error(APIResponseError.unknown(nil))) { item in
                Text(item)
            } errorView: { error in
                Text("\(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
}
#endif
