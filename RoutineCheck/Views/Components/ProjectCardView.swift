import SwiftUI

struct ProjectCardView: View {
    
    var project : Project
    @State private var completedTaskPercentage : Double = 0.0
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Rectangle()
                    .frame(width: 10)
                    .foregroundColor(Color.blue)
                    .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                VStack(alignment: .leading){
                    if !project.name.isEmpty{
                        Text(project.name)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.bottom, 1)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }else {
                        Text("無題のプロジェクト")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.bottom, 1)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    if !project.desc.isEmpty {
                        Text(project.desc)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }else{
                        Text("説明文がありません。")
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    Divider()
                    Text("達成率")
                        .padding(.top , 1)
                        .foregroundColor(Color.gray)
                    HStack{
                        ProgressView("", value: completedTaskPercentage)
                        Text("\(Int(completedTaskPercentage * 100))%")
                    }
                }
                .padding(10)
                .background(Color.white)
                Spacer()
            }
            .frame(maxHeight: 160)
        }
        .clipped()
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 2)
        .background(Color.clear)
        .padding(.horizontal, 10)
        .onAppear(){
            completedTaskPercentage = ProjectViewModel().completedTaskPercentage(for: project)
        }
    }
}

struct ProjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCardView(project: ProjectViewModel().firstProject!)
    }
}

