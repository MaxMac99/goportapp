//
//  RespondableTextField.swift
//  Piew
//
//  Created by Max Vissing on 27.03.20.
//  Copyright © 2020 Max Vissing. All rights reserved.
//

import SwiftUI

struct RespondableTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        var onReturnKey: (() -> Bool)?
        
        init(text: Binding<String>, onReturnKey: (() -> Bool)? = nil) {
            _text = text
            self.onReturnKey = onReturnKey
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturnKey?() ?? true
        }
    }
    
    var title: String? = nil
    @Binding var text: String
    var isActive: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocorrectionType: UITextAutocorrectionType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var returnKeyType: UIReturnKeyType = .default
    var onReturnKey: (() -> Bool)? = nil
    
    func makeUIView(context: UIViewRepresentableContext<RespondableTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = title
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.returnKeyType = returnKeyType
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onReturnKey: self.onReturnKey)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isActive {
            uiView.becomeFirstResponder()
        }
    }
}

struct RespondableTextField_Previews: PreviewProvider {
    static var previews: some View {
        RespondableTextField(title: "Test", text: .constant(""))
    }
}
