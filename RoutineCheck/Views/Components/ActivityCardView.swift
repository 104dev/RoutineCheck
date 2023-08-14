import SwiftUI

struct ActivityCardView: View {
    var activity : Activity
    
    var body: some View {
        VStack{
            HStack{
                Rectangle()
                    .frame(width: 10)
                    .foregroundColor(Color.blue)
                    .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                VStack(alignment: .leading){
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
                    Text("2023年7月23日 22:14")
                        .padding(.top , 1)
                        .foregroundColor(Color.gray)
                }
                .padding(.horizontal,10)
                Spacer()
            }
            .background(Color.white)
            .frame(height: 120)
        }
        .clipped()
        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 2)
        .background(Color.blue)
        .padding(.horizontal, 10)
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView(activity: ActivityViewModel().firstActibity!)
    }
}


