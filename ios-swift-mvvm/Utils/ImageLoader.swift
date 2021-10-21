//
//  ImageLoader.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping(Result<UIImage, Error>) -> Void) -> UUID? {
        
        // If the URL already exists in our in-memory cache,
        // we can call the completion handler inmediatly
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        // Create uuid instance to identify the data task
        let uuid = UUID()
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // defer keyword allows us to do something at the end of method
            // no mather how that method exists (catching an error or not)ç
            // -----
            // When the data task is completed, it should be removed from the
            // running tasks
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            // When the data task is completed and we can extract an image from it,
            // it is cached in the memory and the completion handler is called
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }

        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
}
