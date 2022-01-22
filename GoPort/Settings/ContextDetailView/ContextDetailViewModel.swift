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
    private(set) var server: Server?
    private(set) var contextName: String?
    @Published fileprivate(set) var context: Loadable<ContextInspectResponse> = .loading
    @Published fileprivate(set) var pingInformation: Loadable<SystemPingResponseSummary> = .loading
    @Published fileprivate(set) var versionInformation: Loadable<SystemVersionResponse> = .loading
    @Published fileprivate(set) var systemInfo: Loadable<SystemInfoResponseItem> = .loading
    
    var title: String {
        contextName ?? server?.name ?? ""
    }
    
    enum ContextLoadingError: Error {
        case invalidResponse
        case noContext
    }
    
    private var session: NetworkingSession
    
    init(session: NetworkingSession = .shared) {
        self.session = session
    }
    
    func setup(server: Server, contextName: String? = nil) {
        guard self.server == nil else {
            return
        }
        self.server = server
        self.contextName = contextName
    }
    
    func load() async {
        guard let _ = server else {
            return
        }
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
        guard let server = server else {
            return
        }
        pingInformation = await Loadable { try await SystemAPI.systemPing(host: server.host, context: contextName.array, session: session) }
        if let defaultContext = pingInformation.content?.contexts.first?.key, contextName == nil {
            self.contextName = defaultContext
        }
    }
    
    func loadVersionInformation() async {
        guard let server = server else {
            return
        }
        versionInformation = await Loadable { try await SystemAPI.systemVersion(host: server.host, context: contextName, session: session) }
    }
    
    func loadInfo() async {
        guard let server = server else {
            return
        }
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
        guard let server = server else {
            return
        }
        guard let contextName = contextName else {
            context = .error(ContextLoadingError.noContext)
            return
        }
        context = await Loadable { try await ContextAPI.contextInspect(host: server.host, name: contextName, session: session) }
    }
    
    func useThisServer() {
        guard let server = server else {
            return
        }
        ServerService.shared.select(server)
    }
    
    func deleteServer() {
        guard let server = server else {
            return
        }
        ServerService.shared.remove(server)
    }
}

#if DEBUG
extension ContextDetailViewModel {
    static let preview: ContextDetailViewModel = {
        let viewModel = ContextDetailViewModel(session: .preview)
        viewModel.pingInformation = .loaded(SystemPingResponseSummary.preview)
        viewModel.context = .loaded(ContextInspectResponse.preview)
        viewModel.versionInformation = .loaded(SystemVersionResponse.preview)
        viewModel.systemInfo = .loaded(SystemInfoResponse.preview["default"]!)
        return viewModel
    }()
}
#endif
