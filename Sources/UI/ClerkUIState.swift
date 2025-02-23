//
//  ClerkUIState.swift
//
//
//  Created by Mike Pitre on 10/25/23.
//

#if os(iOS)

import Foundation

public final class ClerkUIState: ObservableObject {
    
    public init() {}
    
    /// Is the auth view  being displayed.
    @Published public var authIsPresented = false

    public enum AuthStep: Equatable {
        case signInStart
        case signInFactorOne(_ factor: SignInFactor?)
        case signInFactorOneUseAnotherMethod(_ currentFactor: SignInFactor?)
        case signInFactorTwo(_ factor: SignInFactor?)
        case signInFactorTwoUseAnotherMethod(_ currentFactor: SignInFactor?)
        case signInForgotPassword
        case signInResetPassword
        case signUpStart
        case signUpVerification
    }
    
    @Published public var presentedAuthStep: AuthStep = .signInStart {
        willSet {
            authIsPresented = true
        }
    }
    
    /// Is the user profile view being displayed
    @Published public var userProfileIsPresented = false
}

extension ClerkUIState {
    
    /// Sets the current auth step to the status determined by the API
    public func setAuthStepToCurrentStatus(for signIn: SignIn?) {
        switch signIn?.status {
        case .needsIdentifier, .abandoned:
            presentedAuthStep = .signInStart
        case .needsFirstFactor:
            presentedAuthStep = .signInFactorOne(signIn?.currentFirstFactor)
        case .needsSecondFactor:
            presentedAuthStep = .signInFactorTwo(signIn?.currentSecondFactor)
        case .needsNewPassword:
            presentedAuthStep = .signInResetPassword
        case .complete, .none:
            authIsPresented = false
        }
    }
    
    /// Sets the current auth step to the status determined by the API
    public func setAuthStepToCurrentStatus(for signUp: SignUp?) {
        switch signUp?.status {
        case .missingRequirements:
            if (signUp?.unverifiedFields ?? []).contains(where: { $0 == "email_address" || $0 == "phone_number" })  {
                presentedAuthStep = .signUpVerification
            } else {
                presentedAuthStep = .signUpStart
            }
            
        case .abandoned:
            presentedAuthStep = .signUpStart
            
        case .complete, .none:
            authIsPresented = false
        }
    }
    
}

#endif
