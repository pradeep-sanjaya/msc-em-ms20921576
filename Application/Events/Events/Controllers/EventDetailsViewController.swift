import UIKit
import Parse
import EventKit
import MapKit
import MessageUI
import AudioToolbox


class EventDetailsViewController: UIViewController,
    MKMapViewDelegate,
    MFMailComposeViewControllerDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var descrTxt: UITextView!
    
    @IBOutlet var detailsView: UIView!
    @IBOutlet var addToCalOutlet: UIButton!
    @IBOutlet var shareOutlet: UIButton!
    
    @IBOutlet var dayNrLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var registerOutlet: UIButton!
    
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var backButt = UIButton()
    var reportButt = UIButton()
    

    /* Variables */
    var eventObj:Event!
    
    // For the Map
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearch.Request!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearch.Response!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    
    
    
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Back BarButton Item
        backButt = UIButton(type: .custom)
        backButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButt.setBackgroundImage(UIImage(named: "backButt"), for: .normal)
        backButt.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButt)
        
        // Report Event BarButton Item
        reportButt = UIButton(type: .custom)
        reportButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        reportButt.setBackgroundImage(UIImage(named: "reportButt"), for: .normal)
        reportButt.addTarget(self, action: #selector(reportButton(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reportButt)
        
        // get event title
        self.title = "\(eventObj!.title)"
        
        // get event image
        if let imageUrl = eventObj?.image {
            let url = URL(string: imageUrl)
            self.eventImage.kf.setImage(with: url)
        }
        
        // event description
        descrTxt.text = "\(eventObj.description)"
        descrTxt.sizeToFit()
        
        
        // GET EVENT'S START DATE (for the labels on the left side of the event's image)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayStr = dayFormatter.string(from: eventObj.startDate as! Date)
        dayNrLabel.text = dayStr
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let monthStr = monthFormatter.string(from: eventObj.startDate as! Date)
        monthLabel.text = monthStr
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearStr = yearFormatter.string(from: eventObj.startDate as! Date)
        yearLabel.text = yearStr
        
        
        // GET EVENT START AND END DATES & TIME
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let startDateStr = startDateFormatter.string(from: (eventObj.startDate as! Date)).uppercased()
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let endDateStr = endDateFormatter.string(from: (eventObj.endDate as! Date)).uppercased()
        
        startDateLabel.text = "Start Date: \(startDateStr)"
        if endDateStr != "" {
            endDateLabel.text = "End Date: \(endDateStr)"
        } else {
            endDateLabel.text = ""
        }
        
        
        // dissable add to calendar if event is expired
        let currentDate = Date()
        if currentDate > eventObj.endDate as! Date {
            addToCalOutlet.isEnabled = false
            addToCalOutlet.backgroundColor = mediumGray
            addToCalOutlet.setTitle("This event has passed", for: .normal)
            
            registerOutlet.isEnabled = false
            registerOutlet.backgroundColor = mediumGray
            registerOutlet.setTitle("EVENT PASSED", for: .normal)
        }
        
        
        // event cost
        costLabel.text = "Cost: \(eventObj.cost)".uppercased()
        
        // event website
        if eventObj.website != nil {
            websiteLabel.text = "Website: \(eventObj.website)"
        } else {  websiteLabel.text = ""  }
        
        // event location
        locationLabel.text = "\(eventObj.location)".uppercased()
        addPinOnMap(locationLabel.text!.lowercased())
        
        
        // move add to calendar button below description
        detailsView.frame.origin.y = descrTxt.frame.origin.y + descrTxt.frame.size.height + 10
        
        // resize scrollview container
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width,
                                                 height: detailsView.frame.origin.y + detailsView.frame.size.height)
        
    }
    
    
    
    
    
    // MARK: - Add a pin on map view
    func addPinOnMap(_ address: String) {
        mapView.delegate = self
        
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
        }
        
        // Make a search on the Map
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start {
            (localSearchResponse, error) -> Void in
            
            // Add PointAnnonation text and a Pin to the Map
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = "\(self.eventObj.title)".uppercased()
            self.pointAnnotation.coordinate = CLLocationCoordinate2D( latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinView.annotation!)
            
            // Zoom the Map to the location
            self.region = MKCoordinateRegion(center: self.pointAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
            self.mapView.setRegion(self.region, animated: true)
            self.mapView.regionThatFits(self.region)
            self.mapView.reloadInputViews()
        }
    }
    
    // MARK: - Pin anotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKPointAnnotation.self) {
            
            let reuseID = "CustomPinAnnotationView"
            var annotView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            
            if annotView == nil {
                annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                annotView!.canShowCallout = true
                
                // Custom Pin image
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                imageView.image =  UIImage(named: "locIcon")
                imageView.center = annotView!.center
                imageView.contentMode = UIView.ContentMode.scaleAspectFill
                annotView!.addSubview(imageView)
                
                // Add a RIGHT Callout Accessory
                let rightButton = UIButton(type: UIButton.ButtonType.custom)
                rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
                rightButton.clipsToBounds = true
                rightButton.setImage(UIImage(named: "openInMaps"), for: UIControl.State())
                annotView!.rightCalloutAccessoryView = rightButton
            }
            
            return annotView
        }
        
        return nil
    }
    
    
    // MARK: -  Open iOS maps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        annotation = view.annotation
        let coordinate = annotation.coordinate
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        mapitem.name = annotation.title!
        mapitem.openInMaps(launchOptions: nil)
    }
    
    
    
    
    // MARK: - Add event to iOS calendar
    @IBAction func addToCalButt(_ sender: AnyObject) {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
            
            case .authorized:
                insertEvent(eventStore)
            case .denied:
                print("Access denied")
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion: {
                    (granted, error) -> Void in
                    if granted {
                        self.insertEvent(eventStore)
                    } else {
                        print("Access denied")
                    }
                })
                
            default:
                print("case default")
        }
    }
    
    
    func insertEvent(_ store: EKEventStore) {
        
        let calendars = store.calendars(for: EKEntityType.event)
        
        for calendar in calendars {
            
            if calendar.title == "Calendar" {
                // Get Start and End dates
                let startDate = eventObj.startDate as! Date
                let endDate = eventObj.endDate as! Date
                
                
                // Create Event
                let event = EKEvent(eventStore: store)
                event.title = "\(eventObj.title)"
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = calendar
                
                // Save Event in Calendar
                do {
                    try store.save(event, span: .thisEvent)
                    simpleAlert("This event is already in your calendar")
                    
                    // error
                } catch {
                    print("ERROR SAVING EVENT TO CAL: \(error)")
                }
                
                print("start: \(startDate) \nend: \(endDate)")
                
            } else {
                self.simpleAlert("You should go into the Calendar app and add a default calendar called 'Calendar'")
            }
        }
        
    }




    // MARK: - Share an event
    @IBAction func shareButt(_ sender: AnyObject) {
        
        let message  = "Check out this Event: \(eventObj.title) on #\(Bundle.appName())"
        let shareItems = [message, eventImage.image!] as [Any]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            let popOver = UIPopoverController(contentViewController: activityViewController)
            
            popOver.present(from: CGRect.zero, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        } else {
            // iPhone
            present(activityViewController, animated: true, completion: nil)
        }
    }



    // MARK: - Open event link
    @IBAction func openLinkButt(_ sender: AnyObject) {
        let webURL = URL(string: "\(eventObj.website)")
        UIApplication.shared.openURL(webURL!)
    }
    
    
    // MARK: - Register in event
    @IBAction func registerButt(_ sender: AnyObject) {
        if let webURL = URL(string: "\(eventObj.website)") {
            UIApplication.shared.openURL(webURL)
        }
    }
    
    
    
    // MARK: - Report inappropriate contents button
    @objc func reportButton(_ sender: UIButton) {
        
        // This string containes standard HTML tags, you can edit them as you wish
        let messageStr = "<font size = '1' color= '#222222' style = 'font-family: 'HelveticaNeue'>Hello,<br>Please check the following Event since it seems it contains inappropriate/offensive contents:<br><br>Event Title: <strong>\(eventObj.title)</strong><br>Event ID: <strong>\(eventObj.id)</strong><br><br>Thanks,<br>Regards.</font>"
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject("NIBM Events - Inappropriate contents on an event")
        mailComposer.setMessageBody(messageStr, isHTML: true)
        mailComposer.setToRecipients([REPORT_EMAIL_ADDRESS])
        
        if MFMailComposeViewController.canSendMail() {
            present(mailComposer, animated: true, completion: nil)
        } else {
            simpleAlert("Please configure an email address into Settings -> Mail, Contacts, Calendars.")
        }
    }

    // Email delegate
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        var resultMess = ""
        switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                resultMess = "Mail cancelled"
            case MFMailComposeResult.saved.rawValue:
                resultMess = "Mail saved"
            case MFMailComposeResult.sent.rawValue:
                resultMess = "Mail sent!"
            case MFMailComposeResult.failed.rawValue:
                resultMess = "Something went wrong with sending Mail, try again later."
            default:
                break
        }
        
        simpleAlert(resultMess)
        
        dismiss(animated: false, completion: nil)
    }




    // MARK: - Back button
    @objc func backButton(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
