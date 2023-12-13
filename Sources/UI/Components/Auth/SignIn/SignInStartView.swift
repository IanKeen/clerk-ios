//
//  SignInStartView.swift
//
//
//  Created by Mike Pitre on 9/22/23.
//

#if canImport(UIKit)

import SwiftUI
import Clerk

struct SignInStartView: View {
    @EnvironmentObject private var clerk: Clerk
    @EnvironmentObject private var clerkUIState: ClerkUIState
    @Environment(\.clerkTheme) private var clerkTheme
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                HeaderView(
                    title: "Sign in",
                    subtitle: "to continue to \(clerk.environment.displayConfig.applicationName)"
                )
                
                SignInSocialProvidersView()
                    .onSuccess { dismiss() }
                
                OrDivider()
                
                SignInFormView()
                                
                HStack(spacing: 4) {
                    Text("No account?")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button {
                        clerkUIState.authIsPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            clerkUIState.presentedAuthStep = .signUpStart
                        })
                    } label: {
                        Text("Sign Up")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(clerkTheme.colors.primary)
                    }
                    
                    Spacer()
                    
                    SecuredByClerkView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.vertical)
            .background(.background)
        }
    }
}

#Preview {
    SignInStartView()
        .environmentObject(Clerk.mock)
}

#endif
