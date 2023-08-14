import SwiftUI


struct ContentView: View {
        
    @StateObject var taskViewModel = TaskViewModel()
    @StateObject var activityViewModel = ActivityViewModel()
    @StateObject var projectViewModel = ProjectViewModel()
    
    init(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: .alert) { granted, error in
            if granted {
                print("許可されました！")
            }else{
                print("拒否されました...")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                TabBarView()
            }
        }
        .environmentObject(taskViewModel)
        .environmentObject(activityViewModel)
        .environmentObject(projectViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

