//
//  ImageDetailView.swift
//  GoPort
//
//  Created by Max Vissing on 03.02.22.
//

import SwiftUI
import GoPortApi

struct ImageDetailView: View {
    var context: GoPortContext
    var summary: ImageSummary
    @StateObject var viewModel = ImageDetailViewModel()
    
    var image: ImageResponse? {
        viewModel.image.content
    }
    var history: HistoryResponse? {
        viewModel.history.content?.reversed()
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private var title: String {
        if let tag = image?.repoTags?.first {
            return Utilities.shortTag(tag: tag)
        }
        if let tag = summary.repoTags.first {
            return Utilities.shortTag(tag: tag)
        }
        return summary.shortId
    }
    
    var body: some View {
        List {
            imageDetails
            dockerfileDetails
            historyView
        }
        .navigationTitle(title)
        .task {
            viewModel.setup(context: context, summary: summary)
            await viewModel.load()
        }
    }
    
    private var imageDetails: some View {
        Section("Image Details") {
            VStack(alignment: .leading) {
                Text("ID")
                Text(summary.id)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 6)
            DetailRowView(label: "Size", detail: byteCountFormatter.string(fromByteCount: image?.size ?? summary.size))
            DetailRowView(label: "Created", detail: dateFormatter.string(from: image?.created ?? summary.created))
            if let image = image {
                DetailRowView(label: "Build", detail: "Docker \(image.dockerVersion + " ")on \(image.os)\(", " + image.architecture)")
            }
        }
    }
    
    @ViewBuilder private var dockerfileDetails: some View {
        if let config = image?.config {
            Section("Dockerfile Details") {
                if let detail = config.hostname, detail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    DetailRowView(label: "Hostname", detail: detail)
                }
                if let detail = config.domainname, detail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    DetailRowView(label: "Domainname", detail: detail)
                }
                if let detail = config.user, detail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    DetailRowView(label: "User", detail: detail)
                }
                if let exposedPorts = config.exposedPorts {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Expose")
                        FlexibleView(data: Array(exposedPorts.keys).sorted(by: <), spacing: 7) { item in
                            Text(item)
                                .font(Font.system(size: 16))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(white: 0.8)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                if let detail = config.env {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ENV")
                        ForEach(detail, id: \.self) { env in
                            Text(env)
                                .font(Font.system(size: 16))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(white: 0.8)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                if let detail = config.cmd {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("CMD")
                        ForEach(detail, id: \.self) { item in
                            Text(item)
                                .font(Font.system(size: 16))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(white: 0.8)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                if let detail = config.volumes {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Volumes")
                        ForEach(Array(detail.keys).sorted(by: <), id: \.self) { item in
                            Text(item)
                                .font(Font.system(size: 16))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(white: 0.8)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                if let detail = config.workingDir, detail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    DetailRowView(label: "Workdir", detail: detail)
                }
                if let detail = config.entrypoint {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Entrypoint")
                        ForEach(detail, id: \.self) { item in
                            Text(item)
                                .font(Font.system(size: 16))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                                .fill(Color(white: 0.8)))
                        }
                    }
                    .padding(.vertical, 6)
                }
                healthcheckView
            }
        }
    }
    
    @ViewBuilder private var healthcheckView: some View {
        if let detail = image?.config?.healthcheck?.test {
            VStack(alignment: .leading, spacing: 3) {
                Text("Health Test")
                ForEach(detail, id: \.self) { item in
                    Text(item)
                        .font(Font.system(size: 16))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(white: 0.8)))
                }
            }
            .padding(.vertical, 6)
        }
        if let detail = image?.config?.healthcheck?.interval, let formatted = numberFormatter.string(from: NSNumber(value: detail / 1_000_000)) {
            DetailRowView(label: "Health Interval", detail: "\(formatted) ms")
        }
        if let detail = image?.config?.healthcheck?.timeout, let formatted = numberFormatter.string(from: NSNumber(value: detail / 1_000_000)) {
            DetailRowView(label: "Health Timeout", detail: "\(formatted) ms")
        }
        if let detail = image?.config?.healthcheck?.retries, let formatted = numberFormatter.string(from: NSNumber(value: detail)) {
            DetailRowView(label: "Health Retries", detail: formatted)
        }
        if let detail = image?.config?.healthcheck?.startPeriod, let formatted = numberFormatter.string(from: NSNumber(value: detail / 1_000_000)) {
            DetailRowView(label: "Health Start Period", detail: "\(formatted) ms")
        }
    }
    
    @ViewBuilder private var historyView: some View {
        if let history = history {
            Section("Image Layers") {
                ForEach(history, id: \.uniqueId) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.shortId)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(byteCountFormatter.string(fromByteCount: item.size))
                        }
                        Text(item.createdBy)
                        HStack {
                            Spacer()
                            Text(dateFormatter.string(from: item.created))
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }
}

extension HistoryResponseItem {
    var uniqueId: String {
        "\(id)\(created)\(createdBy)"
    }
    var shortId: String {
        Utilities.shortId(id: id)
    }
}

#if DEBUG
struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageDetailView(context: .preview.first!, summary: ImageSummary.previews.first!, viewModel: .preview)
        }
    }
}
#endif
