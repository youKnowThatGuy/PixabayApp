//
//  NetworkService.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import Foundation

class NetworkService{
    private init(){}
                        
    static let shared = NetworkService()
    
    private let apiKey = "1121314"
    
    private var baseUrlComponent: URLComponents {
        var _urlComps = URLComponents(string: "https://pixabay.com")!
        _urlComps.path = "/api"
        _urlComps.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        return _urlComps
    }
    
    func fetchImages(amount: Int, completion: @escaping (Result<[ ImageInfo], SessionError>) -> Void){
        var urlComps = baseUrlComponent
        urlComps.queryItems? += [
        URLQueryItem(name: "per_page", value: "\(amount)"),
        URLQueryItem(name: "editors_choice", value: "\(true)")
        ]
        
        guard let url = urlComps.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidUrl))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            let response = response as! HTTPURLResponse
            
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse<ImageInfo>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(serverResponse.hits))
                }
            }
            catch let decodingError{
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
                
            }
            
        }.resume()
        
        
    }
}
