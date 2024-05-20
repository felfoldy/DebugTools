//
//  NetworkLogger.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-20.
//

import Foundation

extension URLSession {
    static func attachLogger() {
        let original = class_getInstanceMethod(URLSession.self, #selector(URLSession.dataTask(with:completionHandler:) as (URLSession) -> (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask))

        let swizzled = class_getInstanceMethod(URLSession.self, #selector(URLSession.swizzled_dataTask))
        
        if let original, let swizzled {
            method_exchangeImplementations(original, swizzled)
        }
    }
    
    private static func logMessage(_ message: String) {
        guard let console = DebugTools.sharedConsole else {
            return
        }

        var entries = console.updateLogPublisher.value
        entries.append(LogEntry(composedMessage: message,
                                level: .debug,
                                date: .now,
                                location: "Networking"))
        console.updateLogPublisher.send(entries)
    }
    
    private static func logRequest(id: String, _ request: URLRequest) {
        guard let url = request.url else { return }
        
        var logContent = ["REQUEST(\(id)):"]
        
        logContent.append("\(request.httpMethod ?? "GET") \(url)")

        if let headers = request.allHTTPHeaderFields {
            logContent.append(" - Headers: \(headers)")
        }

        if let bodyData = request.httpBody, let body = String(data: bodyData, encoding: .utf8) {
            logContent.append(" - Body: \(body)")
        }

        logMessage(logContent.joined(separator: "\n"))
    }

    private static func logResponse(id: String, _ response: URLResponse?, data: Data?, error: Error?) {
        var logContent = ["RESPONSE(\(id)):"]
        
        if let httpResponse = response as? HTTPURLResponse {
            logContent.append(" - Status Code: \(httpResponse.statusCode)")
            logContent.append(" - Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let responseData = data, let body = String(data: responseData, encoding: .utf8) {
            logContent.append(" - Body: \(body)")
        }
        
        if let error = error {
            logContent.append(" - Error: \(error.localizedDescription)")
        }

        logMessage(logContent.joined(separator: "\n"))
    }
    
    @objc func swizzled_dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let id = UUID().uuidString
        
        URLSession.logRequest(id: id, request)
        
        return swizzled_dataTask(with: request) { data, response, error in
            URLSession.logResponse(id: id, response, data: data, error: error)
            
            completionHandler(data, response, error)
        }
    }
}
