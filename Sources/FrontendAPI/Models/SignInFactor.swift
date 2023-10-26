//
//  SignInFactor.swift
//
//
//  Created by Mike Pitre on 10/10/23.
//

import Foundation

/**
 Each factor contains information about the verification strategy that can be used.
 For example:
 email_code for email addresses
 phone_code for phone numbers
 As well as the identifier that the factor refers to.
 */
public struct SignInFactor: Decodable {
    init(
        strategy: Strategy,
        safeIdentifier: String? = nil,
        emailAddressId: String? = nil,
        phoneNumberId: String? = nil
    ) {
        self.strategy = strategy.stringValue
        self.safeIdentifier = safeIdentifier
        self.emailAddressId = emailAddressId
        self.phoneNumberId = phoneNumberId
    }
    
    public let strategy: String
    public let safeIdentifier: String?
    public let emailAddressId: String?
    public let phoneNumberId: String?
}
