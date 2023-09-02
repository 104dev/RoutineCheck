import SwiftUI

struct LookForItemView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    @EnvironmentObject var projectViewModel : ProjectViewModel
    
    @State private var selectedItemType = AppConstants.ItemType.project
    
    @State private var searchText = ""
    
    @State var commonMenuFloatBtnSelected = false
    @State var isProjectCreateModalPresented = false
    
    struct SegmentedControlView : View {
        @Binding var selectedItemType: AppConstants.ItemType
        @EnvironmentObject var projectViewModel: ProjectViewModel
        @EnvironmentObject var taskViewModel: TaskViewModel
        @EnvironmentObject var activityViewModel: ActivityViewModel
        
        var body: some View {
            Picker("", selection: $selectedItemType) {
                ForEach(AppConstants.ItemType.allCases) {
                    ItemType in
                    Text(ItemType.rawValue).tag(ItemType)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedItemType) { newItemType in
                switch newItemType {
                case .project:
                    projectViewModel.fetchProjects()
                case .task:
                    taskViewModel.fetchTasks()
                case .activity:
                    activityViewModel.fetchActivities()
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .leading) {
                    SearchBar(text: $searchText)
                    SegmentedControlView(selectedItemType: $selectedItemType)
                    ScrollView{
                        switch selectedItemType {
                        case .task:
                            ForEach(taskViewModel.tasks, id: \.self) { task in
                                NavigationLink(destination: TaskDetailView(task: task)) {
                                    TaskCardView(task: task)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case .project:
                            ForEach(projectViewModel.projects, id: \.self) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    ProjectCardView(project: project)
                                        .padding(.vertical, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case .activity:
                            ForEach(activityViewModel.activities, id: \.self) { activity in
                                HStack{
                                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                        ActivityCardView(activity: activity)
                                            .padding(.vertical, 10)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear() {
                    fetchAllItems()
                }
                .onChange(of: searchText) { newtext in
                    fetchAllItems()
                }
                //ここからフローティングメニュー
                if selectedItemType == .project {
                    VStack{
                        Spacer()
                        if(commonMenuFloatBtnSelected){
                            VStack{
                                HStack{
                                    Spacer()
                                    Button(action:{
                                        isProjectCreateModalPresented = true
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
                                        Text("プロジェクトを作成")
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
                            }
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    commonMenuFloatBtnSelected.toggle()
                                }
                            }, label: {
                                Image(systemName: commonMenuFloatBtnSelected ? "xmark" : "pencil")
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
            .sheet(isPresented: $isProjectCreateModalPresented, content: {
                ProjectEditView(
                    isModalPresented: $isProjectCreateModalPresented, isFloatBtnSelected: $commonMenuFloatBtnSelected,
                    project: nil
                    
                )
            })
        }
    }
    
    
    func fetchAllItems(){
        if searchText.isEmpty {
            projectViewModel.fetchProjects()
            taskViewModel.fetchTasks()
            activityViewModel.fetchActivities()
        } else {
            projectViewModel.fetchProjects(withName: searchText)
            taskViewModel.fetchTasks(withName: searchText)
            activityViewModel.fetchActivities(withName: searchText)
        }
    }
    
}


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "ここに文字を入力"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct LookForItemView_Previews: PreviewProvider {
    static var previews: some View {
        LookForItemView().environmentObject(TaskViewModel())
            .environmentObject(ProjectViewModel())
            .environmentObject(ActivityViewModel())
    }
}

