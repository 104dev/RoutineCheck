import SwiftUI

struct ProjectEditView: View {
    
    @Binding var isModalPresented: Bool
    @Binding var isFloatBtnSelected: Bool
    @ObservedObject var project: Project
    @State private var title: String = ""
    @State private var desc: String = ""
    @EnvironmentObject var projectViewModel : ProjectViewModel
    
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
                    saveProject()
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
        title = project.name
        desc = project.desc
    }
    
    private func saveProject() {
        projectViewModel.updateProject(
            uuid: project.id,
            name: title,
            desc: desc
        )
        
        project.name = title
        project.desc = desc
        isModalPresented = false
        isFloatBtnSelected = false
    }
    
}
