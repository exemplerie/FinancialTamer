import SwiftUI

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case urlError
    case invalidResponse(Int)
    case decodingError
    case encodingError(Error)
    case other(Error)
}

class NetworkClient {
    private let baseURL: URL
    private let session: URLSession
    private var token: String = NetworkConstans.token
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.baseURL = URL(string: NetworkConstans.baseURLString)!
        self.session = .shared
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()
    }
    
    func request<Request: Encodable, Response: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Request? = nil,
        responseType: Response.Type) async throws -> Response {
            guard let url = URL(string: endpoint, relativeTo: baseURL) else {
                throw NetworkError.urlError
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let requestBody = body {
                do {
                    request.httpBody = try jsonEncoder.encode(requestBody)
                } catch {
                    throw NetworkError.encodingError(error)
                }
            }
            
            do {
                let (data, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(-1)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse(httpResponse.statusCode)
                }
                
                do {
                    return try jsonDecoder.decode(Response.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            } catch {
                throw NetworkError.other(error)
            }
        }
    
    func request<Response: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        responseType: Response.Type) async throws -> Response {
            guard let url = URL(string: endpoint, relativeTo: baseURL) else {
                throw NetworkError.urlError
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(-1)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse(httpResponse.statusCode)
                }
                
                do {
                    return try jsonDecoder.decode(Response.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            } catch {
                throw NetworkError.other(error)
            }
        }
    
    func request(
        endpoint: String,
        method: HTTPMethod = .delete
    ) async throws {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(-1)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(httpResponse.statusCode)
            }
            
        } catch {
            throw NetworkError.other(error)
        }
    }
    
}
