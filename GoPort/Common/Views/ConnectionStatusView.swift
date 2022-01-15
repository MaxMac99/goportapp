//
//  ConnectionStatusView.swift
//  GoPort
//
//  Created by Max Vissing on 14.01.22.
//

import SwiftUI

enum ConnectionStatus {
    case disconnected
    case connected
    case connecting
}

struct ConnectionStatusView: View {
    var status: ConnectionStatus?
    
    var body: some View {
        switch status {
        case .connected:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.green)
                .frame(width: 20, height: 20)
        case .disconnected:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color.red)
                .frame(width: 20, height: 20)
        default:
            ProgressView()
        }
    }
}

struct ConnectionStatusView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ConnectionStatusView(status: .connected)
            ConnectionStatusView(status: .disconnected)
            ConnectionStatusView(status: .connecting)
        }
    }
}
