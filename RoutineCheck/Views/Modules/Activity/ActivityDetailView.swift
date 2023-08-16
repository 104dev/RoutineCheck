import SwiftUI

struct ActivityDetailView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    let activity : Activity
    @State private var activityFloetBtnSelected = false
    @State private var isActivityEditModalPresented = false
    @State var isActivityDeleteActionSheet = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var activityDetailViewModel: ActivityDetailViewModel
    
    init(activity: Activity) {
        self.activity = activity
        _activityDetailViewModel = StateObject(wrappedValue: ActivityDetailViewModel(activity: activity))
    }

    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if let activityName = activityDetailViewModel.activity.name {
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
                    Section(){
                        HStack{
                            Text("作成日時")
                            Spacer()
                            if let createdDate = activity.created_dt {
                                Text(dateFormatter.string(from: createdDate))
                            } else {
                                Text("No data")
                            }
                        }
                        HStack{
                            Text("最終更新日")
                            Spacer()
                            if let updatedDate = activity.updated_dt {
                                Text(dateFormatter.string(from: updatedDate))
                            } else {
                                Text("No data")
                            }
                        }

                    }

                }.frame( maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(GroupedListStyle())
                
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
            VStack{
                Spacer()
                if(activityFloetBtnSelected){
                    VStack{
                        HStack{
                            Spacer()
                            Button(action:{
                                isActivityEditModalPresented = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "book")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("アクティビティを編集")
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
                        HStack{
                            Spacer()
                            Button(action:{
                                isActivityDeleteActionSheet = true
                            } ) {
                                Spacer()
                                ZStack{
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                Text("アクティビティを削除")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(4)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(3)
                            }
                            .frame(width: 240, height: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                            .actionSheet(isPresented: $isActivityDeleteActionSheet){
                                ActionSheet(
                                    title: Text("アクティビティの削除"),
                                    message: Text("このアクティビティを削除してよろしいですか？"),
                                    buttons: [
                                        .destructive(Text("削除"), action: {
                                            ActivityViewModel().deleteActivity(activity)
                                            presentationMode.wrappedValue.dismiss()
                                        }),
                                        .cancel()
                                    ]
                                )
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            activityFloetBtnSelected.toggle()
                        }
                    }, label: {
                        Image(systemName: activityFloetBtnSelected ? "xmark" : "pencil")
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
        .sheet(isPresented: $isActivityEditModalPresented, content: {
            ActivityEditView(
                isModalPresented:$isActivityEditModalPresented, isFloatBtnSelected: $activityFloetBtnSelected, project: nil,
                task: nil,
                activity: activityDetailViewModel.activity
            )
        })
    }
}

struct ActivitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: ActivityViewModel().firstActibity!)
    }
}

