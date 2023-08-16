import SwiftUI


struct ContentView: View {
        
    @StateObject var taskViewModel = TaskViewModel()
    @StateObject var activityViewModel = ActivityViewModel()
    @StateObject var projectViewModel = ProjectViewModel()
    @State private var showExpiredTaskAlert = false
    @State private var expiredTaskAlertMessage = ""
        
    var body: some View {
        NavigationStack {
            VStack{
                TabBarView()
            }
        }
        .alert(isPresented: $showExpiredTaskAlert) {
            Alert(title: Text("タスクの期限切れ"),
                  message: Text(expiredTaskAlertMessage),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear(){
            var expiredTaskCount = taskViewModel.expiredTasksToAbondone()
            if expiredTaskCount != 0 {
                expiredTaskAlertMessage = "\(expiredTaskCount)件のタスクが期限切れとなりました。"
                    showExpiredTaskAlert = true
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

