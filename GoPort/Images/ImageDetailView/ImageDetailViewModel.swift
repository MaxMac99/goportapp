//
//  ImageDetailViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 03.02.22.
//

import Foundation
import GoPortApi

@MainActor
class ImageDetailViewModel: ObservableObject {
    fileprivate var imageContext: GoPortImage? = nil
    @Published fileprivate(set) var image: Loadable<ImageResponse> = .notStarted
    @Published fileprivate(set) var history: Loadable<HistoryResponse> = .notStarted
    
    func setup(context: GoPortContext, summary: ImageSummary) {
        guard imageContext == nil else {
            return
        }
        var id = summary.id
        if id.starts(with: "sha"), var index = id.firstIndex(of: ":") {
            index = id.index(index, offsetBy: 1)
            id = String(id[index..<id.endIndex])
        }
        imageContext = GoPortImage(id: id, context: context)
    }
    
    func load() async {
        guard let _ = imageContext else {
            return
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadInspect() }
            group.addTask { await self.loadHistory() }
            
            await group.waitForAll()
        }
    }
    
    func loadInspect() async {
        guard let imageContext = imageContext else {
            return
        }
        image = await Loadable({ try await imageContext.inspect() })
    }
    
    func loadHistory() async {
        guard let imageContext = imageContext else {
            return
        }
        history = await Loadable({ try await imageContext.history() })
    }
}

#if DEBUG
extension ImageDetailViewModel {
    static let preview: ImageDetailViewModel = {
        let viewModel = ImageDetailViewModel()
        viewModel.setup(context: .preview.first!, summary: ImageSummary.previews.first!)
        Task {
            await viewModel.load()
        }
        return viewModel
    }()
}
#endif
