//

import Foundation

enum AppConstants {
    
    enum BulkInterval : String {
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
        
        var text : String {
            switch self {
            case .day : return "毎日"
            case .week : return "1週間毎"
            case .month : return "1ヶ月毎"
            }
        }
    }
    
    enum TaskStatus : String {
        case scheduled = "scheduled"
        case abandoned = "abandoned"
        case completed = "completed"
        
        var text : String {
            switch self {
                case .scheduled : return "予定"
                case .abandoned : return "断念"
                case .completed : return "完了"
            }
        }
    }
    
    enum calendarViewType: String, CaseIterable, Identifiable {
        case monthly = "月"
        case weekly = "週"
        
        var id: String { rawValue }
    }
    
}
