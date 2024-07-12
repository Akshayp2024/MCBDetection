//
//  AddMCBRowView.swift
//  MCBDetection
//
//  Created by Akshay Suresh Patil on 26/06/24.
//

import Foundation
import SwiftUI

struct AddMCBRowView: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var isPresented: Bool
    @Binding var endOfVerticalScroll: Bool

    @State var maxModule: [Int] = [4, 6, 8, 12, 18]
    @State var noOfRows: [Int] = [1, 2, 3]
    @State var selctedModule: Int = 0
    @State var selctedRow: Int = 0
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Empty row")
                    .font(.headline)
                    .padding()
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 40)
            .padding(.top, 5)
            Divider()
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        Image(systemName: "lightswitch.off")
                            .resizable()
                            .frame(width: 10, height: 20, alignment: .center)
                            .foregroundColor(.secondaryGreen)
                            .padding(.leading, 30)
                        Text("Select the max number of modules per row")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .light))
                            .padding([.bottom, .top], 10)
                            .padding(.leading, 15)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 70, height: 20)
                        
                        ForEach(maxModule, id: \.self){ module  in
                            Button {
                                selctedModule = module
                            } label: {
                                Text("\(module)")
                                    .padding()
                                    .frame(width: 50, height: 30)
                                    .border(.gray, width: 1)
                                    .background(selctedModule == module ? Color.gray : Color.white)
                                    .foregroundColor(selctedModule == module ? Color.white : Color.black)
                            }
                        }
                        Spacer()
                    }
                    
                }
                
                VStack {
                    HStack {
                        Image(systemName: "number")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.secondaryGreen)
                            .padding(.leading, 30)
                        Text("Select the number of rows")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .light))
                            .padding([.bottom, .top], 10)
                            .padding(.leading, 5)
                        Spacer()
                    }
                    
                    
                    HStack {
                        Spacer()
                            .frame(width: 70, height: 20)
                        
                        ForEach(noOfRows, id: \.self){ row  in
                            Button {
                                selctedRow = row
                            } label: {
                                Text("\(row)")
                                    .padding()
                                    .frame(width: 50, height: 30)
                                    .border(.gray, width: 1)
                                    .background(selctedRow == row ? Color.gray : Color.white)
                                    .foregroundColor(selctedRow == row ? Color.white : Color.black)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
                Spacer()
            }
            
            Button(action: {
                //print("Button Tapped")
                if selctedModule != 0 && selctedRow != 0 {

                    for _ in 0 ..< selctedRow {
                        var arrayOfMCB: [MCBDetails] = []
                        for _ in 0 ..< selctedModule {
                            arrayOfMCB.append(viewModel.all(referenceNumber: "N/A"))
                        }
                        viewModel.classification.append(arrayOfMCB)
                    }
                    viewModel.rowCountUUID = []
                    
                    for _ in 0 ..< viewModel.classification.count {
                        viewModel.rowCountUUID.append(UUID().uuidString)
                    }
                    
                    viewModel.isMCBProcesed = true
                    isPresented = false
                    endOfVerticalScroll.toggle()
                }
            }){
                HStack {
                    Spacer()
                    Text("Continue")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
