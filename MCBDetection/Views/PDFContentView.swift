//
//  PDFContentView.swift
//  MCBDetection
//
//  Created by Akshay Suresh Patil on 21/06/24.
//

import SwiftUI

struct PDFContentView: View {
    @State var classification: [[MCBDetails]] = []

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Text("Label 1234")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.darkGreen)
                        .padding(.leading)
                    Spacer()
                }
                RulerView()
                    .padding(.horizontal)
            }
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(classification.indices, id: \.self){ index  in
                    RowView(rowTitle: "Row \(index + 1)", mcbRowDetails: classification[index])
                }
            }
            .padding(.horizontal)
            
            Spacer()
            VStack {
                Spacer()
                Divider()
                HStack {
                    Text("1/1")
                        .font(.caption2)
                        .fontWeight(.light)
                    Spacer()
                    Text(Date().getFormattedTimeString(outPutDateFormate: .ddMMYYYY, date: Date()) ?? "")
                        .font(.system(size: 10, weight: .light))
                }
                .padding(.bottom, 15)
            }
        }
        .padding()
    }
}

struct RowView: View {
    let rowTitle: String
//    let items: [(label: String, location: String, image: String)]
    @State var mcbRowDetails: [MCBDetails] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(rowTitle)
                .font(.caption2)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(mcbRowDetails.enumerated()), id: \.element.id) { index, item in
                        VStack(alignment: .center) {
                            Image(systemName: item.logo) // Replace with actual images
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.darkGreen)

                            Text(item.name)
                                .font(.system(size: 5, weight: .light))
                                .foregroundColor(.darkGreen)

                            HStack {
                                Spacer()
                                Text(item.areaName)
                                    .font(.system(size: 7, weight: .light))
                                    .padding(.vertical, 2)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .background(Color.darkGreen)
                        }
                        .padding(.trailing, 1)
                    }
                }
            }
        }
    }
}

struct RulerView: View {
    var body: some View {
        VStack {
            HStack {
                Text("0")
                    .font(.system(size: 8, weight: .light))
                Spacer()
                Text("100 mm")
                    .font(.system(size: 8, weight: .light))
            }
            .padding(.horizontal)

            RulerShape()
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 20)
                .padding(.horizontal)
        }
    }
}

struct RulerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Draw the main horizontal line
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        // Draw the vertical ticks
        let numberOfTicks = 11
        let tickSpacing = rect.width / CGFloat(numberOfTicks - 1)

        for i in 0..<numberOfTicks {
            let x = CGFloat(i) * tickSpacing
            path.move(to: CGPoint(x: x, y: rect.midY - 5))
            path.addLine(to: CGPoint(x: x, y: rect.midY + 5))
        }

        return path
    }
}

#Preview {
    PDFContentView()
}
