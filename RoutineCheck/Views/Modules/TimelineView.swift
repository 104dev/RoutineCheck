import SwiftUI

struct TimelineView: View {
    
    @State private var selectedDate = Date()
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    
    var body: some View {
        VStack{
            NavigationStack{
                VStack{
                    CalendarView(selectedDate: $selectedDate)
                    List(taskViewModel.tasks, id: \.self) { task in
                        NavigationLink(destination: TaskDetailView(task: task)){
                            Text(task.name ?? "NoTitle")
                                .padding(.vertical,10)
                        }
                    }
                }
            }
            .onAppear(){
                taskViewModel.fetchTasks(forDate: selectedDate)
            }
            .onChange(of: selectedDate) { newDate in
                        taskViewModel.fetchTasks(forDate: newDate)
                        print("Value changed to \(newDate)")
            }
            Spacer()
        }
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView().environmentObject(TaskViewModel())
    }
}
