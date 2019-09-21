//
//  CredentialCreater.swift
//  DataDownload_1.0
//
//  Created by Joel Ton on 9/18/19.
//  Copyright © 2019 RAMJETApps. All rights reserved.
//

/* From 'Handling an Authentication Challenge by Apple */

import UIKit

struct CredentialCreator {
	func credentialsFromUI(usernameField: UITextField, passwordField: UITextField) -> URLCredential? {
		guard let username = usernameField.text, !username.isEmpty,
			let password = passwordField.text, !password.isEmpty else {
				return nil
		}
		return URLCredential(user: username, password: password,
							 persistence: .forSession)
	}
	
	
	/* Use the following to call the completion handler with the credential
	
	guard let credential = credentialOrNil else {
	completionHandler(.cancelAuthenticationChallenge, nil)
	return
	}
	completionHandler(.useCredential, credential)
	
	*/
	
}
