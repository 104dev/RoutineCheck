import SwiftUI

struct ProjectDetailView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    @State private var selectedItemType = AppConstants.ItemTypeRelatedToProject.task
    @State  var isPresented : Bool = false
    @State var projectFloatBtnSelected = false
    @ObservedObject var project : Project
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if !project.name.isEmpty {
                        Text("\(project.name)").font(.system(size: 20)).fontWeight(.semibold)
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
                        if !project.desc.isEmpty {
                            Text("\(project.desc)")
                        }else{
                            Text("このプロジェクトの説明はありません。").foregroundColor(Color.gray)
                        }
                    }.padding(.leading, 20)
                    SegmentedControl(selectedItemType: $selectedItemType, taskViewModel: taskViewModel, activityViewModel: activityViewModel)
                    ItemListView(selectedItemType: $selectedItemType, isPresented: $isPresented, project: project)
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
            FloatingButton(project: project, floatBtnSelected: $projectFloatBtnSelected)
        }
        .onAppear() {
            taskViewModel.fetchTasks()
            activityViewModel.fetchActivities()
        }
    }
    
    struct ItemListView : View {
        @Binding var selectedItemType : AppConstants.ItemTypeRelatedToProject
        @Binding var isPresented : Bool
        @ObservedObject var project: Project
        
        var body: some View {
            if(selectedItemType == .task){
                if let projectTasks = project.tasks?.allObjects as? [Task], !projectTasks.isEmpty{
                    ForEach(projectTasks, id: \.self) { task in
                        Button {
                            isPresented = true
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
                            isPresented = true
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
    }
    
    struct SegmentedControl : View {
        @Binding var selectedItemType : AppConstants.ItemTypeRelatedToProject
        @ObservedObject var taskViewModel : TaskViewModel
        @ObservedObject var activityViewModel : ActivityViewModel
        
        var body: some View {
            Picker("アイテム", selection: $selectedItemType) {
                ForEach(AppConstants.ItemTypeRelatedToProject.allCases) {
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
        }
    }
    
    struct FloatingButton : View {
        @ObservedObject var project : Project
        @Binding var floatBtnSelected: Bool
        
        var body : some View {
            VStack{
                Spacer()
                if(floatBtnSelected){
                    VStack{
                        ProjectEditOpener(projectFloatBtnSelected: $floatBtnSelected, project: project)
                        TaskCreateOpener(projectFloatBtnSelected: $floatBtnSelected, project: project)
                        AcitivityCreateOpener(projectFloatBtnSelected: $floatBtnSelected, project: project)
                        ProjectDeleteOpener(project: project)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            floatBtnSelected.toggle()
                        }
                    }, label: {
                        Image(systemName: floatBtnSelected ? "xmark" : "pencil")
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
    }
    
    struct ProjectEditOpener : View {
        @State var isProjectEditModalPresented = false
        @Binding var projectFloatBtnSelected : Bool
        @ObservedObject var project : Project
        
        var body: some View {
            HStack{
                Spacer()
                Button(action:{
                    isProjectEditModalPresented.toggle()
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
                    Text("プロジェクトを編集")
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
            .sheet(isPresented: $isProjectEditModalPresented, content: {
                ProjectEditView(
                    isModalPresented:$isProjectEditModalPresented, isFloatBtnSelected: $projectFloatBtnSelected,
                    project: project
                )
            })
        }
    }
    

    struct TaskCreateOpener : View {
        @State var isTaskCreateModalPresented = false
        @Binding var projectFloatBtnSelected : Bool
        @ObservedObject var project : Project

        var body: some View {
            HStack{
                Spacer()
                Button(action:{
                    isTaskCreateModalPresented = true
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
            .sheet(isPresented: $isTaskCreateModalPresented, content: {
                TaskEditView(
                    isModalPresented: $isTaskCreateModalPresented,
                    isFloatBtnSelected: $projectFloatBtnSelected,
                    project: project
                )
            })

        }
    }
    
    struct AcitivityCreateOpener : View {
        @State var isActivityCreateModalPresented = false
        @Binding var projectFloatBtnSelected : Bool
        @ObservedObject var project : Project

        var body: some View {
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
            .sheet(isPresented: $isActivityCreateModalPresented, content: {
                ActivityEditView(
                    isModalPresented:$isActivityCreateModalPresented, isFloatBtnSelected: $projectFloatBtnSelected,
                    project: project,
                    task: nil,
                    activity: nil
                )
            })

        }

    }
    
    struct ProjectDeleteOpener : View {
        @State var isProjectDeleteActionSheet = false
        @ObservedObject var project : Project
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            HStack{
                Spacer()
                Button(action:{
                    isProjectDeleteActionSheet = true
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
}
/*
 struct ProjectDetailView_Previews: PreviewProvider {
 static var previews: some View {
 ProjectDetailView(project: ProjectViewModel().firstProject!)
 }
 }
 */
