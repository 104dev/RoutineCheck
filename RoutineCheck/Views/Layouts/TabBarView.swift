import SwiftUI

struct TabBarView: View {
        
    @EnvironmentObject var taskViewModel : TaskViewModel
    
    
    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
                .environmentObject(taskViewModel)
            LookForItemView()
                .tabItem {
                    Image(systemName: "clock.badge.checkmark")
                    Text("タスクと記録")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(TaskViewModel())
    }
}

