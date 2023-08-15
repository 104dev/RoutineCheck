import SwiftUI

struct TimelineView: View {
    
    @State private var selectedDate = Date()
    @State  var isPresented : Bool = false
    @EnvironmentObject var taskViewModel : TaskViewModel
    
    var body: some View {
        VStack{
            NavigationStack{
                VStack{
                    CalendarView(selectedDate: $selectedDate)
                    List {
                        if !taskViewModel.tasks.isEmpty{
                            ForEach(taskViewModel.tasks, id: \.self) { task in
                                Button {
                                    isPresented.toggle()
                                } label: {
                                    TaskCardView(task: task)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.black)
                                }.navigationDestination(isPresented: $isPresented){
                                    TaskDetailView(task: task)
                                }
                            }.listRowInsets(EdgeInsets())
                        } else {
                            Text("関連づけられたタスクがありません")
                        }
                    }
                    .frame( maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(GroupedListStyle())
                }
            }
            .onChange(of: selectedDate) { newDate in
                                   taskViewModel.fetchTasks(forDate: newDate)
            }
            .onAppear(){
                taskViewModel.fetchTasks(forDate: selectedDate)
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
