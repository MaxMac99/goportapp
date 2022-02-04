//
//  LoadingView.swift
//  GoPort
//
//  Created by Max Vissing on 02.02.22.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    var isLoading: Bool
    var content: () -> Content
    
    var body: some View {
        ZStack(alignment: .center) {
            self.content()
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(CoreGraphics.CGSize(width: 1.7, height: 1.7))
                    .padding(35)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.7)))
            }
        }
    }
}

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true) {
            Text("This is just a test")
        }
    }
}
#endif
