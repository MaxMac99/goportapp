//
//  ServerContextRowView.swift
//  GoPort
//
//  Created by Max Vissing on 21.01.22.
//

import SwiftUI
import GoPortApi

struct ServerContextRowView: View {
    var context: GoPortContext
    var status: ConnectionStatus
    @Binding var isSelected: Bool
    
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: ContextDetailView(context: context), isActive: $showDetail) {
                EmptyView()
            }
            .hidden()
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.accentColor)
                    .opacity(isSelected ? 1 : 0)
                Text(context.name)
                Spacer()
                ConnectionStatusView(status: status)
                Button {
                    showDetail = true
                } label: {
                    Image(systemName: "i.circle")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

struct ServerContextRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ServerContextRowView(context: Server.preview.first!.contexts.first!, status: .connected, isSelected: .constant(false))
            ServerContextRowView(context: Server.preview[1].contexts.first!, status: .connecting, isSelected: .constant(true))
        }
    }
}
