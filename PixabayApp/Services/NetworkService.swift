//
//  NetworkService.swift
//  PixabayApp
//
//  Created by Клим on 07.12.2020.
//

import Foundation
import UIKit

class NetworkService{
    private init(){}
                        
    static let shared = NetworkService()
    
    private let apiKey = "19440141-7387445fd9a23cd1fb81f0f4b"
    
    private var baseUrlComponent: URLComponents {
        var _urlComps = URLComponents(string: "https://pixabay.com")!
        _urlComps.path = "/api"
        _urlComps.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        return _urlComps
    }
    
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void){
        guard let url = url else{
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data{
                    completion(UIImage(data: data))
                }
                else{
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func fetchImagesForSearch(query: String ,amount: Int, completion: @escaping (Result<[ ImageInfo], SessionError>) -> Void){
        /*
    var urlComps = baseUrlComponent
        urlComps.queryItems? += [
            URLQueryItem(name: "q", value: query)
        ]
    fetchImages(amount: amount, completion: completion)
         
 */
        var urlComps = baseUrlComponent
        urlComps.queryItems? += [
        URLQueryItem(name: "q", value: query),
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
