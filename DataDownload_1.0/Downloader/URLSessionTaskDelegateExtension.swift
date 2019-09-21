//
//  URLSessionTaskDelegateExtension.swift
//  DataDownload_1.0
//
//  Created by Joel Ton on 9/18/19.
//  Copyright © 2019 RAMJETApps. All rights reserved.
//

import Foundation

// Individual task authentication

extension Downloader: URLSessionTaskDelegate {
	public func urlSession(_ session: URLSession, task: URLSessionTask,
			didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping
		(URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		
		if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault ||
		  challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic {
			let cedential = URLCredential(user: username, password: password,
										  persistence: .forSession)
			completionHandler(.useCredential, cedential)
		} else {
			completionHandler(.performDefaultHandling, nil)
		}
	}
}
