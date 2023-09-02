//

import Foundation

enum AppConstants {
    
    enum BulkInterval {
        case day
        case week
        case month
        
        var calendarComponent : Calendar.Component {
            switch self {
                
            case .day : return Calendar.Component.day
            case .week : return Calendar.Component.weekOfYear
            case.month : return Calendar.Component.month
                
            }
        }
    }
    
}
