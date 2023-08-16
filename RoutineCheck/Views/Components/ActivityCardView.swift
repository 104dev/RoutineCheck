import SwiftUI

struct ActivityCardView: View {
    var activity : Activity
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
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
                    Spacer()
                    HStack{
                        if let projectName = activity.project?.name as? String {
                            Text(projectName)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color.gray)
                                .cornerRadius(5)
                        }
                        if let taskName = activity.task?.name as? String {
                            Text(taskName)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color.gray)
                                .cornerRadius(5)
                        }
                        Spacer()
                    }
                    if let desc = activity.desc{
                        Text(desc)
                            .padding(.top, 10)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }else{
                        Text("本文がありません。")
                            .padding(.top, 10)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    if let createdDate = activity.created_dt {
                        HStack {
                            Text(dateFormatter.string(from: createdDate))
                                .padding(.top , 1)
                                .foregroundColor(Color.gray)
                        }
                    } else {
                        Text("No Data")
                    }
                    Spacer()
                }
                .padding(.horizontal,10)
                .background(Color.white)
                Spacer()
            }
            .frame(height: 120)
        }
        .clipped()
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 2)
        .background(Color.clear)
        .padding(.horizontal, 10)
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView(activity: ActivityViewModel().firstActibity!)
    }
}


