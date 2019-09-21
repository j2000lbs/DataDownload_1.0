//
//  Downloader.swift
//  DataDownload_1.0
//
//  Created by Joel Ton on 9/12/19.
//  Copyright © 2019 RAMJETApps. All rights reserved.
//

import UIKit

let isMain = false // try false to move delegate methods onto a background thread

typealias DownloaderCH = (URL?) -> ()

class Downloader: NSObject {
	
	let username = "e79449"
	let password = "Buttholes15"
	let config: URLSessionConfiguration
	let dispatchq = DispatchQueue.global(qos: .background)
	let queue: OperationQueue = {
		let q = OperationQueue()
		q.maxConcurrentOperationCount = 1
		return q
	}()
	lazy var session: URLSession = {
		let queue = (isMain ? .main : self.queue)
		return URLSession(configuration: self.config, delegate: DownloaderDelegate(),
						  delegateQueue: queue)
	}()
	init(configureation config: URLSessionConfiguration) {
		self.config = config
		super.init()
	}
	
	
	@discardableResult
	func download(url: URL, completionHandler ch: @escaping DownloaderCH) -> URLSessionTask {
		let task = self.session.downloadTask(with: url)
		let dlDelegate = self.session.delegate as! DownloaderDelegate
		// Make sure the DownloaderDelegate is only accessed on its queue
		self.session.delegateQueue.addOperation {
			dlDelegate.appendHandler(ch, task: task)
		}
		task.resume()
		return task
	}
	
	
	private class DownloaderDelegate: NSObject, URLSessionDownloadDelegate {
		
		private var handlers = [Int : DownloaderCH]()
		func appendHandler (_ ch: @escaping DownloaderCH, task: URLSessionTask) {
			print("Adding completion handler for task \(task.taskIdentifier)")
			self.handlers[task.taskIdentifier] = ch
		}
		
		
		func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
			
			print("Finished download for task \(downloadTask.taskIdentifier)")
			let ch = self.handlers[downloadTask.taskIdentifier]
			if isMain {
				ch?(location)
			} else {
				DispatchQueue.main.sync {
					ch?(location)
				}
			}
		}
		
		
		func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
			
			print("Removing completion for task \(task.taskIdentifier)")
			
			let ch = self.handlers[task.taskIdentifier]
			self.handlers[task.taskIdentifier] = nil
			
			// whoa, this is a flaw in the book and example code too; need to return nil if we get error
			if let error = error {
				print("error?", error)
				if isMain {
					ch?(nil)
				} else {
					DispatchQueue.main.sync {
						ch?(nil)
					}
				}
			}
		}
		deinit {
			print("Goodbye form DownloaderDelegate", self.handlers.count)
		}
	}
	
	
	deinit {
		print("Goodbye form Downloader")
		self.session.invalidateAndCancel()
	}
}
