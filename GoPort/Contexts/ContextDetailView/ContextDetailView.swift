//
//  ContextDetailView.swift
//  GoPort
//
//  Created by Max Vissing on 14.01.22.
//

import SwiftUI
import GoPortApi

struct ContextDetailView: View {
    @StateObject var viewModel: ContextDetailViewModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }
    
    var body: some View {
        List {
            dockPortSection
            contextHostSection
            contextSection
        }
        .task {
            await viewModel.load()
        }
        .navigationTitle(viewModel.title)
    }
    
    var dockPortSection: some View {
        Section("DockPort Server") {
            DetailRowView(label: "Name", detail: viewModel.server.name)
            DetailRowView(label: "URL", detail: viewModel.server.host.absoluteString)
            if viewModel.pingInformation.isLoading {
                ProgressView()
            } else if let content = viewModel.pingInformation.content {
                DetailRowView(label: "GoPort Version", detail: content.goportVersion)
            }
        }
    }
    
    var contextHostSection: some View {
        Section("Context Host") {
            if let contextName = viewModel.contextName {
                DetailRowView(label: "Name", detail: contextName)
            }
            if let description = viewModel.context.content?.description {
                DetailRowView(label: "Description", detail: description)
            }
            if let content = viewModel.versionInformation.content {
                if let version = content.version {
                    DetailRowView(label: "Version", detail: version)
                }
                if let version = content.apiVersion {
                    DetailRowView(label: "API-Version", detail: version)
                }
                if let os = content.os {
                    DetailRowView(label: "OS", detail: os)
                }
                if let arch = content.arch {
                    DetailRowView(label: "Architecture", detail: arch)
                }
                if let buildTime = content.buildTime {
                    DetailRowView(label: "Build Time", detail: dateFormatter.string(from: buildTime))
                }
            }
            if let context = viewModel.context.content {
                if let orchestrator = context.stackOrchestrator {
                    DetailRowView(label: "Orchestrator", detail: orchestrator)
                }
                if let dockerHost = context.dockerHost {
                    DetailRowView(label: "Docker Host", detail: dockerHost)
                }
                if context.local {
                    HStack {
                        Text("Local")
                        Spacer()
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
            if viewModel.versionInformation.isLoading || viewModel.context.isLoading {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    var contextSection: some View {
        if let info = viewModel.systemInfo.content {
            Section("Context Information") {
                if let running = info.containersRunning, let paused = info.containersPaused, let stopped = info.containersStopped {
                    HStack {
                        Text("Containers")
                        Spacer()
                        Image(systemName: "play")
                            .foregroundColor(.green)
                        Text(String(running))
                        Image(systemName: "pause")
                            .foregroundColor(.yellow)
                        Text(String(paused))
                        Image(systemName: "stop")
                            .foregroundColor(.red)
                        Text(String(stopped))
                    }
                }
                if let images = info.images {
                    DetailRowView(label: "Images", detail: String(images))
                }
                if let os = info.operatingSystem {
                    DetailRowView(label: "Operating System", detail: os)
                }
                if let os = info.osType {
                    DetailRowView(label: "OS Type", detail: os)
                }
                if let arch = info.architecture {
                    DetailRowView(label: "Architecture", detail: arch)
                }
                if let cpu = info.cpuCount {
                    DetailRowView(label: "CPUs", detail: String(cpu))
                }
                if let memory = info.memoryTotal {
                    DetailRowView(label: "Architecture", detail: String(memory))
                }
            }
        }
    }
}

struct ContextDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContextDetailView(viewModel: ContextDetailViewModel.preview)
        }
    }
}
