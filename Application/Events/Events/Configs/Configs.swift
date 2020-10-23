import Foundation
import UIKit



// No of events in home
let limitForRecentEventsQuery = 20


// EMAIL ADDRESS TO EDIT (To get submitted events notifications)
let SUBMISSION_EMAIL_ADDRESS = "submission@example.com"


// EMAIL ADDRESS TO EDIT (where users can directly contact you)
let CONTACT_EMAIL_ADDRESS = "info@example.com"


// EMAIL ADDRESS TO EDIT (where users can report inappropriate contents - accordingly to Apple EULA terms)
let REPORT_EMAIL_ADDRESS = "report@example.com"


// Color palette
let mainColor = UIColor(red: 63.0/255.0, green: 174.0/255.0, blue: 181.0/255.0, alpha: 1.0)

let red = UIColor(red: 237.0/255.0, green: 85.0/255.0, blue: 100.0/255.0, alpha: 1.0)
let orange = UIColor(red: 250.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0)
let yellow = UIColor(red: 255.0/255.0, green: 207.0/255.0, blue: 85.0/255.0, alpha: 1.0)
let lightGreen = UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0)
let mint = UIColor(red: 72.0/255.0, green: 207.0/255.0, blue: 174.0/255.0, alpha: 1.0)
let aqua = UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0)
let blueJeans = UIColor(red: 93.0/255.0, green: 155.0/255.0, blue: 236.0/255.0, alpha: 1.0)
let lavander = UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0)
let darkPurple = UIColor(red: 150.0/255.0, green: 123.0/255.0, blue: 220.0/255.0, alpha: 1.0)
let pink = UIColor(red: 236.0/255.0, green: 136.0/255.0, blue: 192.0/255.0, alpha: 1.0)
let darkRed = UIColor(red: 218.0/255.0, green: 69.0/255.0, blue: 83.0/255.0, alpha: 1.0)
let paleWhite = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 251.0/255.0, alpha: 1.0)
let lightGray = UIColor(red: 230.0/255.0, green: 233.0/255.0, blue: 238.0/255.0, alpha: 1.0)
let mediumGray = UIColor(red: 204.0/255.0, green: 208.0/255.0, blue: 217.0/255.0, alpha: 1.0)
let darkGray = UIColor(red: 67.0/255.0, green: 74.0/255.0, blue: 84.0/255.0, alpha: 1.0)
let brownLight = UIColor(red: 198.0/255.0, green: 156.0/255.0, blue: 109.0/255.0, alpha: 1.0)


// firestore collections
let COLLECTION_USERS  = "users"
let COLLECTION_EVENTS = "events"

let USER_TOKEN        = "token"
let USER_AUTH_TYPE    = "authType"
let USER_NAME         = "name"
let USER_EMAIL        = "email"
let USER_PROFILE      = "profileUrl"
let USER_PHOTO        = "photoUrl"

let EVENT_TITLE       = "title"
let EVENT_DESCRIPTION = "description"
let EVENT_LOCATION    = "location"
let EVENT_START_DATE  = "startDate"
let EVENT_END_DATE    = "endDate"
let EVENT_COST        = "cost"
let EVENT_WEBSITE     = "website"
let EVENT_IMAGE       = "image"
let EVENT_IS_PENDING  = "isPending"
let EVENT_KEYWARDS    = "keywards"
let EVENT_USER        = "user"
