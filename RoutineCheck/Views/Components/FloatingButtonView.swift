import SwiftUI

struct FloatingButtonView: View {
        
    @State var floetingBtnSelected = false
    var body: some View {
        VStack {
            Spacer()
            if(floetingBtnSelected){
                HStack{
                    Spacer()
                    Button(action:{
                        print("Tapped!!")
                    } ) {
                        Text("追加")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(4)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(3)
                    }
                    .frame(width: 120, height: 20)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    floetingBtnSelected.toggle()
                }, label: {
                    Image(systemName: floetingBtnSelected ? "xmark" : "pencil")
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

struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonView()
    }
}
