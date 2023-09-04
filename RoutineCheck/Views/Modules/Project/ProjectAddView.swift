//

import SwiftUI

struct ProjectAddView: View {

    @Binding var isModalPresented: Bool
    @Binding var isFloatBtnSelected: Bool
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
                    addProject()
                })
                .padding()
            }
        }
        .background(Color(.systemGray6))
    }
    
    private func addProject() {
        projectViewModel.createProject(
            name: title,
            desc: desc
        )
        
        isModalPresented = false
        isFloatBtnSelected = false
    }

}
