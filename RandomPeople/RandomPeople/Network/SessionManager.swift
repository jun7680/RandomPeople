//
//  SessionManager.swift
//  RandomPeople
//
//  Created by 옥인준 on 2023/01/30.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error {
    case urlNotFound
    case decodingError
    case responseError
}
class SessionManger {
    
    static let shared = SessionManger()
    
    func request<T: Codable>(_: T.Type, apiType: APIType) -> Single<T> {
        guard let components = urlComponents(apiType: apiType),
              let url = components.url
        else { return .error(NetworkError.urlNotFound) }
        
        return Single.create { single in
            AF.request(url).responseData { result in
                
                switch result.result {
                case let .success(data):
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        
                        return single(.success(response))
                    } catch {
                        print(error)
                        return single(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    return single(.failure(NetworkError.responseError))
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func urlComponents(apiType: APIType) -> URLComponents? {
        var url = apiType.baseURL.appendingPathComponent(apiType.path).absoluteString
        
        let queryItems = apiType.params.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        if !queryItems.isEmpty {
            url += "?"
        }
        
        var components = URLComponents(string: url)
        components?.queryItems?.append(contentsOf: queryItems)
        
        return components
    }
}
