import SwiftUI

struct ActivityDetailView: View {
    
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var activityViewModel : ActivityViewModel
    let activity : Activity
    @State private var activityFloetBtnSelected = false
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if !activity.name.isEmpty {
                        Text("\(activity.name)").font(.system(size: 20)).fontWeight(.semibold)
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
                        if !activity.desc.isEmpty {
                            Text("\(activity.desc)")
                        }else{
                            Text("アクティビティの説明はありません。").foregroundColor(Color.gray)
                        }
                    }
                    Section(){
                        HStack{
                            Text("作成日時")
                            Spacer()
                            if !activity.isFault {
                                Text(DateFormatter.customFormat.string(from: activity.created_dt))
                            }
                        }
                        HStack{
                            Text("最終更新日")
                            Spacer()
                            if let updatedDate = activity.updated_dt {
                                Text(DateFormatter.customFormat.string(from: updatedDate))
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
            FloatingButton(activity: activity, floatBtnSelected: $activityFloetBtnSelected)
        }
    }
    
    struct FloatingButton : View {
        @ObservedObject var activity : Activity
        @Binding var floatBtnSelected: Bool
        
        var body: some View {
            VStack{
                Spacer()
                if(floatBtnSelected){
                    VStack{
                        ActivityEditOpener(floatBtnSelected: $floatBtnSelected, activity: activity)
                        
                        ActivityDeleteOpener(activity: activity)
                    }
                }
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            floatBtnSelected = true
                        }
                    }, label: {
                        Image(systemName: floatBtnSelected ? "xmark" : "pencil")
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
        
    }
    
    struct ActivityEditOpener : View {
        @State private var isActivityEditModalPresented = false
        @Binding var floatBtnSelected : Bool
        @ObservedObject var  activity : Activity
        
        var body: some View {
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
            .sheet(isPresented: $isActivityEditModalPresented, content: {
                ActivityEditView(
                    isModalPresented:$isActivityEditModalPresented, isFloatBtnSelected: $floatBtnSelected, project: nil,
                    task: nil,
                    activity: activity
                )
            })
        }
    }
    
    struct ActivityDeleteOpener : View {
        @State var isActivityDeleteActionSheet = false
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var  activity : Activity
        
        var body: some View {
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
}

struct ActivitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: ActivityViewModel().firstActibity!)
    }
}

