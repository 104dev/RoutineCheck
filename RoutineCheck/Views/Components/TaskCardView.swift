import SwiftUI

struct TaskCardView: View {

    var task : Task

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter
    }
    
    var dateFormatterToTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Rectangle()
                    .frame(width: 10)
                    .foregroundColor(Color.blue)
                    .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                VStack(alignment: .leading){
                    HStack{
                        VStack(alignment: .leading){
                            if let projectName = task.project?.name {
                                Text(projectName)
                                    .foregroundColor(Color.blue)
                                    .fontWeight(.semibold)
                                    .padding(.top, 15)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }else{
                                Text("プロジェクト未定義")
                                    .foregroundColor(Color.blue)
                                    .fontWeight(.semibold)
                                    .padding(.top, 15)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            Text(task.name ?? "タイトル未定義")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .padding(.top, 1)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        Spacer()
                        VStack() {
                            if let taskStatus = task.status{
                                StatusIconView(taskStatus: taskStatus)
                            }
                            Spacer()
                        }.padding(.top, 20)
                    }
                    Text(task.desc ?? "このタスクの説明はありません。")
                        .padding(.top, 1)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    HStack{
                        if let scheduledBeginDate = task.scheduled_begin_dt,
                           let scheduledEndDate = task.scheduled_end_dt {
                            HStack {
                                Text(dateFormatter.string(from: scheduledBeginDate))
                                Text("-")
                                Text(dateFormatterToTime.string(from: scheduledEndDate))
                            }
                        } else {
                            Text("No schedule")
                        }
                    }
                    .padding(.top, 1)
                    .padding(.bottom)
                    .foregroundColor(Color.gray)
                }
                .padding(10)
                .background(Color.white)
                Spacer()
            }
            .frame(height: 160)
        }
        .clipped()
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 2)
        .background(Color.clear)
        .padding(.horizontal, 10)
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: TaskViewModel().firstTask!)
    }
}
