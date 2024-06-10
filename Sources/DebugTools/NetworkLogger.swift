//
//  NetworkLogger.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-20.
//

import Foundation

struct TaskInfo {
    let date = Date()
    var request: URLRequest
    var response: URLResponse?
    var data: Data?
    var error: Error?
    var metrics: URLSessionTaskMetrics?
}

class SessionTaskTracker {
    static let shared = SessionTaskTracker()
    
    private var tasks: [URLSessionTask: TaskInfo] = [:]
    private let queue = DispatchQueue(label: "com.DebugTools.SessionTaskTracker", attributes: .concurrent)
    
    private init() {}
    
    func addTask(_ task: URLSessionTask) {
        guard let request = task.originalRequest else { return }
        queue.async(flags: .barrier) {
            self.tasks[task] = TaskInfo(request: request)
        }
    }
    
    func updateTask(_ task: URLSessionTask, data: Data? = nil, error: Error? = nil, metrics: URLSessionTaskMetrics? = nil) {
        guard var taskInfo = tasks[task] else { return }
        
        if let response = task.response {
            taskInfo.response = response
        }
        if let data {
            taskInfo.data = data
        }
        if let error {
            taskInfo.error = error
        }
        if let metrics {
            taskInfo.metrics = metrics
        }
        
        queue.async(flags: .barrier) {
            self.tasks[task] = taskInfo
        }
    }
    
    subscript(_ task: URLSessionTask) -> TaskInfo? {
        tasks[task]
    }
    
    func allTasks() -> [TaskInfo] {
        Array(tasks.values)
    }
}

class URLSessionLoggerDelegate: NSObject {
    private let delegate: URLSessionDelegate?

    init(delegate: URLSessionDelegate?) {
        self.delegate = delegate
    }
}

// MARK: - URLSessionDelegate

extension URLSessionLoggerDelegate: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: (any Error)?) {
        delegate?.urlSession?(session, didBecomeInvalidWithError: error)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        delegate?.urlSession?(session, didReceive: challenge, completionHandler: completionHandler)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        delegate?.urlSessionDidFinishEvents?(forBackgroundURLSession: session)
    }
}

// MARK: - URLSessionTaskDelegate

extension URLSessionLoggerDelegate: URLSessionTaskDelegate {
    private var taskDelegate: URLSessionTaskDelegate? {
        delegate as? URLSessionTaskDelegate
    }
    
    // MARK: Track task creation
    
    @available(iOS 16.0, *)
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        SessionTaskTracker.shared.addTask(task)
        taskDelegate?.urlSession?(session, didCreateTask: task)
    }
    
    // MARK: Track metrics
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        SessionTaskTracker.shared.updateTask(task, metrics: metrics)
        taskDelegate?.urlSession?(session, task: task, didFinishCollecting: metrics)
    }

    // MARK: Track errors
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        SessionTaskTracker.shared.updateTask(task, error: error)
        taskDelegate?.urlSession?(session, task: task, didCompleteWithError: error)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        taskDelegate?.urlSession?(session, task: task, willBeginDelayedRequest: request, completionHandler: completionHandler)
    }

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        taskDelegate?.urlSession?(session, taskIsWaitingForConnectivity: task)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        taskDelegate?.urlSession?(session, task: task, willPerformHTTPRedirection: response, newRequest: request, completionHandler: completionHandler)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        taskDelegate?.urlSession?(session, task: task, didReceive: challenge, completionHandler: completionHandler)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        taskDelegate?.urlSession?(session, task: task, needNewBodyStream: completionHandler)
    }

    @available(iOS 17.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStreamFrom offset: Int64, completionHandler: @escaping (InputStream?) -> Void) {
        taskDelegate?.urlSession?(session, task: task, needNewBodyStreamFrom: offset, completionHandler: completionHandler)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        taskDelegate?.urlSession?(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }

    @available(iOS 17.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceiveInformationalResponse response: HTTPURLResponse) {
        taskDelegate?.urlSession?(session, task: task, didReceiveInformationalResponse: response)
    }
}

// MARK: - URLSessionDataDelegate

extension URLSessionLoggerDelegate: URLSessionDataDelegate {
    var dataDelegate: URLSessionDataDelegate? {
        delegate as? URLSessionDataDelegate
    }
    
    // MARK: Track data
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        SessionTaskTracker.shared.updateTask(dataTask, data: data)
        dataDelegate?.urlSession?(session, dataTask: dataTask, didReceive: data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dataDelegate?.urlSession?(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        dataDelegate?.urlSession?(session, dataTask: dataTask, didBecome: downloadTask)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        dataDelegate?.urlSession?(session, dataTask: dataTask, didBecome: streamTask)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        dataDelegate?.urlSession?(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }
}

extension URLSession {
    @objc func initWithLogger(configuration: URLSessionConfiguration, delegate: (any URLSessionDelegate)?, delegateQueue: OperationQueue?) -> URLSession {
        let loggerDelegate = URLSessionLoggerDelegate(delegate: delegate)

        return initWithLogger(configuration: configuration,
                              delegate: loggerDelegate,
                              delegateQueue: delegateQueue)
    }
}

public extension DebugTools {
    static func enableNetworkTracking() {
        if let originalMethod = class_getClassMethod(URLSession.self, #selector(URLSession.init(configuration:delegate:delegateQueue:))),
           let swizzledMethod = class_getClassMethod(URLSession.self, #selector(URLSession.initWithLogger)) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
