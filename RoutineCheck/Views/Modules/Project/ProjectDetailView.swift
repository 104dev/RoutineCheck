import SwiftUI

struct ProjectDetailView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    @State private var selectedItemType = ItemType.task
    @State  var isPresented : Bool = false
    @State var projectFloetBtnSelected = false
    @State var isTaskCreateModalPresented = false
    @State var isActivityCreateModalPresented = false
    @State var isProjectDeleteActionSheet = false
    @Environment(\.presentationMode) var presentationMode

    enum ItemType: String, CaseIterable, Identifiable {
        case task = "タスク"
        case activity = "アクティビティ"
        
        var id: String { rawValue }
    }
    
    let project : Project
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if let projectName = project.name {
                        Text("\(projectName)").font(.system(size: 20)).fontWeight(.semibold)
                            .padding(.leading, 20)
                    }else{
                        Text("無題のプロジェクト")
                            .padding(.leading, 20)
                    }
                    Spacer()
                }.padding(.leading)
                    .padding(.top , 20)
                List{
                    Section(header: Text("説明")){
                        if let projectDesc = project.desc {
                            Text("\(projectDesc)")
                        }else{
                            Text("このプロジェクトの説明はありません。").foregroundColor(Color.gray)
                        }
                    }.padding(.leading, 20)
                    
                    Picker("アイテム", selection: $selectedItemType) {
                        ForEach(ItemType.allCases) {
                            ItemType in
                            Text(ItemType.rawValue).tag(ItemType)
                        }
                    }.pickerStyle(.segmented)
                        .onChange(of: selectedItemType) { newItemType in
                            switch newItemType {
                            case .task:
                                taskViewModel.fetchTasks()
                            case .activity:
                                activityViewModel.fetchActivities()
                            }
                        }
                    
                    if(selectedItemType == .task){
                        if let projectTasks = project.tasks?.allObjects as? [Task], !projectTasks.isEmpty{
                            ForEach(projectTasks, id: \.self) { task in
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
                    }else if(selectedItemType == .activity){
                        if let projectActivities = project.activities?.allObjects as? [Activity] , !projectActivities.isEmpty {
                            ForEach(projectActivities, id: \.self) { activity in
                                Button {
                                    isPresented.toggle()
                                } label: {
                                    ActivityCardView(activity: activity)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.black)
                                }.navigationDestination(isPresented: $isPresented){
                                    ActivityDetailView(activity: activity)
                                }
                            }.listRowInsets(EdgeInsets())
                        } else {
                            Text("関連づけられたアクティビティがありません")
                        }
                    }
                }
                .frame( maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .listStyle(GroupedListStyle())
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("プロジェクト詳細")
                            .fontWeight(.semibold)
                    }
                }
                .background(Color(.systemGray6))
            VStack{
                Spacer()
                if(projectFloetBtnSelected){
                    VStack{
                        HStack{
                            Spacer()
                            Button(action:{
                                isTaskCreateModalPresented.toggle()
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
                                Text("タスクを追加")
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
                                isActivityCreateModalPresented.toggle()
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
                                isProjectDeleteActionSheet.toggle()
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
                                Text("プロジェクトを削除")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                            .actionSheet(isPresented: $isProjectDeleteActionSheet){
                                let taskCount = ProjectViewModel().numberOfTasks(for: project)
                                let activityCount = ProjectViewModel().numberOfActivities(for: project)

                                if taskCount > 0 || activityCount > 0 {
                                    return ActionSheet(
                                        title: Text("プロジェクトの削除"),
                                        message: Text("このプロジェクトには \(taskCount) 件のタスクと \(activityCount) 件のアクティビティが関連づけられています。 関連づけられたアイテムごと削除しますか？"),
                                        buttons: [
                                            .destructive(Text("関連アイテムごと削除"), action: {
                                                ProjectViewModel().deleteWithRelatedItems(project)
                                                presentationMode.wrappedValue.dismiss()
                                            }),
                                            .destructive(Text("プロジェクトのみ削除"), action: {
                                                ProjectViewModel().deleteProject(project)
                                                presentationMode.wrappedValue.dismiss()
                                            }),
                                            .cancel()
                                        ]
                                    )
                                } else {
                                    return ActionSheet(
                                        title: Text("プロジェクトの削除"),
                                        message: Text("このプロジェクトを削除してよろしいですか？"),
                                        buttons: [
                                            .destructive(Text("削除"), action: {
                                                ProjectViewModel().deleteProject(project)
                                                presentationMode.wrappedValue.dismiss()
                                            }),
                                            .cancel()
                                        ]
                                    )
                                }
                            }
                        }
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            projectFloetBtnSelected.toggle()
                        }
                    }, label: {
                        Image(systemName: projectFloetBtnSelected ? "xmark" : "pencil")
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
        }.sheet(isPresented: $isTaskCreateModalPresented, content: {
            TaskEditView(
                isModalPresented:$isTaskCreateModalPresented,
                project: project,
                task: nil
            )
        })
        .sheet(isPresented: $isActivityCreateModalPresented, content: {
            ActivityEditView(
                isModalPresented:$isActivityCreateModalPresented,
                project: project,
                task: nil,
                activity: nil
            )
        })
        .onAppear() {
            taskViewModel.fetchTasks()
            activityViewModel.fetchActivities()
        }

    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: ProjectViewModel().firstProject!)
    }
}
