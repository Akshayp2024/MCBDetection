import SwiftUI


struct ApplicationListView: View {
    
    @StateObject var applicationViewModel = ApplicationViewModel()
    @Environment(\.presentationMode) private var presentationMode
   
//    @Binding var mcbDetails: MCBDetails?
    @Binding var isApplicationNameChanged: Bool
    @Binding var applicationName: String
    @Binding var applicationLogo: String
    
    @State var selectedName: String = ""
    @State var tempSelectedName: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })
                {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                }.padding(.leading, 10)
                    .padding(.trailing, 40)
                    .padding()
                Text("Select Application")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width)
                .background(Color.secondaryGreen)
            List(applicationViewModel.applicationArray, id: \.id) { task in
                Button(action: {
                    tempSelectedName = task.applicationName
                    applicationViewModel.selectedApplication = task

                }, label: {
                    HStack {
                        if tempSelectedName == task.applicationName {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.secondaryGreen)
                        }else{
                            Spacer().frame(width: 15)
                        }
                        Image(systemName: task.image)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(task.applicationName)")
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                        Spacer()
                        if tempSelectedName == task.applicationName {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                        }
                    }
                })
            }
            .listStyle(.plain)
            
            Button {
                if tempSelectedName != "" {
                    selectedName = tempSelectedName
                    applicationName = applicationViewModel.selectedApplication?.applicationName ?? applicationName
                    applicationLogo = applicationViewModel.selectedApplication?.image ?? applicationLogo
                    isApplicationNameChanged.toggle()
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Select")
                        .padding()
                        .font(.system(size: 16, weight: .regular))

                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.secondaryGreen)
                .cornerRadius(10)
                .padding(.horizontal, 30)
            }
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
       
    }
}


struct LocationListView: View {
    
    @Environment(\.presentationMode) private var presentationMode
   
    @Binding var isApplicationNameChanged: Bool
    @Binding var areaName: String
    
    @State var selectedAreaName: String = ""
    @State var tempSelectedAreaName: String = ""
    @State var areaNamesArray: [String] = []
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })
                {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)
                }.padding(.leading, 10)
                    .padding(.trailing, 40)
                    .padding()
                Text("Select Location")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width)
                .background(Color.secondaryGreen)
            List(areaNamesArray, id: \.self) { location in
                Button {
                    tempSelectedAreaName = location
                } label: {
                    HStack {
                        if tempSelectedAreaName == location {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.secondaryGreen)
                        }else{
                            Spacer().frame(width: 15)
                        }
                        Text(location)
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                        Spacer()
                        
                        if tempSelectedAreaName == location {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                        }
                    }
                }

            }
            .listStyle(.plain)
            Button(action: {
                if tempSelectedAreaName != "" {
                    selectedAreaName = tempSelectedAreaName
                    areaName = selectedAreaName
                    isApplicationNameChanged.toggle()
                    presentationMode.wrappedValue.dismiss()
                }
            }){
                HStack {
                    Spacer()
                    Text("Select")
                        .padding()
                        .font(.system(size: 16, weight: .regular))
                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.secondaryGreen)
                .cornerRadius(10)
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
       
    }
}
