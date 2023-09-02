import SwiftUI


struct CalendarView: View {
        
    @Binding var selectedDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack(spacing: 35) {
            let days = ["日", "月", "火", "水", "木", "金", "土"]
            
            HStack(spacing: 20) {
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                Spacer()
                
                HStack(alignment: .top, spacing: 10){
                    Text(extraDate()[1])
                        .font(.title.bold())
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                
                
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "日" ? Color.red : (day == "土" ? Color.blue : nil))
                }
            }
            
            //Date
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color.blue)
                                .opacity(isSameDay(date1: value.date, date2: selectedDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            selectedDate = value.date
                        }
                }
                
            }
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            selectedDate = getCurrentMonth()
        }
        .padding(.top, 20)
    }
    
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                VStack(spacing: 1){
                    Text("\(value.day)")
                        .font(isSameDay(date1: value.date, date2: selectedDate) ? .title3.bold() : .title3)
                        .foregroundColor(isSameDay(date1: value.date , date2: selectedDate) ? .white : .primary)
                        .frame(width: 40)
                        .padding(.bottom, 0)
                    if TaskViewModel().hasTaskForDate(value.date){
                        Circle()
                            .fill(isSameDay(date1: value.date, date2: selectedDate) ? .white : .blue )
                            .frame(width: 5, height: 5)
                            .padding(.top, 0)
                    }
                }                     .padding(.top,2)
                
            }
        }
        .padding(.vertical, 1)
        .frame(height: 40, alignment: .top)
        
    }
    // Checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        return Calendar.current.isDate(date1, inSameDayAs: date2)
        
    }
    
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: selectedDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        // Getting Current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            let dateValue =  DateValue(day: day, date: date)
            return dateValue
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedDate: .constant(Date()))
    }
}

extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // geting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
        
    }
    
    
}

