//
//  FlexibleView.swift
//  GoPort
//
//  Created by Max Vissing on 03.02.22.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    var spacing: CGFloat = 10
    var alignment: HorizontalAlignment = .leading
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    @State private var elementsSize: [Data.Element: CGSize] = [:]
    
    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
                
                VStack(alignment: alignment, spacing: spacing) {
                    ForEach(computeRows(), id: \.self) { rowElements in
                        HStack(spacing: spacing) {
                            ForEach(rowElements, id: \.self) { element in
                                content(element)
                                    .frame(maxWidth: availableWidth)
                                    .fixedSize()
                                    .readSize { size in
                                        elementsSize[element] = size
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        
        return rows
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
