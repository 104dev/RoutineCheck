import SwiftUI


struct TaskEditView: View {

    //親ビューに関係する情報
    @Binding var isModalPresented: Bool
    @Binding var isFloatBtnSelected: Bool
    //タスクの情報に関わる情報
    @State var id: UUID?
    @State var title: String = ""
    @State var desc: String = ""
    @State var startDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()), minute: 0, second: 0, of: Date()) ?? Date()
    @State var endDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date()) ?? Date()
    @State var expiredDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    @State var status : String = AppConstants.TaskStatus.scheduled.rawValue
    @State var project: Project? = nil
    @State var task: Task?
    //一括作成に関わる情報
    @State private var bulkTaskCount: Int = 0
    @State private var showBulkIntervalSelection: Bool = false
    @State private var bulkInterval: AppConstants.BulkInterval = .day
    
    @EnvironmentObject var taskViewModel : TaskViewModel

    var body: some View {
            VStack{                    
                    TextField("タイトルを記入", text: $title)
                        .padding()
                        .font(.title)
                    TextEditor(text: $desc)
                        .padding()
                    List{
                        Section{
                            Picker("ステータス", selection: $status){
                                Text(AppConstants.TaskStatus.scheduled.text).tag(AppConstants.TaskStatus.scheduled.rawValue)
                                Text(AppConstants.TaskStatus.completed.text).tag(AppConstants.TaskStatus.completed.rawValue)
                                Text(AppConstants.TaskStatus.abandoned.text).tag(AppConstants.TaskStatus.abandoned.rawValue)
                            }.onChange(of: status) { newValue in
                                print("Selected option changed to: \(newValue)")
                            }
                            DatePicker("実行開始", selection: $startDate, in: ...endDate, displayedComponents: [.date, .hourAndMinute])
                            DatePicker("終了予定", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                            DatePicker("期日", selection: $expiredDate, in: endDate..., displayedComponents: [.date, .hourAndMinute])
                                .onAppear(){
                                    let calendar = Calendar.current
                                    let oneWeekLater = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
                                    let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
                                    var dateComponents = calendar.dateComponents(components, from: oneWeekLater)
                                    dateComponents.hour = 23
                                    dateComponents.minute = 59
                                    expiredDate = calendar.date(from: dateComponents) ?? Date()
                                }
                            
                        }
                        if id == nil{
                            Section{
                                Picker("タスクの一括生成", selection: $bulkTaskCount) {
                                    Text("しない").tag(0)
                                    ForEach(1...10, id: \.self) { count in
                                        Text("\(count)回分追加").tag(count)
                                    }
                                }
                                .onChange(of: bulkTaskCount) { newValue in
                                    showBulkIntervalSelection = (newValue != 0)
                                }
                                if(showBulkIntervalSelection){
                                    Picker("一括作成の間隔", selection: $bulkInterval) {
                                        Text(AppConstants.BulkInterval.day.text).tag(AppConstants.BulkInterval.day)
                                        Text(AppConstants.BulkInterval.week.text).tag(AppConstants.BulkInterval.week)
                                        Text(AppConstants.BulkInterval.month.text).tag(AppConstants.BulkInterval.month)
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Button("キャンセル", action: {
                            isModalPresented = false
                        })
                        .padding()
                        if let id {
                            Button("変更して保存", action: {
                                saveTask()
                            })
                            .padding()
                        }else {
                            Button("新しく作成して保存", action: {
                                saveTask()
                            })
                            .padding()
                        }
                    }
            }
            .background(Color(.systemGray6))
    }
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
    }
    
    private func saveTask() {
          guard let id else {
              taskViewModel.createTask(
                  name: title,
                  desc: desc,
                  status: status,
                  scheduled_begin_dt: startDate,
                  scheduled_end_dt: endDate,
                  expired_dt: expiredDate,
                  project: project,
                  bulkTaskCount: bulkTaskCount,
                  bulkInterval: bulkInterval
              )
              isModalPresented = false
              isFloatBtnSelected = false
              return
          }

          taskViewModel.updateTask(
              uuid: id,
              name: title,
              desc: desc,
              status: status,
              scheduled_begin_dt: startDate,
              scheduled_end_dt: endDate,
              expired_dt: expiredDate
          )
            isModalPresented = false
            isFloatBtnSelected = false

      }

}
