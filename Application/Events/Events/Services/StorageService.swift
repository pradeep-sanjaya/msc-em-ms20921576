import UIKit
import FirebaseStorage

class StorageService {
        
    public func uploadFile(localFile: URL, serverFileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let directory = "uploads/"
        let fileRef = storageRef.child(directory + serverFileName)

        _ = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    public func uploadImageData(data: Data, directory: String, fileName: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let path = "\(directory)/"
        let fileRef = storageRef.child(path + fileName)
        
        _ = fileRef.putData(data, metadata: nil) { metadata, error in
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    public func uploadUserProfile(image: UIImage, token: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        if let data = image.pngData() {
            uploadImageData(data: data, directory: "users", fileName: "\(token).png") {
                (isSuccess, url) in
                completionHandler(isSuccess, url)
                print("uploadImageData: \(isSuccess), \(url)")
            }
        }
    }
    
    public func uploadEvent(image: UIImage, eventId: String, completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {
        if let data = image.pngData() {
            uploadImageData(data: data, directory: "events", fileName: "\(eventId).png") {
                (isSuccess, url) in
                completionHandler(isSuccess, url)
                print("uploadImageData: \(isSuccess), \(url)")
            }
        }
    }
    
    public func getImageByURLString(urlString: String, callback: @escaping (UIImage) -> Void)  {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let image = UIImage(data: data!) {
                    callback(image)
                }
            })

        }).resume()
    }
}

