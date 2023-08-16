import SwiftUI

struct TaskDetailView: View {
    
    let task : Task
    
    @State var taskFloetBtnSelected = false
    @State var isTaskEditModalPresented = false
    @State var isTaskCreateByCopyModalPresented = false
    @State var isActivityCreateModalPresented = false
    @State var isTaskDeleteActionSheet = false
    @State var isActivityPresented : Bool = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var taskDetailViewModel: TaskDetailViewModel
    
    
    init(task: Task) {
        self.task = task
        _taskDetailViewModel = StateObject(wrappedValue: TaskDetailViewModel(task: task))
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    if let belongsToProjectName = taskDetailViewModel.task.project?.name as? String {
                        Text("\(belongsToProjectName)").multilineTextAlignment(.leading)
                    } else {
                        Text("Unknown")
                    }
                    Spacer()
                }.font(.callout)
                    .padding(.bottom , 5)
                    .padding(.leading, 20)
                if let taskName = taskDetailViewModel.task.name{
                    Text("\(taskName)").font(.system(size: 20)).fontWeight(.semibold)
                        .padding(.leading, 20)
                }else{
                    Text("無題のタスク")
                        .padding(.leading, 20)
                }
                List{
                    Section(header: Text("説明")){
                        if let taskDesc = taskDetailViewModel.task.desc{
                            Text("\(taskDesc)")
                        }else{
                            Text("このタスクの説明はありません。").foregroundColor(Color.gray)
                        }
                    }
                    Section(header: Text("詳細情報")){
                        HStack{
                            Text("ステータス")
                            Spacer()
                            switch taskDetailViewModel.task.status {
                            case "completed":
                                Text("完了")
                            case "scheduled":
                                Text("実行予定")
                            case "abandoned":
                                Text("断念")
                            case nil:
                                Text("ステータスなし")
                            case .some(_):
                                Text("その他のステータス")
                            }
                        }
                        HStack{
                            Text("開始予定")
                            Spacer()
                            if let scheduledBeginDate = taskDetailViewModel.task.scheduled_begin_dt {
                                Text(dateFormatter.string(from: scheduledBeginDate))
                            } else {
                                Text("No schedule")
                            }
                        }
                        HStack{
                            Text("終了予定")
                            Spacer()
                            if let scheduledEndDate = taskDetailViewModel.task.scheduled_end_dt {
                                Text(dateFormatter.string(from: scheduledEndDate))
                            } else {
                                Text("No schedule")
                            }
                        }
                        HStack{
                            Text("期日")
                            Spacer()
                            if let expiredDate = taskDetailViewModel.task.expired_dt {
                                Text(dateFormatter.string(from: expiredDate))
                            } else {
                                Text("No expire")
                            }
                        }
                        HStack{
                            Text("作成日時")
                            Spacer()
                            if let createdDate = taskDetailViewModel.task.created_dt {
                                Text(dateFormatter.string(from: createdDate))
                            } else {
                                Text("No data")
                            }
                        }
                        HStack{
                            Text("最終更新日")
                            Spacer()
                            if let updatedDate = taskDetailViewModel.task.updated_dt {
                                Text(dateFormatter.string(from: updatedDate))
                            } else {
                                Text("No data")
                            }
                        }
                    }
                    if let activities = taskDetailViewModel.task.activities?.allObjects as? [Activity], !activities.isEmpty {
                        Section(header: Text("アクティビティ一覧")) {
                            ForEach(activities, id: \.self) { activity in
                                Button {
                                    isActivityPresented = true
                                } label: {
                                    ActivityCardView(activity: activity)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.black)
                                }.navigationDestination(isPresented: $isActivityPresented){
                                    ActivityDetailView(activity: activity)
                                }
                            }.listRowInsets(EdgeInsets())
                        }
                    } else {
                        Section(header: Text("アクティビティ一覧")) {
                            Text("関連づけられたアクティビティは存在しません。")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .frame( maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .listStyle(GroupedListStyle())
            }
            .padding(10)
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("タスク詳細")
                        .fontWeight(.semibold)
                }
            }
            VStack{
                Spacer()
                if(taskFloetBtnSelected){
                    VStack{
                        HStack{
                            Spacer()
                            Button(action:{
                                isTaskEditModalPresented = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "book")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("タスクを編集")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        HStack{
                            Spacer()
                            Button(action:{
                                isTaskCreateByCopyModalPresented = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "doc.on.clipboard")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("タスクをコピーして新規作成")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        HStack{
                            Spacer()
                            Button(action:{
                                isActivityCreateModalPresented = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("アクティビティを追加")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }
                        HStack{
                            Spacer()
                            Button(action:{
                                isTaskDeleteActionSheet = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("タスクを削除")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                        }.actionSheet(isPresented: $isTaskDeleteActionSheet){
                            let activityCount = TaskViewModel().numberOfActivities(for: taskDetailViewModel.task)

                            if activityCount > 0 {
                                return ActionSheet(
                                    title: Text("タスクの削除"),
                                    message: Text("このタスクには\(activityCount) 件のアクティビティが関連づけられています。 関連づけられたアイテムごと削除しますか？"),
                                    buttons: [
                                        .destructive(Text("関連アイテムごと削除"), action: {
                                            TaskViewModel().deleteTaskWithRelatedItems(taskDetailViewModel.task)
                                            presentationMode.wrappedValue.dismiss()
                                        }),
                                        .destructive(Text("タスクのみ削除"), action: {
                                            TaskViewModel().deleteTask(taskDetailViewModel.task)
                                            presentationMode.wrappedValue.dismiss()
                                        }),
                                        .cancel()
                                    ]
                                )
                            } else {
                                return ActionSheet(
                                    title: Text("タスクの削除"),
                                    message: Text("このタスクを削除してよろしいですか？"),
                                    buttons: [
                                        .destructive(Text("削除"), action: {
                                            TaskViewModel().deleteTask(taskDetailViewModel.task)
                                            presentationMode.wrappedValue.dismiss()
                                        }),
                                        .cancel()
                                    ]
                                )
                            }
                        }

                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            taskFloetBtnSelected = true
                        }
                    }, label: {
                        Image(systemName: taskFloetBtnSelected ? "xmark" : "pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    })
                    .frame(width: 60, height: 60)
                    .background(Color(.systemGray6))
                    .cornerRadius(30.0)
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                }
            }
            
        }
        .sheet(isPresented: $isTaskEditModalPresented, content: {
            TaskEditView(
                isModalPresented: $isTaskEditModalPresented,
                isFloatBtnSelected: $taskFloetBtnSelected,
                id: taskDetailViewModel.task.id!,
                title: taskDetailViewModel.task.name ?? "",
                desc: taskDetailViewModel.task.desc ?? "",
                startDate: taskDetailViewModel.task.scheduled_begin_dt ?? Date(),
                endDate: taskDetailViewModel.task.scheduled_end_dt ?? Date(),
                expiredDate: taskDetailViewModel.task.expired_dt ?? Date(),
                status: taskDetailViewModel.task.status ?? "scheduled",
                task: taskDetailViewModel.task
            )
        })
        .sheet(isPresented: $isTaskCreateByCopyModalPresented, content: {
            TaskEditView(
                isModalPresented: $isTaskCreateByCopyModalPresented,
                isFloatBtnSelected: $taskFloetBtnSelected,
                title: taskDetailViewModel.task.name ?? "",
                desc: taskDetailViewModel.task.desc ?? "",
                startDate: taskDetailViewModel.task.scheduled_begin_dt ?? Date(),
                endDate: taskDetailViewModel.task.scheduled_end_dt ?? Date(),
                expiredDate: taskDetailViewModel.task.expired_dt ?? Date(),
                status: taskDetailViewModel.task.status ?? "scheduled",
                project: taskDetailViewModel.task.project
            )
        })
        .sheet(isPresented: $isActivityCreateModalPresented, content: {
            ActivityEditView(
                isModalPresented: $isActivityCreateModalPresented,
                isFloatBtnSelected: $taskFloetBtnSelected,
                project: taskDetailViewModel.task.project,
                task: taskDetailViewModel.task,
                activity: nil
            )
        })
    }
}
