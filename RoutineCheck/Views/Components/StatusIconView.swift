import SwiftUI

extension Color {
    static let customRed = Color(red: 247/255, green: 106/255, blue: 142/255)
    static let customGreen = Color(red: 68/255, green: 191/255, blue: 144/255)
    static let customBlue = Color(red: 109/255, green: 173/255, blue: 248/255)
}

struct StatusIconView: View {
    var taskStatus: String
    var body: some View {
        switch taskStatus{
        case "completed":
            ZStack{
                Circle()
                    .foregroundColor(.customGreen)
                    .frame(width: 25, height: 25)
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
       case "scheduled":
            ZStack{
                Circle()
                    .foregroundColor(.customBlue)
                    .frame(width: 25, height: 25)
                Image(systemName: "timer")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
        case "abandoned":
            ZStack{
                Circle()
                    .foregroundColor(.customRed)
                    .frame(width: 25, height: 25)
                Image(systemName: "nosign")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
        default:
            Color.clear
                .frame(width: 25)
        }
    }
}

struct StatusIconView_Previews: PreviewProvider {
    static var previews: some View {
        StatusIconView(taskStatus: "suspended")
    }
}
