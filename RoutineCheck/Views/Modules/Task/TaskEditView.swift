import SwiftUI


struct TaskEditView: View {

    //親ビューに関係する情報
    @Binding var isModalPresented: Bool
    //タスクの情報に関わる情報
    @State var id: UUID?
    @State var title: String = ""
    @State var desc: String = ""
    @State var startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @State var endDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State var expiredDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    @State var status : String = ""
    @State var project: Project? = nil
    //一括作成に関わる情報
    @State private var bulkTaskCount: Int = 0
    @State private var showBulkIntervalSelection: Bool = false
    @State private var bulkInterval: Int = 1
    
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
                                Text("予定").tag("scheduled")
                                Text("完了").tag("completed")
                                Text("断念").tag("abandoned")
                            }.onChange(of: status) { newValue in
                                print("Selected option changed to: \(newValue)")
                            }
                            DatePicker("実行開始", selection: $startDate, in: ...endDate, displayedComponents: [.date, .hourAndMinute])
                            DatePicker("終了予定", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                            DatePicker("期日", selection: $expiredDate, in: endDate..., displayedComponents: [.date, .hourAndMinute])
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
                                        Text("毎日").tag(1)
                                        Text("1週間毎").tag(2)
                                        Text("1ヶ月毎").tag(3)
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
              print(title)
              isModalPresented.toggle()
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
          isModalPresented.toggle()
      }

}
