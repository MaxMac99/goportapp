//
//  AddServerView.swift
//  GoPort
//
//  Created by Max Vissing on 18.01.22.
//

import SwiftUI

struct AddServerView: View {
    @StateObject var viewModel: AddServerViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showValidationErrors = false
    @State private var connectionError: Error? = nil
    @State private var savingError: Error? = nil
    @State private var isConnecting = false
    @State private var showNext = false
    
    init(viewModel: AddServerViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: AddServerViewModel())
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .trailing) {
                        RespondableTextField(title: "URL", text: $viewModel.url, isActive: !showNext, keyboardType: .URL, autocorrectionType: .no, autocapitalizationType: .none, returnKeyType: .go) {
                            if !isConnecting {
                                connect()
                            }
                            return true
                        }
                        .disabled(isConnecting)
                        if !viewModel.isURLValid && viewModel.url != "" {
                            Text("The URL is not valid!")
                                .fontWeight(.light)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                        if let connectionError = connectionError {
                            Text("Connection Error: \(connectionError.localizedDescription)")
                                .fontWeight(.light)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                    }
                    if showNext {
                        RespondableTextField(title: "Name", text: $viewModel.name, isActive: showNext, keyboardType: .default, autocorrectionType: .no, autocapitalizationType: .words, returnKeyType: .default) {
                            if viewModel.isNameValid {
                                save()
                            }
                            return true
                        }
                        if let savingError = savingError {
                            Text("Error while saving: \(savingError.localizedDescription)")
                                .fontWeight(.light)
                                .font(.footnote)
                                .foregroundColor(Color.red)
                        }
                    }
                }
                Section {
                    if showNext {
                        Button {
                            save()
                        } label: {
                            HStack(spacing: 8) {
                                Text("Save")
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(!viewModel.isNameValid)
                    } else {
                        Button {
                            connect()
                        } label: {
                            HStack(spacing: 8) {
                                Text("Connect")
                                if isConnecting {
                                    ProgressView()
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(!viewModel.isURLValid || isConnecting)
                    }
                }
                if let info = viewModel.serverInformation {
                    Section {
                        DetailRowView(label: "Version", detail: info.goportVersion)
                        DetailRowView(label: "Contexts", detail: String(info.contexts.count))
                    }
                }
            }
            .navigationTitle("Add Server")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .disabled(isConnecting)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showNext {
                        Button {
                            save()
                        } label: {
                            Text("Save")
                        }
                        .disabled(!viewModel.isNameValid)
                    } else {
                        Button {
                            connect()
                        } label: {
                            Text("Connect")
                        }
                        .disabled(!viewModel.isURLValid || isConnecting)
                    }
                }
            }
        }
        .onChange(of: viewModel.url, perform: { newValue in
            withAnimation {
                connectionError = nil
            }
            guard newValue != viewModel.lastCheckedURL else {
                return
            }
            withAnimation {
                showNext = false
                viewModel.serverInformation = nil
            }
        })
        .onChange(of: viewModel.name, perform: { newValue in
            withAnimation {
                savingError = nil
            }
        })
        .onChange(of: viewModel.isURLValid) { newValue in
            if newValue {
                withAnimation {
                    self.showValidationErrors = true
                }
            }
        }
    }
    
    func connect() {
        guard viewModel.isURLValid else { return }
        Task {
            do {
                isConnecting = true
                try await viewModel.connect()
                showNext = true
            } catch {
                connectionError = error
            }
            isConnecting = false
        }
    }
    
    func save() {
        Task {
            do {
                isConnecting = true
                try await viewModel.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                savingError = error
            }
            isConnecting = false
        }
    }
}

struct AddServerView_Previews: PreviewProvider {
    static var previews: some View {
        AddServerView()
    }
}
