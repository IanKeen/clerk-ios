//
//  SignUpEmailLinkView.swift
//
//
//  Created by Mike Pitre on 3/25/24.
//

import SwiftUI

struct SignUpEmailLinkView: View {
    @EnvironmentObject private var clerk: Clerk
    @EnvironmentObject private var clerkUIState: ClerkUIState
    @State private var errorWrapper: ErrorWrapper?
        
    private var signUp: SignUp {
        clerk.client.signUp
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                OrgLogoView()
                    .frame(width: 32, height: 32)
                    .padding(.bottom, 24)
                
                VStack(spacing: 4) {
                    HeaderView(
                        title: "Check your email",
                        subtitle: "Use the verification link sent to your email"
                    )
                    .multilineTextAlignment(.center)
                    
                    IdentityPreviewView(
                        label: signUp.emailAddress,
                        action: {
                            clerkUIState.presentedAuthStep = .signUpStart
                        }
                    )
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
        }
        .clerkErrorPresenting($errorWrapper)
        .task {
            await prepare()
        }
        .task {
            repeat {
                do {
                    try await clerk.client.get()
                    clerkUIState.setAuthStepToCurrentStatus(for: signUp)
                    try? await Task.sleep(for: .seconds(1))
                } catch {
                    errorWrapper = ErrorWrapper(error: error)
                    dump(error)
                }
            } while (!Task.isCancelled)
        }
    }
    
    private func prepare() async {
        let emailVerification = signUp.verifications.first(where: { $0.key == "email_link" })?.value
        if signUp.status == nil || emailVerification?.status == .verified {
            return
        }
        
        do {
            try await signUp.prepareVerification(.emailLink)
        } catch {
            errorWrapper = ErrorWrapper(error: error)
            dump(error)
        }
    }
}

#Preview {
    SignUpEmailLinkView()
        .environmentObject(Clerk.shared)
}
