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
    let server: Server
    private(set) var contextName: String?
    @Published fileprivate(set) var context: Loadable<ContextInspectResponse> = .loading
    @Published fileprivate(set) var pingInformation: Loadable<SystemPingResponseSummary> = .loading
    @Published fileprivate(set) var versionInformation: Loadable<SystemVersionResponse> = .loading
    @Published fileprivate(set) var systemInfo: Loadable<SystemInfoResponseItem> = .loading
    
    var title: String {
        contextName ?? server.name
    }
    
    enum ContextLoadingError: Error {
        case invalidResponse
        case noContext
    }
    
    private var session: NetworkingSession
    
    init(server: Server, contextName: String? = nil, session: NetworkingSession = .shared) {
        self.server = server
        self.contextName = contextName
        self.session = session
    }
    
    func load() async {
        await withTaskGroup(of: Void.self) { group in
            if contextName == nil {
                group.addTask {
                    await self.loadPingInformation()
                    await self.loadContext()
                }
            } else {
                group.addTask {
                    await self.loadPingInformation()
                }
                group.addTask {
                    await self.loadContext()
                }
            }
            group.addTask { await self.loadVersionInformation() }
            group.addTask { await self.loadInfo() }
            
            await group.waitForAll()
        }
    }
    
    func loadPingInformation() async {
        pingInformation = await Loadable { try await SystemAPI.systemPing(host: server.host, context: contextName.array, session: session) }
        if let defaultContext = pingInformation.content?.contexts.first?.key, contextName == nil {
            self.contextName = defaultContext
        }
    }
    
    func loadVersionInformation() async {
        versionInformation = await Loadable { try await SystemAPI.systemVersion(host: server.host, context: contextName, session: session) }
    }
    
    func loadInfo() async {
        systemInfo = await Loadable {
            let infoDict = try await SystemAPI.systemInfo(host: server.host, context: contextName.array, session: session)
            if let contextName = contextName, let info = infoDict[contextName] {
                return info
            } else if let info = infoDict.first?.value {
                return info
            } else {
                throw ContextLoadingError.invalidResponse
            }
        }
    }
    
    func loadContext() async {
        guard let contextName = contextName else {
            context = .error(ContextLoadingError.noContext)
            return
        }
        context = await Loadable { try await ContextAPI.contextInspect(host: server.host, name: contextName, session: session) }
    }
}

#if DEBUG
extension ContextDetailViewModel {
    static var preview: ContextDetailViewModel {
        let viewModel = ContextDetailViewModel(server: Server.preview.first!, contextName: "default", session: .preview)
        viewModel.pingInformation = .loaded(SystemPingResponseSummary.preview)
        viewModel.context = .loaded(ContextInspectResponse.preview)
        viewModel.versionInformation = .loaded(SystemVersionResponse.preview)
        viewModel.systemInfo = .loaded(SystemInfoResponse.preview["default"]!)
        return viewModel
    }
}
#endif
