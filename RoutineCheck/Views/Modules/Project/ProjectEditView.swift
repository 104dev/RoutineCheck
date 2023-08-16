import SwiftUI

struct ProjectEditView: View {
    
    @Binding var isModalPresented: Bool
    @Binding var isFloatBtnSelected: Bool
    let project: Project?
    @State private var title: String = ""
    @State private var desc: String = ""
    
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
            guard let project = project else { return }
            title = project.name ?? ""
            desc = project.desc ?? ""
    }
    
    private func saveProject() {
          guard let project = project else {
              ProjectViewModel().createProject(
                  name: title,
                  desc: desc
              )
              isModalPresented = false
              isFloatBtnSelected = false
              return
          }

          ProjectViewModel().updateProject(
              uuid: project.id!,
              name: title,
              desc: desc
          )
            isModalPresented = false
            isFloatBtnSelected = false
      }

}
