import SwiftUI

struct ActivityDetailView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel

    @EnvironmentObject var activityViewModel : ActivityViewModel

    let activity : Activity
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if let activityName = activity.name {
                        Text("\(activityName)").font(.system(size: 20)).fontWeight(.semibold)
                            .padding(.leading, 20)
                    }else{
                        Text("無題のアクティビティ")
                            .padding(.leading, 20)
                    }
                    Spacer()
                }.padding(.leading)
                .padding(.top , 20)
                List{
                    Section(header: Text("説明")){
                        if let activityDesc = activity.desc {
                            Text("\(activityDesc)")
                        }else{
                            Text("アクティビティの説明はありません。").foregroundColor(Color.gray)
                        }
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("アクティビティ詳細")
                            .fontWeight(.semibold)
                    }
                }
                .background(Color(.systemGray6))
        }

    }
}

struct ActivitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: ActivityViewModel().firstActibity!)
    }
}

