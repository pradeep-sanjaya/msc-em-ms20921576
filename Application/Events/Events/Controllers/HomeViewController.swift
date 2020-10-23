import UIKit
import Parse
import AudioToolbox
import Kingfisher
import Firebase


protocol ProfileButtonsDelegate {
    func profileTapped(at index:IndexPath)
}

class EventCell: UICollectionViewCell {
    
    var delegate:ProfileButtonsDelegate!
    var indexPath:IndexPath!

    /* Views */
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var dayNrLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    
    @IBAction func profileTapAction(_ sender: Any) {
        self.delegate?.profileTapped(at: indexPath)
    }
    
}


class HomeViewController: BaseViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate,
    ProfileButtonsDelegate
{
    
    /* Views */
    @IBOutlet var eventsCollView: UICollectionView!
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTxt: UITextField!
    
    @IBOutlet weak var searchOutlet: UIBarButtonItem!
    
    /* Variables */
    var eventsArray = [Event]() {
        didSet {
            self.eventsCollView.reloadData()
        }
    }
    var cellSize = CGSize()
    var searchViewIsVisible = false
    
    let rootRef = Database.database().reference()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set size of the event cells
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            cellSize = CGSize(width: view.frame.size.width-30, height: 270)
        } else  {
            // iPad
            cellSize = CGSize(width: 350, height: 270)
        }
        
        
        // Search View initial setup
        searchView.frame.origin.y = -searchView.frame.size.height
        searchView.layer.cornerRadius = 10
        searchViewIsVisible = false
        searchTxt.resignFirstResponder()
        
        // Set placeholder's color and text for Search text fields
        searchTxt.attributedPlaceholder = NSAttributedString(string: "Type an event name (or leave it blank)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
        
        navigationController?.hidesBarsWhenKeyboardAppears = false

        
        // Call a Parse query
        queryLatestEvents()
    }
    
    
    
    // MARK: - Get latest events
    func queryLatestEvents() {
        showHUD()
        self.eventsArray.removeAll()
        
        let eventRef = self.rootRef.child(COLLECTION_EVENTS)
        
        eventRef.observe(.childAdded, with: {
            (snapshot) -> Void in
            
            //print("key: \(snapshot.key)")
            
            let eventDict = snapshot.value as? [String : AnyObject] ?? [:]

            var start = Date()
            var end = Date()
            var isPending = false
            
            if let startDate = eventDict["startDate"] as? String {
                start = startDate.toDate()
            }
            
            if let endDate = eventDict["endDate"] as? String {
                end = endDate.toDate()
            }
            
            if let boolString = eventDict["isPending"] as? String {
                isPending = boolString.bool!
            }
            
            let event = Event(
                id: "\(snapshot.key)",
                title: eventDict["title"] as? String ?? "",
                location: eventDict["location"] as? String ?? "",
                description: eventDict["description"] as? String ?? "",
                website: eventDict["website"] as? String ?? "",
                startDate: start,
                endDate: end,
                cost: eventDict["cost"] as? String ?? "",
                image: eventDict["image"] as? String ?? "",
                isPending: isPending,
                keywords: eventDict["keywards"] as? String ?? "",
                user: eventDict["user"] as? String ?? ""
            )
            
            self.eventsArray.append(event)
            self.hideHUD()
            
            //print(self.eventsArray)
        })
        
        self.hideHUD()
        
        /*
        self.eventsArray = [
            Event(
                id: "1",
                title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                location: "Vidya Mawatha, Colombo 07",
                description: "Praesent convallis aliquam tincidunt. Maecenas porta ullamcorper arcu, nec tempus magna pulvinar ac.", website: "",
                startDate: DateUtils.addDates(to: Date(), days: 5)!,
                endDate: DateUtils.addDates(to: Date(), days: 7)!,
                cost: "Free",
                image: "https://previews.123rf.com/images/jiadt/jiadt1911/jiadt191100007/133455623-reflection-of-riverside-city-and-cruise-ship.jpg",
                isPending: false,
                keywords: "nibm",
                user: "rQKfZY5UfcPjIBHqrZvRLYOqdii2"
            ),
            Event(
                id: "2",
                title: "Proin bibendum erat nec nisl vestibulum laoreet.",
                location: "NIBM",
                description: "Nulla pharetra consectetur felis. Pellentesque semper id neque quis ultricies.", website: "",
                startDate: Date(),
                endDate: Date(),
                cost: "Free",
                image: "https://previews.123rf.com/images/jiadt/jiadt1911/jiadt191100007/133455623-reflection-of-riverside-city-and-cruise-ship.jpg",
                isPending: false,
                keywords: "nibm",
                user: "rQKfZY5UfcPjIBHqrZvRLYOqdii2"
            )
        ]
        */
        
    }
    
    // MARK: -  COLLECTION VIEW DELEGATES
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let event = eventsArray[indexPath.row]
        //print(event)
        
        let url = URL(string: event.image)
        cell.eventImage.kf.setImage(with: url)
                
        self.userService.getUser(token: event.user) {
            (user:User?) in
            if let postUser = user {
                let profileUrl = URL(string: postUser.photoUrl)
                cell.profileImage.kf.setImage(with: profileUrl)
            }
        }
        
        // get event start date (for the labels on the left side of the event's image)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayStr = dayFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.dayNrLabel.text = dayStr
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let monthStr = monthFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.monthLabel.text = monthStr
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearStr = yearFormatter.string(from: eventsArray[indexPath.row].startDate as! Date)
        cell.yearLabel.text = yearStr
        
        
        // get event title
        cell.titleLbl.text = "\(event.title)".uppercased()
        
        // get event location
        cell.locationLabel.text = "\(event.location)".uppercased()

        // Get event start date, end date and time
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let startDateStr = startDateFormatter.string(from: event.startDate as! Date).uppercased()
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "MMM dd @hh:mm a"
        let endDateStr = endDateFormatter.string(from: event.endDate as! Date).uppercased()
        
        if startDateStr == endDateStr {  cell.timeLabel.text = startDateStr
        } else {  cell.timeLabel.text = "\(startDateStr) - \(endDateStr)"
        }
        
        // get event cost
        cell.costLabel.text = event.cost.uppercased()
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    
    func profileTapped(at index: IndexPath) {
         print("profile tapped at index:\(index)")
        
        let userViewController = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        
        let event = eventsArray[index.row]
        print(event)
        userViewController.userToken = event.user
        
        navigationController?.pushViewController(userViewController, animated: true)
    }
    
    // MARK: - Tap a cell to open event details view controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let event = eventsArray[indexPath.row]
        
        hideSearchView()
        
        let eventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetails") as! EventDetailsViewController
        eventDetailsViewController.eventObj = event
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
        
    }
    
    
    
    
    
    
    // MARK: - Search events button
    @IBAction func searchButt(_ sender: AnyObject) {
        searchViewIsVisible = !searchViewIsVisible
        
        if searchViewIsVisible {
            showSearchView()
        } else {
            hideSearchView()
        }
    }
    
    
    // MARK: - Textfield deligate (tap Search on the keyboard to launch a search query) */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchView()
        showHUD()

        // Make a new Parse query
        eventsArray.removeAll()
        let keywords = searchTxt.text!.lowercased().components(separatedBy: " ")
        print("\(keywords)")

        self.queryLatestEvents()
        
//        let query = PFQuery(className: EVENTS_CLASS_NAME)
//        if searchTxt.text != ""   { query.whereKey(EVENTS_KEYWORDS, containedIn: keywords) }
//        query.whereKey(EVENTS_IS_PENDING, equalTo: false)


        return true
    }
    
    
    
    
    // MARK: - Show/Hide search view
    func showSearchView() {
        searchTxt.becomeFirstResponder()
        searchTxt.text = ""
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
            self.searchView.frame.origin.y = 64
        }, completion: { (finished: Bool) in })
    }
    
    func hideSearchView() {
        searchTxt.resignFirstResponder()
        searchViewIsVisible = false
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.searchView.frame.origin.y = -self.searchView.frame.size.height
        }, completion: { (finished: Bool) in })
    }
    
    // MARK: - Refresh button
    @IBAction func refreshButt(_ sender: AnyObject) {
        queryLatestEvents()
        searchTxt.resignFirstResponder()
        hideSearchView()
        searchViewIsVisible = false
        
        //self.title = "Recent Events"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
