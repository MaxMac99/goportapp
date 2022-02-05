//
//  ContainerRowView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI
import GoPortApi

struct ContainerRowView: View {
    var container: ContainerSummaryResponseItem
    
    var title: String {
        if let name = container.names?.first {
            if name.starts(with: "/") {
                return String(name.dropFirst())
            }
            return name
        }
        return Utilities.shortId(id: container.id ?? "", length: 8)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ContainerStateView(state: ContainerState(rawValue: container.state ?? "unknown") ?? .unknown)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                if let image = container.image {
                    Text(image)
                        .font(.subheadline)
                        .lineSpacing(-2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

extension GoPortPort {
    var displayName: String {
        var output = ""
        if let ip = ip, ip != "0.0.0.0" {
            output += "\(ip):"
        }
        if let publicPort = publicPort, publicPort != privatePort {
            output += "\(publicPort):"
        }
        output += String(privatePort)
        if type != .tcp {
            output += "/\(type)"
        }
        return output
    }
    
    static func sort(_ left: GoPortPort, _ right: GoPortPort) -> Bool {
        if left.type == .tcp && right.type != .tcp {
            return true
        }
        if left.type != .tcp && right.type == .tcp {
            return false
        }
        if left.ip != nil && left.ip != "0.0.0.0" && (right.ip == nil || right.ip == "0.0.0.0") {
            return true
        }
        if (left.ip == nil || left.ip == "0.0.0.0") && right.ip != nil && right.ip != "0.0.0.0" {
            return false
        }
        if (left.publicPort == nil || left.publicPort == left.privatePort) && right.publicPort != nil && right.publicPort != right.privatePort {
            return true
        }
        if left.publicPort != nil && left.publicPort != left.privatePort && (right.publicPort == nil || right.publicPort == right.privatePort) {
            return false
        }
        if let ip1 = left.ip, let ip2 = right.ip, ip1 != "0.0.0.0" {
            return ip1 < ip2
        }
        if let pub1 = left.publicPort, let pub2 = right.publicPort, pub1 != left.privatePort {
            return pub1 < pub2
        }
        return left.privatePort < right.privatePort
    }
}

#if DEBUG
struct ContainerRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(ContainerSummaryResponseItem.previews, id: \.id) { preview in
                ContainerRowView(container: preview)
            }
        }
    }
}
#endif
