//
//  SignInFactorTwoTotpCodeView.swift
//
//
//  Created by Mike Pitre on 1/9/24.
//

#if canImport(UIKit)

import SwiftUI

struct SignInFactorTwoTotpCodeView: View {
    @EnvironmentObject private var clerk: Clerk
    @EnvironmentObject private var clerkUIState: ClerkUIState
    
    @State private var code: String = ""
    @State private var errorWrapper: ErrorWrapper?
    
    private var signIn: SignIn {
        clerk.client.signIn
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                OrgLogoView()
                    .frame(width: 32, height: 32)
                    .padding(.bottom, 24)
                
                VerificationCodeView(
                    code: $code,
                    title: "Two-step verification",
                    subtitle: "To continue, please enter the verification code generated by your authenticator app"
                )
                .onCodeEntry {
                    await attempt()
                }
                .onContinueAction {
                    //
                }
                .onUseAlernateMethod {
                    clerkUIState.presentedAuthStep = .signInFactorTwoUseAnotherMethod(signIn.secondFactor(for: .totp))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
            .clerkErrorPresenting($errorWrapper)
        }
    }
    
    private func attempt() async {
        do {
            try await signIn.attemptSecondFactor(for: .totp(code: code))
        } catch {
            errorWrapper = ErrorWrapper(error: error)
            code = ""
            dump(error)
        }
    }
}

#Preview {
    SignInFactorTwoTotpCodeView()
        .environmentObject(Clerk.shared)
}

#endif
