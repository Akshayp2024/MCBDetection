//
//  MCBCellView.swift
//  MCBModel
//
//  Created by Ayesha Siddiqua on 20/02/24.
//

import SwiftUI

struct AddRowCellView: View {
    let row: Int
    let action: (Int) -> Void
    var body: some View {
        VStack {
            Button(action: {
                action(row)
            }, label: {
                VStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30,height: 30, alignment: .center)
                        .foregroundColor(Color.secondaryGreen)
                        .padding(.top,3)
                    Text("ADD")
                        .foregroundStyle(Color.secondaryGreen)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .background(Color.white)
                .frame(height: 102)
            })
        }
    }
}

struct MCBCellView: View {
    
    @ObservedObject var mcbDetails: MCBDetails

    @State var logo = ""
    @State var applicationName = ""
    @State var referenceNumber = ""
    @State var selectedAreaOption = ""
    var options: [String] = []
    var color: Color = .secondaryGreen
    let action: (()-> Void)

    var body: some View {
        VStack(alignment:.center) {
            VStack(spacing: 5) {
                VStack {
                    Image(systemName: logo)
                        .resizable()
                        .frame(width: 15,height: 15, alignment: .center)
                        .foregroundColor(color)
                        .padding(.top,3)
                    Text(applicationName)
                        .foregroundStyle(color)
                        .font(.system(size: 9, weight: .regular))
                        .lineLimit(1)
                }
                .onTapGesture {
                    action()
                }
                
                Menu{
                    ForEach(options, id: \.self) { item in
                        Button(action: {
                            selectedAreaOption = item
                            self.mcbDetails.areaName = item
                        }, label: {
                            Text(item)
                                .foregroundColor(selectedAreaOption == item ? .gray : .black)
                        })
                    }
                    
                } label: {
                    HStack {
                        
                        Text(selectedAreaOption)
                            .foregroundColor(.white)
                            .font(.caption2)
                            .padding(.vertical, 2)
                    }
                    .frame(width: labelValues(rowLabel:referenceNumber))
                    .background(color)
                }
                
            }
            .padding(.top,2)
            .padding(.bottom,10)
            VStack {
                Text("Ref No:")
                    .foregroundStyle(.black)
                    .font(.system(size: 8, weight: .light))
                Text(referenceNumber)
                    .lineLimit(2)
                    .foregroundStyle(.black)
                    .font(.system(size: 9, weight: .medium))
            }
            .padding(.bottom, 10)
            .onTapGesture {
                action()
            }
        }
        
        .frame(width: labelValues(rowLabel:referenceNumber))
        .background(.white)
        .onAppear{
            logo = mcbDetails.logo
            applicationName = mcbDetails.name
            selectedAreaOption = mcbDetails.areaName
            referenceNumber = mcbDetails.referenceNumber
            
        }
        .onChange(of: mcbDetails.name) { oldValue, newValue in
            logo = mcbDetails.logo
            applicationName = mcbDetails.name
            selectedAreaOption = mcbDetails.areaName
        }
        .onChange(of: mcbDetails.referenceNumber) { oldValue, newValue in
            referenceNumber = mcbDetails.referenceNumber
        }
        .onChange(of: mcbDetails.areaName) { oldValue, newValue in
            selectedAreaOption = mcbDetails.areaName
        }
    }
}


struct MCBDetailsCellView: View {
    
    @ObservedObject var mcbDetails: MCBDetails

    @State var logo = ""
    @State var applicationName = ""
    @State var referenceNumber = ""
    @State var selectedAreaOption = ""
    var options: [String] = []
    var color: Color = .darkGreen

    var body: some View {
        VStack(alignment:.center) {
            VStack(spacing:5) {
                VStack {
                    Spacer()
                    Image(systemName: logo)
                        .resizable()
                        .frame(width: 15,height: 15, alignment: .center)
                        .foregroundColor(color)
                        .padding(.top,3)
                    Text(applicationName)
                        .lineLimit(2)
                        .foregroundStyle(color)
                        .font(.system(size: 9, weight: .regular))
                        .lineLimit(1)
                    Spacer()
                    Menu{
                        ForEach(options, id: \.self) { item in
                            Button(action: {
                                selectedAreaOption = item
                                self.mcbDetails.areaName = item
                            }, label: {
                                Text(item)
                                    .foregroundColor(selectedAreaOption == item ? .gray : .black)
                            })
                        }
                        
                    } label: {
                        HStack {
                            Text(selectedAreaOption)
                                .lineLimit(2)
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                        .frame(width: labelValues(rowLabel:referenceNumber), height: 35 )
                        .background(color)
                    }
                }
            }
            .padding(.top,2)
            .padding(.bottom,10)
            VStack {
                Spacer()
                Text("Ref No:")
                    .foregroundStyle(.black)
                    .font(.system(size: 8, weight: .light))
                Text(referenceNumber)
                    .lineLimit(2)
                    .foregroundStyle(.black)
                    .font(.system(size: 9, weight: .medium))
                Spacer()
            }
            .padding(.bottom, 10)
        }
        .frame(width: labelValues(rowLabel:referenceNumber), height:  200)
        .background(.white)
        .onAppear{
            logo = mcbDetails.logo
            applicationName = mcbDetails.name
            selectedAreaOption = mcbDetails.areaName
            referenceNumber = mcbDetails.referenceNumber
            
        }
        .onChange(of: mcbDetails.name) { oldValue, newValue in
            logo = mcbDetails.logo
            applicationName = mcbDetails.name
            selectedAreaOption = mcbDetails.areaName
        }
        .onChange(of: mcbDetails.referenceNumber) { oldValue, newValue in
            referenceNumber = mcbDetails.referenceNumber
        }
        .onChange(of: mcbDetails.areaName) { oldValue, newValue in
            selectedAreaOption = mcbDetails.areaName
        }
    }
}


func labelValues(rowLabel:String) -> CGFloat{
    
    switch rowLabel {
    case "R9S06391": return 100
    case "R9S06291": return 95
    case "N/A": return 80
    default: return 70
    }
}
