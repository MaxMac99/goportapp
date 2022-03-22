//
//  ContextDetailView.swift
//  GoPort
//
//  Created by Max Vissing on 14.01.22.
//

import SwiftUI
import GoPortApi

struct ContextDetailView: View {
    var context: GoPortContext
    @StateObject var viewModel: ContextDetailViewModel
    @Environment(\.presentationMode) var presenationMode
    
    init(context: GoPortContext, viewModel: ContextDetailViewModel? = nil) {
        self.context = context
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: ContextDetailViewModel())
        }
    }
    
    private var dateFormatter: DateFormatter {
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
            viewModel.setup(context: context)
            await viewModel.load()
        }
        .navigationTitle(viewModel.title)
    }
    
    private var dockPortSection: some View {
        Section("DockPort Server") {
            DetailRowView(label: "Name", detail: context.server.name)
            DetailRowView(label: "URL", detail: context.server.host.absoluteString)
            if let content = viewModel.goportVersion.content, let version = content {
                DetailRowView(label: "GoPort Version", detail: version)
            }
            
            if viewModel.goportVersion.isLoading {
                ProgressView()
            }
        }
    }
    
    private var contextHostSection: some View {
        Section("Context Host") {
            DetailRowView(label: "Name", detail: context.name)
            if let description = viewModel.contextInfo.content?.description {
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
            if let context = viewModel.contextInfo.content {
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
            if viewModel.versionInformation.isLoading || viewModel.contextInfo.isLoading {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    private var contextSection: some View {
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
            ContextDetailView(context: Server.preview.first!.contexts.first!, viewModel: ContextDetailViewModel.preview)
        }
    }
}
