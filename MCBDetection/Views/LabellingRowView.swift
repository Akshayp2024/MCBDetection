//
//  LabellingRowView.swift
//  MCBModel
//
//  Created by Ayesha Siddiqua on 21/05/24.
//

import SwiftUI

struct LabellingRowView: View {
    @Environment(\.presentationMode) private var presentationMode

    @State var mcbDetails : [MCBDetails] = []
    @State var isItemSelected: Bool = false
    @State var selectedRow: Int = 0
    @ObservedObject var viewModel: ViewModel

    @State var selectedIndexValue: Int = 0
    @State var updateScrollPosition: Bool = false
    @State var isShowingApplication = false
    
    @State var areaName: String = ""
    @State var referenceNumber: String = ""
    @State var applicationName: String = ""
    @State var logo: String = ""
    
    @State var isApplicationNameChanged: Bool = false

    @State var isLoaded: Bool = false
    @State private var isShowingPopup: Bool = false

    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Button(action: {
                            self.mcbDetails.removeAll()
                            presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 10)
                        .padding()
                        Spacer()
                    }
                    Text("Row \(selectedRow + 1)")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    HStack {
                        Spacer()
                        Spacer()
                            .padding(.trailing, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.secondaryGreen)
//                Spacer().frame(height: 50)
                
                ZStack {
                    // Background image
                    if let image = backhroundImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                            .edgesIgnoringSafeArea(.horizontal)
                    }else{
                        Color.primaryGray
                            .opacity(1)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                            .edgesIgnoringSafeArea(.horizontal)
                    }
                    
                    ScrollViewReader(content: { proxy in
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing:1) {
                                ForEach(Array(mcbDetails.enumerated()), id: \.element.id) { index, item in
                                    MCBDetailsCellView(mcbDetails: item, options: [], color: selectedIndexValue == index ? Color.primaryBlue : .secondaryGreen)
                                        .foregroundColor(isItemSelected ? Color.primaryBlue : Color.black)
                                        .id(index)
                                }
                                
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        }
                        .background(
                            Color.black
                                .opacity(0.5)
                                .padding(.vertical, -50)
                        )
                        .onChange(of: selectedIndexValue) { oldValue, newValue in
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                        .onChange(of: updateScrollPosition) { oldValue, newValue in
                            withAnimation {
                                proxy.scrollTo(selectedIndexValue)
                            }
                        }
                    })
                }
                .padding(.top, -11)
                .padding(.bottom, 2)
//                Spacer().frame(height: 60)
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Button(action: {
                        if selectedIndexValue != 0 {
                            withAnimation {
                                selectedIndexValue -= 1
                                updateModuleConfig(index: selectedIndexValue)
                            }
                        }
                    }){
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .foregroundColor(selectedIndexValue == 0 ? .gray : .white)
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    .disabled(selectedIndexValue == 0 ? true : false)
                    
                    Button(action: {
                        if (mcbDetails.count) > selectedIndexValue + 1 {
                            withAnimation {
                                selectedIndexValue += 1
                                updateModuleConfig(index: selectedIndexValue)
                                
                            }
                        }
                    }) {
                        Image(systemName: "chevron.forward.circle")
                            .resizable()
                            .foregroundColor((mcbDetails.count) <= selectedIndexValue + 1 ? .gray : .white)
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    .disabled((mcbDetails.count) <= selectedIndexValue + 1 ? true : false)
                    Spacer()
                }
                .background(Color.black.opacity(0.7))
                .frame(height: 50)
                HStack(){
                    Text("MODULE CONFIGURATION")
                        .font(.system(size: 12, weight: .light))
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical)
                        .padding([.leading], 30)
                    Spacer()
                }
                .background(Color.primaryGray.opacity(0.7))
                .padding(.top, 2)
                
