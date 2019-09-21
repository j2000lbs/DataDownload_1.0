//
//  ViewController.swift
//  DataDownload_1.0
//
//  Created by Joel Ton on 9/11/19.
//  Copyright © 2019 RAMJETApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let downloader: Downloader = {
		let config = URLSessionConfiguration.ephemeral
		config.allowsCellularAccess = true
		return Downloader(configureation: config)
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let s = "https://www15.swalife.com/PortalWeb/cwa.jsp?test=test"
		let url = URL(string: s)!
		self.downloader.download(url: url) { url in
			if let url = url, let data = try? Data(contentsOf: url) {
				// handle data here
				do {
					let json = try JSONSerialization.jsonObject(with: data, options: [])
					print(json)
				} catch {
					print("JSON error: \(error.localizedDescription)")
				}
			}
		}
		
//		let url = URL(string: "https://www15.swalife.com/csswa/ea/plt/accessCrewMemberBoard.do?popup=true&crewMemberId=79449")!
//
//		let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
//			if let localURL = localURL {
//				if let string = try? String(contentsOf: localURL) {
//					print("Printing what was downloaded...\n")
//					print(string)
//				}
//			}
//		}
//		task.resume()
	}
	
	/*
	do {
	let json = try JSONSerialization.jsonObject(with: data!, options: [])
	print(json)
	} catch {
	print("JSON error: \(error.localizedDescription)")
	}
 */


}

