import SwiftUI

struct LookForItemView: View {

    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    @EnvironmentObject var projectViewModel : ProjectViewModel
    
    @State private var searchText = ""
    
    enum ItemType: String, CaseIterable, Identifiable {
        case project = "プロジェクト"
        case task = "タスク"
        case activity = "アクティビティ"
        
        var id: String { rawValue }
    }

    @State private var selectedItemType = ItemType.project
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText)
                Picker("アイテム", selection: $selectedItemType) {
                    ForEach(ItemType.allCases) {
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
                if searchText.isEmpty {
                    projectViewModel.fetchProjects()
                    taskViewModel.fetchTasks()
                    activityViewModel.fetchActivities()
                } else {
                    projectViewModel.fetchProjects()
                    taskViewModel.fetchTasks(withName: searchText)
                    activityViewModel.fetchActivities()
                }
            }
            .onChange(of: searchText) { newtext in
                if searchText.isEmpty {
                    projectViewModel.fetchProjects()
                    taskViewModel.fetchTasks()
                    activityViewModel.fetchActivities()
                } else {
                    projectViewModel.fetchProjects()
                    taskViewModel.fetchTasks(withName: searchText)
                    activityViewModel.fetchActivities()
                }
            }
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

