//
//  UserProfileView.swift
//
//
//  Created by Mike Pitre on 11/3/23.
//

#if canImport(UIKit)

import SwiftUI
import Clerk
import Factory

public struct UserProfileView: View {
    @EnvironmentObject private var clerk: Clerk
    
    private var user: User? {
        clerk.client.lastActiveSession?.user
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HeaderView(
                    title: "Account",
                    subtitle: "Manage your account information"
                )
                
                UserProfileSection()
                UserProfileEmailSection()
                UserProfilePhoneNumberSection()
                UserProfileExternalAccountSection()
            }
            .padding(30)
            .animation(.snappy, value: user)
        }
        .task {
            try? await clerk.client.get()
        }
    }
}

#Preview {
    _ = Container.shared.clerk.register { .mock }
    return UserProfileView()
        .environmentObject(Clerk.mock)
}

#endif
