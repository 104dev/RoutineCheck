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
    
    enum TaskStatus : String {
        case scheduled = "予定"
        case abandoned = "断念"
        case completed = "完了"
        
        var taskStatusValue : String {
            switch self {
                case .scheduled : return "scheduled"
                case .abandoned : return "abandoned"
                case .completed : return "completed"
            }
        }
    }
    
}
