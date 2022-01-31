//
//  AddServerViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 18.01.22.
//

import Foundation
import UIKit
import GoPortApi

@MainActor
class AddServerViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var url: String = ""
    
    var serverInformation: SystemPingResponseSummary? = nil
    private(set) var lastCheckedURL: String?
    
    private var session: NetworkingSession
    
    init(session: NetworkingSession = .shared) {
        self.session = session
    }
    
    var isURLValid: Bool {
        createURL() != nil
    }
    
    var isNameValid: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
    func connect() async throws {
        guard let host = createURL() else {
            throw APIRequestError.invalidURL(url)
        }
        serverInformation = try await SystemAPI.systemPing(host: host, context: ["all"], session: session)
        if host.pathComponents.count < 2 || !GoPortAPI.supportedGoPortVersions.contains(host.lastPathComponent) {
            if let goportVersion = serverInformation?.goportVersion, GoPortAPI.supportedGoPortVersions.contains(goportVersion) {
                url = host.appendingPathComponent(goportVersion).absoluteString
            } else {
                url = host.appendingPathComponent(GoPortAPI.supportedGoPortVersions.last!).absoluteString
            }
        } else {
            url = host.absoluteString
        }
        lastCheckedURL = url
    }
    
    func save() async throws {
        guard url == lastCheckedURL else {
            throw ServerService.SaveServerError.notCheckedURL
        }
        try await ServerService.shared.addServer(name: name, url: url)
    }
    
    private func createURL() -> URL? {
        guard url != "" else {
            return nil
        }
        var urlString = url
        if urlString.last == "/" {
            urlString = String(urlString.dropLast())
        }
        guard var fullHost = URL(string: urlString) else {
            return nil
        }
        if fullHost.scheme != "http" && fullHost.scheme != "https" {
            let fullURLString = "http://\(fullHost.absoluteString)"
            guard let tempFullHost = URL(string: fullURLString) else {
                return nil
            }
            fullHost = tempFullHost
        }
        guard var urlComponents = URLComponents(url: fullHost, resolvingAgainstBaseURL: true) else {
            return nil
        }
        if fullHost.port == nil {
            urlComponents.port = GoPortAPI.defaultPort
        }
        guard let url = urlComponents.url else {
            return nil
        }
        return url
    }
}

#if DEBUG
extension AddServerViewModel {
    static let preview = AddServerViewModel(session: .preview)
    static let namePreview: AddServerViewModel = {
        let viewModel = AddServerViewModel(session: .preview)
        viewModel.url = "http://localhost:9212/v1"
        viewModel.serverInformation = SystemPingResponseSummary.preview
        return viewModel
    }()
}
#endif
