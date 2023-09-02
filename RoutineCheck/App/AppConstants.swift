//

import Foundation

enum AppConstants {
    
    enum BulkInterval : String {
        case day = "毎日"
        case week = "1週間毎"
        case month =  "1ヶ月毎"
        
        var calendarComponent : Calendar.Component {
            switch self {
                
            case .day : return Calendar.Component.day
            case .week : return Calendar.Component.weekOfYear
            case.month : return Calendar.Component.month
                
            }
        }
    }
    
}
