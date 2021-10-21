//
//  NetworkRequester.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import Foundation

struct NetworkRequester {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func requestService<T: Decodable>(request: NetworkRequest, completion: @escaping(Result<T, Error>) -> Void) {
        session.dataTask(with: request.request, completionHandler: { data, response, requestError in
            
            if let requestError = requestError {
                completion(.failure(requestError))
                return
            }
            
            guard let dataResponse = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let mappedResource = try mapResponse(data: dataResponse, dataType: T.self)
                completion(.success(mappedResource))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }).resume()
    }
    
    private func mapResponse<T: Decodable>(data: Data, dataType: T.Type) throws -> T {
        let decoder: JSONDecoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
