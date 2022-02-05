//
//  ContainerStateView.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import SwiftUI

struct ContainerStateView: View {
    var state: ContainerState
    
    var body: some View {
        switch state {
        case .running:
            Image(systemName: "play.fill")
                .foregroundColor(.green)
                .font(.system(size: 25))
        case .paused:
            Image(systemName: "pause.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 25))
        case .exited:
            Image(systemName: "stop.fill")
                .foregroundColor(.red)
                .font(.system(size: 25))
        case .removing:
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
                .font(.system(size: 25))
        case .restarting:
            Image(systemName: "arrow.clockwise")
                .foregroundColor(.blue)
                .font(.system(size: 25, weight: .bold))
        case .created:
            Image(systemName: "wrench.and.screwdriver.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 25))
        default:
            Circle()
                .fill(Color.gray)
                .frame(width: 25, height: 25, alignment: .topTrailing)
        }
    }
}

struct ContainerStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ContainerState.allCases, id: \.self) { state in
                VStack {
                    Text(state.rawValue)
                    ContainerStateView(state: state)
                }
                .previewLayout(.sizeThatFits)
            }
        }
    }
}
