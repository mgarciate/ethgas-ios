//
//  NetworkService.swift
//  wsanjusto-ios
//
//  Created by mgarciate on 12/6/22.
//

import Foundation

class NetworkService<T> where T: Codable {
    enum ApiError: Error {
        case missingURL
        case badResponse
        case parsingError
    }
    private let urlSession: URLSession
    private let baseURL: String
    
    init() {
        urlSession = URLSession.shared
        baseURL = "https://ethgas.tedejo.es/api/v2"
    }
    
    func get(endpoint: String) async throws -> T {
        guard let url = URL(string: [baseURL, endpoint].joined(separator: "/")) else { throw ApiError.missingURL }
        let urlRequest = URLRequest(url: url)
        let data: Data
        let response: URLResponse
        if #available(iOSApplicationExtension 15.0, watchOSApplicationExtension 8.0, *) {
            (data, response) = try await urlSession.data(for: urlRequest)
        } else {
            (data, response) = try await urlSession.compatibilityData(from: url)
        }
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiError.badResponse }
        do{
            let _ = try JSONDecoder().decode(T.self, from: data)
        }catch{
            print(error)
        }
        guard let element = try? JSONDecoder().decode(T.self, from: data) else { throw ApiError.parsingError }
        return element
    }
}

extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    @available(watchOS, deprecated: 8.0, message: "This extension is no longer necessary. Use API built into SDK")
    func compatibilityData(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