                HStack {
                    Text("Application")
                        .foregroundColor(.black)
                    Spacer()
                    NavigationLink(destination: ApplicationListView(isApplicationNameChanged: .constant(false), applicationName: $applicationName, applicationLogo: $logo, selectedName: applicationName, tempSelectedName: applicationName)) {
                        
                        HStack {
                            Image(systemName: logo)
                                .resizable()
                                .frame(width: 15,height: 15, alignment: .center)
                                .padding(.top,3)
                                .padding(.trailing, 5)
                                .foregroundColor(.primaryBlue)

                            Text(applicationName)
                                .foregroundColor(.primaryBlue)
                                .font(.system(size: 14, weight: .light))

                            Image(systemName: "chevron.forward")
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                        
                    }
                }
                .padding(.trailing,15)
                .padding(.leading, 30)
                .onChange(of: isApplicationNameChanged) { o, n in
                    viewModel.classification[selectedRow][selectedIndexValue].name = applicationName
                    viewModel.classification[selectedRow][selectedIndexValue].logo = logo
                    viewModel.classification[selectedRow][selectedIndexValue].referenceNumber = referenceNumber
                    viewModel.classification[selectedRow][selectedIndexValue].areaName = areaName
                    updateModuleConfig(index: selectedIndexValue)
                    isApplicationNameChanged.toggle()
                }
                Divider()
                HStack {
                    Text("Location")
                    Spacer()
                    Menu {
                        ForEach(viewModel.areaNames, id: \.self) { item in
                            Button(action: {
                                areaName = item
                            }, label: {
                                Text(item)
                                    .foregroundColor(areaName == item ? .gray : .black)
                            })
                        }
                        
                    } label: {
                        HStack {
                            Text(areaName)
                                .foregroundColor(.primaryBlue)
                                .font(.system(size: 14, weight: .light))

                            Image(systemName: "chevron.forward")
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                        
                    }
                }
                .padding(.trailing,15)
                .padding(.leading, 30)

//                    NavigationLink(destination: LocationListView(isApplicationNameChanged: .constant(false), areaName: $areaName, selectedAreaName: areaName, tempSelectedAreaName: areaName, areaNamesArray: viewModel.areaNames)) {
//                        HStack {
//                            Text(areaName)
//                                .foregroundColor(.primaryBlue)
//                            Image(systemName: "chevron.forward")
//                                .foregroundColor(.gray)
//                                .frame(width: 15, height: 15)
//                        }
//                    }
                
                Divider()
                HStack {
                    Text("Reference number")
                    Spacer()
                    Button {
                        isShowingPopup.toggle()
                    } label: {
                        HStack {
                            Text(referenceNumber)
                                .foregroundColor(.primaryBlue)
                                .font(.system(size: 14, weight: .light))

                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15)
                        }
                    }

                    
                }
                .padding(.trailing, 15)
                .padding(.leading, 30)
                .padding(.bottom, 30)

                Button(action: {
                     
                    viewModel.classification[selectedRow][selectedIndexValue].name = applicationName
                    viewModel.classification[selectedRow][selectedIndexValue].logo = logo
                    viewModel.classification[selectedRow][selectedIndexValue].referenceNumber = referenceNumber
                    viewModel.classification[selectedRow][selectedIndexValue].areaName = areaName
                    updateModuleConfig(index: selectedIndexValue)
                    isApplicationNameChanged.toggle()

                    //print("Button Tapped")
                }){
                    HStack {
                        Spacer()
                        Text("Save the row")
                            .font(.system(size: 16, weight: .regular))
                            .padding()
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .background(Color.secondaryGreen)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                }
                
                Spacer()
            }
            
            if isShowingPopup {
                PopupView(isShowing: $isShowingPopup, refNumber: $referenceNumber)
                    .background(Color.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                    .padding(.top, -40)
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if !isLoaded {
                updateModuleConfig(index: selectedIndexValue)
                isLoaded = true
                updateScrollPosition.toggle()
                
            }
        }
        
    }
    
    private func updateModuleConfig(index: Int){
        areaName = mcbDetails[selectedIndexValue].areaName
        applicationName = mcbDetails[selectedIndexValue].name
        referenceNumber = mcbDetails[selectedIndexValue].referenceNumber
        logo = mcbDetails[selectedIndexValue].logo
    }
}

struct PopupView: View {
    @Binding var isShowing: Bool
    @Binding var refNumber: String
    @FocusState private var isTextFieldFocused: Bool
    @State var referencNo: String = ""

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Edit Reference number")
                    .padding(.bottom, 5)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color.secondaryGreen)
                    .multilineTextAlignment(.leading)
                
                TextField("", text: $referencNo)
                .frame(height: 40)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
                .focused($isTextFieldFocused)

                Divider()
                    .padding(.bottom, 30)
                    .padding(.top, -5)
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isShowing.toggle()
                    }) {
                        Text("CANCEL")
                            .padding(.all, 4)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 30)
                    
                    Button(action: {
                        refNumber = referencNo
                        isShowing.toggle()
                    }) {
                        Text("SAVE")
                            .foregroundColor(.black)
                            .padding(.all, 4)
                    }
                    .padding(.trailing, 10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            Spacer()
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            isTextFieldFocused = true
            referencNo = refNumber
        }
        .onDisappear {
            isTextFieldFocused = false
        }
    }
}

