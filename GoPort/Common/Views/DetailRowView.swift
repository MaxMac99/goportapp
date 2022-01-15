//
//  DetailRowView.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import SwiftUI

struct DetailRowView: View {
    var label: String
    var detail: String?
    
    var body: some View {
        if let detail = detail {
            HStack {
                Text(label)
                Spacer()
                Text(detail)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DetailRowView(label: "Test")
            DetailRowView(label: "Test", detail: "test")
        }
    }
}
