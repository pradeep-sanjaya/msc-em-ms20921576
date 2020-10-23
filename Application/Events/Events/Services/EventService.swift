import Foundation
import UIKit
import Firebase
import FirebaseStorage

class EventService {

    let rootRef = Database.database().reference()
    let userService = UserService()
    let storageService = StorageService()
    
    func create(event: Event, image: UIImage?)  {
        let localUser = self.userService.getLocalUser()
        
        let eventRef = self.rootRef.child(COLLECTION_EVENTS)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let firebaseEvent: [String: String] = [
            EVENT_TITLE: event.title,
            EVENT_LOCATION: event.location,
            EVENT_DESCRIPTION: event.description,
            EVENT_START_DATE: formatter.string(from: event.startDate),
            EVENT_END_DATE: formatter.string(from: event.endDate),
            EVENT_COST: event.cost,
            EVENT_WEBSITE: event.website,
            EVENT_IMAGE: event.image,
            EVENT_IS_PENDING: event.isPending.description,
            EVENT_KEYWARDS: "",
            EVENT_USER: localUser.token,
        ]

        eventRef.childByAutoId().setValue(firebaseEvent) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                print("----- reference : \(ref) -------")
            } else {
                print("key: \(ref.key)")
                
                if let providedImage = image {
                    print(providedImage)
                    self.storageService.uploadEvent(image: providedImage, eventId: ref.key!) {
                        (status, url) in
                        print("---- url: \(url) ----")
                        
                        eventRef.child("\(ref.key!)").updateChildValues(["image": url])

                    }
                }
                
            }
        }

    }
}
