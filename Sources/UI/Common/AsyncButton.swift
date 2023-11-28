//
//  SwiftUIView.swift
//
//
//  Created by Mike Pitre on 10/4/23.
//

#if canImport(UIKit)

import SwiftUI

struct AsyncButton<Label: View>: View {
    public init(
        options: Set<AsyncButton<Label>.Options> = [.disableButton, .showProgressView],
        action: @escaping () async -> Void,
        label: @escaping () -> Label
    ) {
        self.options = options
        self.action = action
        self.label = label
    }
    
    var options = Set(Options.allCases)
    var action: () async -> Void
    @ViewBuilder var label: () -> Label
    
    @State private var isDisabled = false
    @State private var showProgressView = false
    @Environment(\.isEnabled) private var isEnabled
    
    // Combines environment value and local state
    private var disabled: Bool {
        !isEnabled || isDisabled
    }
    
    public var body: some View {
        Button(
            action: {
                if options.contains(.disableButton) {
                    isDisabled = true
                }
                
                if options.contains(.showProgressView) {
                    showProgressView = true
                }
                
                Task {
                    await action()
                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                label()
                    .opacity(disabled ? 0.3 : 1)
                    .opacity(showProgressView ? 0 : 1)
                    .overlay {
                        if showProgressView {
                            ProgressView()
                        }
                    }
            }
        )
        .disabled(disabled)
        .animation(.default, value: disabled)
        .animation(.default, value: showProgressView)
    }
}

#Preview {
    AsyncButton {
        try? await Task.sleep(for: .seconds(1))
    } label: {
        Text("Button")
    }
}

extension AsyncButton {
    public enum Options: CaseIterable {
        case disableButton
        case showProgressView
    }
}

#endif
