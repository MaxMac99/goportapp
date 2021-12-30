//
//  ContainerListView.swift
//  GoPort
//
//  Created by Max Vissing on 28.12.21.
//

import SwiftUI

struct ContainerListView: View {
    @ObservedObject var serverService: ServerService
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContainerListView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerListView(serverService: ServerService.preview)
    }
}
