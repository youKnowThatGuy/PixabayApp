//
//  CacheManager.swift
//  PixabayApp
//
//  Created by Клим on 16.12.2020.
//

import Foundation
import UIKit

class CacheManager{
    private init() {}
    static let shared = CacheManager()
    
    private let imagesLimit = 100
    private let fileManager = FileManager.default
    
    func cacheImage(_ image: UIImage?, with id: Int, completion: ((Bool)-> Void)? = nil){
        DispatchQueue.global(qos: .utility).async { [self] in
        
        guard let image = image,
              let data = image.pngData() else{
            completion?(false)
            return
        }
        let imageUrl = getCachesDirectory().appendingPathComponent("\(id).png")
        
        guard !fileManager.fileExists(atPath: imageUrl.path) else{
            completion?(true)
            return
        }
        
        var savedPaths = getCachedImagePaths()
        while savedPaths.count  >= imagesLimit{
            _ = tryDeleteImage(path: savedPaths.first!)
            savedPaths.remove(at: savedPaths.startIndex)
        }
        
        do{
            try data.write(to: imageUrl)
            print("image was saved to \(imageUrl)")
            completion?(true)
        }
        catch {
            print(error)
            completion?(false)
        }
        }
    }
    
    
    func cacheSearches(_ dataForjson: String?, completion: ((Bool)-> Void)? = nil){
        DispatchQueue.global(qos: .utility).async { [self] in
        
        guard let data = dataForjson else{
            completion?(false)
            return
        }
      let jsonUrl = getServicesDirectory().appendingPathComponent("searchHistory.json")
        
       
        
        do{
            try data.write(to: jsonUrl, atomically: true, encoding: .utf8)
            print("image was saved to \(jsonUrl)")
            completion?(true)
        }
        catch {
            print(error)
            completion?(false)
        }
        }
    }
    
    func getSearches(completion: @escaping (String) -> Void){
        let jsonUrl = getServicesDirectory().appendingPathComponent("searchHistory.json")
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let data = self.fileManager.contents(atPath: jsonUrl.path),
               let string = String(data: data, encoding: .utf8){
            
            
            DispatchQueue.main.async {
        completion(string)
            }
            }
        }
    }
    
    
    
    func getImage(with id: Int, completion: @escaping (UIImage?) -> Void){
        let imageUrl = getCachesDirectory().appendingPathComponent("\(id).png")
        DispatchQueue.global(qos: .userInteractive).async {
            
            let image = self.getImage(from: imageUrl.path)
            DispatchQueue.main.async {
        completion(image)
            }
        }
    }
    
    
    
    func getImage(from path: String)-> UIImage?{
        //print(path)
        if let data = fileManager.contents(atPath: path),
           let image = UIImage(data: data){
            return image
        }
        return nil
    }
    
    
    func getCachedImages(completion: @escaping ([UIImage])-> Void){
        DispatchQueue.global().async { [self] in
            
        var images = [UIImage]()
        let imagePaths = getCachedImagePaths()
        for path in imagePaths{
            if let image = getImage(from: path){
                images.append(image)
            }
        }
            DispatchQueue.main.async {
            completion(images)
            }
        }
    }
    
    
    
    func tryDeleteImage(path: String)-> Bool{
        do{
            try fileManager.removeItem(atPath: path)
            return true
        }
        catch{
            return false
        }
    }
    
    
    
    private func getCachedImagePaths()-> [String]{
        do{
            let paths = try fileManager.contentsOfDirectory(atPath: getCachesDirectory().path)
            return paths.map{getCachesDirectory().appendingPathComponent($0).path}
        }
        catch{
            return []
        }
    }
    
    
        
        private func getCachesDirectory()-> URL{
            let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CachedImages")
            
            if !fileManager.fileExists(atPath: url.path){
                try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            return url
        }
        
    
    private func getServicesDirectory()-> URL{
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CachedServices")
        
        if !fileManager.fileExists(atPath: url.path){
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }

    
    
}
