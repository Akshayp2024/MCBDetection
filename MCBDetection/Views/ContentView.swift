//
//  ContentView.swift
//  MCBDetection
//
//  Created by Ayesha Siddiqua on 14/02/24.
//

import SwiftUI
import Vision
import UIKit

var backhroundImage: UIImage?

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack(alignment: .center) {
                    ZStack {
                        HStack {
                            Spacer()
                            Text("MCB Detection")
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .font(.system(size: 24))
                            Spacer()
                        }
                        .padding([.bottom])
                        if viewModel.classification.count > 0 { //&& viewModel.image != nil
                            HStack {
                                Spacer()
                                if !viewModel.showBackgroundImage && !viewModel.editList {
                                    Button {
                                        withAnimation {
                                            viewModel.editList.toggle()
                                        }
                                    } label: {
                                        Image(systemName: viewModel.editList ? "text.badge.checkmark" : "pencil.and.list.clipboard")
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                if let _ = viewModel.image {
                                    Button {
                                        imageFlip()
                                        withAnimation {
                                            if viewModel.showBackgroundImage {
                                                viewModel.editList = false
                                            }
                                        }
                                    } label: {
                                        Image(systemName: viewModel.showBackgroundImage ? "list.bullet" : "photo.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.trailing, 30)
                                }else{
                                    Spacer().frame(width: 20)
                                }
                            }
                        }
                    }
                }
                .background(Color.secondaryGreen)
                Spacer()
                if viewModel.isMCBProcesed {
                    if viewModel.classification.count > 0 {
                        ZStack {
                            if let image = viewModel.image {
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .edgesIgnoringSafeArea(.all)
                                        .onTapGesture(count: 2) {
                                            imageFlip()
                                        }
                                        .opacity(viewModel.showBackgroundImage ? 1 : 0)
                                        .rotation3DEffect(.degrees(viewModel.showBackgroundImage ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                                    Spacer()
                                }
                            }
                            
                            ZStack {
                                if let image = viewModel.image {
                                    VStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .clipped()
                                            .edgesIgnoringSafeArea(.all)
                                            .blur(radius: 3)
                                        Spacer()
                                    }
                                }
                                
                                ScrollViewReader(content: { verticleProxy in
                                    ScrollView(.vertical, showsIndicators: false) {
                                        Grid {
                                            GridRow {
                                                VStack(alignment:.leading, spacing: 5) {
                                                    //Rows
                                                    ForEach(viewModel.classification.indices, id: \.self){ row  in
                                                        HStack {
                                                            Button {
                                                                viewModel.slectedRow = row
                                                                viewModel.selectedIndex = 0
                                                                path.append(NavigationRoute.detailView)
                                                                viewModel.shouldNavigateToRowDetails = true
                                                                
                                                            } label: {
                                                                
                                                                HStack {
                                                                    Image(systemName: "pencil")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .foregroundColor(.black)
                                                                        .frame(width: 12, height: 12)
                                                                        .padding(.leading, 8)
                                                                    
                                                                    Text("Edit the row \(row + 1)")
                                                                        .foregroundStyle(.black)
                                                                        .font(.system(size: 14))
                                                                        .fontWeight(.light)
                                                                    Spacer()
                                                                }
                                                                
                                                            }
                                                            
                                                            if viewModel.editList {
                                                                Button {
                                                                    viewModel.classification.remove(at: row)
                                                                    if viewModel.classification.count == 0 {
                                                                        viewModel.image = nil
                                                                        backhroundImage = nil
                                                                        viewModel.editList = false
                                                                    }
                                                                } label: {
                                                                    Image(systemName: "multiply.circle")
                                                                        .resizable()
                                                                        .frame(width: 15, height: 15, alignment: .center)
                                                                        .foregroundColor(.black)
                                                                        .padding(.trailing, 10)
                                                                }
                                                            }
                                                        }
                                                        .frame(width:UIScreen.main.bounds.width - 70,height: 30,alignment: .leading)
                                                        .background(.white)
                                                        .cornerRadius(3)
                                                        .padding(.top,15)
                                                        
                                                        ScrollViewReader(content: { proxy in
                                                            
                                                            ScrollView(.horizontal, showsIndicators: false) {
                                                                HStack(spacing:1) {
                                                                    ForEach(Array(viewModel.classification[row].enumerated()), id: \.element.id) { index, column in
                                                                        
                                                                        MCBCellView(mcbDetails: column, options: viewModel.areaNames) {
                                                                            viewModel.slectedRow = row
                                                                            viewModel.selectedIndex = index
                                                                            path.append(NavigationRoute.detailView)
                                                                            viewModel.shouldNavigateToRowDetails = true
                                                                            
                                                                        }
                                                                    }
                                                                    if viewModel.rowCountUUID.count > 0 {
                                                                        AddRowCellView(row: row) { selectedRow in
                                                                            viewModel.classification[selectedRow].append(viewModel.all(rowNumber: selectedRow, referenceNumber: "N/A"))
                                                                            viewModel.scrollStaticId = viewModel.rowCountUUID[row]
                                                                            viewModel.endOfScroll.toggle()
                                                                        }
                                                                        .id(viewModel.rowCountUUID[row])
                                                                    }
                                                                }
                                                            }
                                                            .onChange(of: viewModel.endOfScroll) { oldValue, newValue in
                                                                withAnimation {
                                                                    proxy.scrollTo(viewModel.scrollStaticId)
                                                                }
                                                            }
                                                        })
                                                        .id(row)
                                                    }
                                                    
                                                    
                                                }
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight:.infinity)
                                            }
                                            .padding(.bottom,30)
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 70)
                                        .onTapGesture(count: 2) {
                                            imageFlip()
                                        }
                                        
                                        VStack {
                                            Button {
                                                viewModel.showEmptyRowSheet = true
                                            } label: {
                                                HStack {
                                                    Spacer()
                                                    Text("Add MCB")
                                                        .padding()
                                                    Spacer()
                                                }
                                                .foregroundColor(.white)
                                                .background(viewModel.editList ? Color.gray.opacity(0.8) : Color.secondaryGreen)
                                                .cornerRadius(10)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .disabled(viewModel.editList)
                                    }
                                    .onChange(of: viewModel.endOfVerticalScroll) { oldValue, newValue in
                                        verticleProxy.scrollTo((viewModel.classification.count - 1))
                                    }
                                    .onTapGesture(count: 2) {
                                        imageFlip()
                                    }
                                })
                            }
                            .opacity(viewModel.showBackgroundImage ? 0 : 1)
                            .rotation3DEffect(.degrees(viewModel.showBackgroundImage ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            
                        }
                        .background(
                            Color.gray
                                .opacity(0.5)
                                .onTapGesture(count: 2) {
                                    imageFlip()
                                }
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                    }
                    else {
                        Text("NO MCB FOUND")
                            .foregroundStyle(Color.secondaryGreen)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                }
                else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                        .frame(width:350,height: 400)
                        .foregroundStyle(Color.secondaryGreen)
                }
                Spacer()
                
               
                if !viewModel.editList || viewModel.classification.count == 0 {
                    VStack(spacing: 10) {
                        
                        HStack(spacing: 10) {
                            
                            if !viewModel.isMCBProcesed || viewModel.classification.count == 0 {
                                Spacer()
                                Button {
                                    viewModel.showEmptyRowSheet = true
                                } label: {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Image(systemName: "number")
                                                .padding([.horizontal, .top])
                                                .padding(.bottom, 5)
                                            Text("+ MCB")
                                                .font(.system(size: 12, weight: .light))
                                                .padding([.horizontal, .bottom])
                                        }
                                        Spacer()
                                    }
                                    .foregroundColor(.white)
                                    .background(Color.secondaryGreen)
                                    .cornerRadius(10)
                                }
                            }
                            Spacer()
                            Button {
                                viewModel.source = .camera
                                viewModel.showPicker = true
                            } label: {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "camera")
                                            .padding([.horizontal, .top])
                                            .padding(.bottom, 5)
                                        Text("Camera")
                                            .padding([.horizontal, .bottom])
                                            .font(.system(size: 12, weight: .light))
                                    }
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .background(Color.secondaryGreen)
                                .cornerRadius(10)
                            }
                            Spacer()
                            Button {
                                viewModel.source = .library
                                viewModel.showPicker = true
                            } label: {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "photo.on.rectangle")
                                            .padding([.horizontal, .top])
                                            .padding(.bottom, 5)
                                        Text("Photo")
                                            .font(.system(size: 12, weight: .light))
                                            .padding([.horizontal, .bottom])
                                    }
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .background(Color.secondaryGreen)
                                .cornerRadius(10)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        /*
                        if viewModel.image != nil && viewModel.classification.count > 0 {
                            Button {
                                createPDFWith()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Export PDF")
                                        .padding()
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .background(Color.secondaryGreen)
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                            }
                        }
                       //  */
                    }
                    .padding(.bottom, 5)
                }else{
                    if !viewModel.showBackgroundImage {
                        Button {
                            withAnimation {
                                viewModel.editList.toggle()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Save MCB List")
                                    .padding()
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .background(Color.secondaryGreen)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                
            }
            .background(
                Color.clear.onTapGesture(count: 2) {
                    imageFlip()
                }
            )
            .sheet(isPresented: $viewModel.showEmptyRowSheet) {
                AddMCBRowView(viewModel: viewModel, isPresented: $viewModel.showEmptyRowSheet, endOfVerticalScroll: $viewModel.endOfVerticalScroll)
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.showPicker) {
                ImagePicker(vm: viewModel, selectedImage: $viewModel.image, sourceType: viewModel.source == .library ? .photoLibrary : .camera)
            }
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .detailView:
                    LabellingRowView(mcbDetails: viewModel.classification[viewModel.slectedRow], selectedRow: viewModel.slectedRow, viewModel: viewModel, selectedIndexValue: viewModel.selectedIndex)
                }
            }
            
        }
        .onChange(of:viewModel.isImageUploaded) {
            print("Image uploaded")
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color.gray)
    }
    
    private func imageFlip(){
        if viewModel.classification.count > 0 && viewModel.image != nil{
            withAnimation {
                viewModel.showBackgroundImage = !viewModel.showBackgroundImage
            }
        }
    }
    
    private func createPDFWith(){
        let pdfData = PDFContentView(classification: viewModel.classification).toPDF()
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("MCB_Pannel_\(Date().timeIntervalSince1970).pdf")
        do {
            try pdfData.write(to: tempURL)
            let activityController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(activityController, animated: true, completion: nil)
            }
        } catch {
            print("Could not save PDF file: \(error.localizedDescription)")
        }
    }
    
}

enum NavigationRoute: Hashable {
    case detailView
}
