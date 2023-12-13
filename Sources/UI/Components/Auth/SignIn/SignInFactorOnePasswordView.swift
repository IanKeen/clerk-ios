//
//  SignInFactorOnePasswordView.swift
//
//
//  Created by Mike Pitre on 11/2/23.
//

#if canImport(UIKit)

import SwiftUI
import Clerk

struct SignInFactorOnePasswordView: View {
    @EnvironmentObject private var clerk: Clerk
    @EnvironmentObject private var clerkUIState: ClerkUIState
    @Environment(\.clerkTheme) private var clerkTheme
    
    @State private var password: String = ""
    @State private var errorWrapper: ErrorWrapper?
    
    var signIn: SignIn {
        clerk.client.signIn
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                HeaderView(
                    title: "Enter your password",
                    subtitle: "to continue to \(clerk.environment.displayConfig.applicationName)"
                )
                
                IdentityPreviewView(
                    imageUrl: signIn.userData?.imageUrl,
                    label: signIn.identifier,
                    action: {
                        clerkUIState.presentedAuthStep = .signInStart
                    }
                )
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Password")
                            Spacer()
                            Button(action: {
                                // forgot password
                            }, label: {
                                Text("Forgot password?")
                            })
                        }
                        .font(.footnote.weight(.medium))
                        .tint(clerkTheme.colors.primary)
                        
                        PasswordInputView(password: $password)
                    }
                    
                    AsyncButton(action: attempt) {
                        Text("CONTINUE")
                            .font(.caption2.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .foregroundStyle(clerkTheme.colors.primaryButtonTextColor)
                            .background(clerkTheme.colors.primary)
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    }
                }
                
                AsyncButton {
                    clerkUIState.presentedAuthStep = .signInStart
                } label: {
                    Text("Use another method")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(clerkTheme.colors.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.vertical)
            .background(.background)
            .clerkErrorPresenting($errorWrapper)
        }
    }
    
    private func attempt() async {
        do {
            try await signIn.attemptFirstFactor(.password(password: password))
        } catch {
            errorWrapper = ErrorWrapper(error: error)
            dump(error)
        }
    }
}

#Preview {
    SignInFactorOnePasswordView()
        .environmentObject(Clerk.mock)
        .environmentObject(ClerkUIState())
}

#endif
