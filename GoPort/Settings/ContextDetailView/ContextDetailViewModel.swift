//
//  ContextDetailViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation
import GoPortApi

@MainActor
class ContextDetailViewModel: ObservableObject {
    private(set) var context: GoPortContext?
    @Published fileprivate(set) var contextInfo: Loadable<ContextInspectResponse> = .loading
    @Published fileprivate(set) var goportVersion: Loadable<String?> = .loading
    @Published fileprivate(set) var versionInformation: Loadable<SystemVersionResponse> = .loading
    @Published fileprivate(set) var systemInfo: Loadable<SystemInfoResponseItem> = .loading
    
    var title: String {
        context?.name ?? ""
    }
    
    enum ContextLoadingError: Error {
        case invalidResponse
        case noContext
    }
    
    func setup(context: GoPortContext) {
        guard self.context == nil else {
            return
        }
        self.context = context
    }
    
    func load() async {
        guard let _ = context else { return }
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadPingInformation() }
            group.addTask { await self.loadContext() }
            group.addTask { await self.loadVersionInformation() }
            group.addTask { await self.loadInfo() }
            
            await group.waitForAll()
        }
    }
    
    func loadPingInformation() async {
        guard let context = context else { return }
        goportVersion = await Loadable { try await context.ping().goportVersion }
    }
    
    func loadVersionInformation() async {
        guard let context = context else { return }
        versionInformation = await Loadable { try await context.version() }
    }
    
    func loadInfo() async {
        guard let context = context else { return }
        systemInfo = await Loadable { try await context.info() }
    }
    
    func loadContext() async {
        guard let context = context else { return }
        contextInfo = await Loadable { try await context.inspect() }
    }
}

#if DEBUG
extension ContextDetailViewModel {
    static let preview: ContextDetailViewModel = {
        let viewModel = ContextDetailViewModel()
        viewModel.goportVersion = .loaded(SystemPingResponseSummary.preview.goportVersion)
        viewModel.contextInfo = .loaded(ContextInspectResponse.preview)
        viewModel.versionInformation = .loaded(SystemVersionResponse.preview)
        viewModel.systemInfo = .loaded(SystemInfoResponse.preview["default"]!)
        return viewModel
    }()
}
#endif
