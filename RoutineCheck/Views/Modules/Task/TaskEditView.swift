import SwiftUI


struct TaskEditView: View {

    //親ビューに関係する情報
    @Binding var isModalPresented: Bool
    //タスクの情報に関わる情報
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var endDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var expiredDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    @State private var status : String = ""
    @State var project: Project? = nil
    @State var task: Task?
    //一括作成に関わる情報
    @State private var bulkTaskCount: Int = 0
    @State private var showBulkIntervalSelection: Bool = false
    @State private var bulkInterval: Int = 0
    
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
                            if let task{
                                Picker("ステータス", selection: $status){
                                    Text("予定").tag("scheduled")
                                    Text("完了").tag("completed")
                                    Text("断念").tag("abandoned")
                                }.onChange(of: status) { newValue in
                                    print("Selected option changed to: \(newValue)")
                                }
                            }
                            DatePicker("実行開始", selection: $startDate, in: ...endDate, displayedComponents: [.date, .hourAndMinute])
                            DatePicker("終了予定", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                            DatePicker("期日", selection: $expiredDate, in: endDate..., displayedComponents: [.date, .hourAndMinute])
                        }
                        if task == nil{
                            Section{
                                Picker("タスクの一括生成)", selection: $bulkTaskCount) {
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
                                        Text("毎日").tag(0)
                                        Text("1週間毎").tag(1)
                                        Text("1ヶ月毎").tag(2)
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Button("キャンセル", action: {
                            isModalPresented.toggle()
                        })
                        .padding()
                        Button("保存", action: {
                            saveTask()
                        })
                        .padding()
                    }
            }
            .background(Color(.systemGray6))
            .onAppear(){
                setupInitialValues()
            }
    }
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
    }
    
    
    private func setupInitialValues() {
            guard let task = task else { return }
            title = task.name ?? ""
            desc = task.desc ?? ""
            startDate = task.scheduled_begin_dt ?? Date()
            endDate = task.scheduled_end_dt ?? Date()
            expiredDate = task.expired_dt ?? Date()
            status = task.status ?? "scheduled"
    }
    
    private func saveTask() {
          guard let task = task else {
              taskViewModel.createTask(
                  name: title,
                  desc: desc,
                  scheduled_begin_dt: startDate,
                  scheduled_end_dt: endDate,
                  expired_dt: expiredDate,
                  project: project,
                  bulkTaskCount: bulkTaskCount,
                  bulkInterval: bulkInterval
              )
              isModalPresented.toggle()
              return
          }

          taskViewModel.updateTask(
              uuid: task.id!,
              name: title,
              desc: desc,
              scheduled_begin_dt: startDate,
              scheduled_end_dt: endDate,
              expired_dt: expiredDate,
              status: status
          )
          isModalPresented.toggle()
      }

}
