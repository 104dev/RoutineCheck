import SwiftUI


struct ActivityEditView: View {
    
    @Binding var isModalPresented: Bool
    @Binding var isFloatBtnSelected: Bool
    let project: Project?
    let task: Task?
    let activity: Activity?
    @State private var taskUUID: UUID?
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var expiredDate = Date()
    
    @EnvironmentObject var activityViewModel : ActivityViewModel

    var body: some View {
        VStack{
            TextField("タイトルを記入", text: $title)
                .padding()
                .font(.title)
            TextEditor(text: $desc)
                .padding()
            HStack {
                Button("キャンセル", action: {
                    isModalPresented = false
                })
                .padding()
                Button("保存", action: {
                    saveActivity()
                })
                .padding()
            }
        }
        .background(Color(.systemGray6))
        .onAppear {
            setupInitialValues()
        }
    }
    
    private func setupInitialValues() {
            guard let activity = activity else { return }
            title = activity.name ?? ""
            desc = activity.desc ?? ""
    }
    
    private func saveActivity() {
          guard let activity = activity else {
              activityViewModel.createActivity(
                  name: title,
                  desc: desc,
                  project: project,
                  task: task
              )
              isModalPresented = false
              isFloatBtnSelected = false
              return
          }

          activityViewModel.updateActivity(
              uuid: activity.id!,
              name: title,
              desc: desc
          )
          isModalPresented = false
         isFloatBtnSelected = false
      }
}

