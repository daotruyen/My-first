//
//  ImageExtension.swift
//  Weather
//
//  Created by Tuyen on 23/06/2021.
//

import UIKit
let imageCache = NSCache<AnyObject,AnyObject>()
let cachedImages = NSCache<NSString, UIImage>()
extension UIImageView{
    func loadImage(url:String){
        self.image = nil
        guard let URL = URL(string:url) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL){
                if let image = UIImage(data:data){
                    let imageToCache = image
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    DispatchQueue.main.async {
                        self?.image = imageToCache
                    }
                }
            }
        }
        
    }
    func loadImageUsingCacheWithUrlString(urlString:String) {
        
        self.image = nil
    
        //Check cache for image first
        if let cacheImage = cachedImages.object(forKey: urlString as NSString)  {
            self.image = cacheImage
            return
        }
        
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data:data!){
                    cachedImages.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        })
        task.resume()
    }
}


