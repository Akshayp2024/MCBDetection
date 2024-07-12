//
//  View+Extension.swift
//  MCBDetection
//
//  Created by Akshay Suresh Patil on 21/06/24.
//

import Foundation
import SwiftUI

extension View {
    func toImage(scale: CGFloat = 10.0) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func toPDF(scale: CGFloat = 10.0) -> Data {
        let image = self.toImage(scale: scale)
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        
        var mediaBox = CGRect(origin: .zero, size: image.size)
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPDFPage(nil)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPDFPage()
        pdfContext.closePDF()
        
        return pdfData as Data
    }
}


extension Color {
    static let darkGreen = Color.init(cgColor: .init(red: 65/255, green: 123/255, blue: 40/255, alpha: 1))
    static let primaryGray = Color.init(cgColor: .init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1))
    static let primaryGreen = Color.init(cgColor: .init(red: 75/255, green: 185/255, blue: 43/255, alpha: 1))

    static let secondaryGreen = Color.init(cgColor: .init(red: 36/255, green: 143/255, blue: 22/255, alpha: 1))
    static let primaryBlue = Color.init(cgColor: .init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1))
}


extension AnyTransition {
    static var flipEffect: AnyTransition {
        let insertion = AnyTransition.modifier(
            active: FlipEffectModifier(rotationAngle: 0),
            identity: FlipEffectModifier(rotationAngle: 0)
        )
        let removal = AnyTransition.modifier(
            active: FlipEffectModifier(rotationAngle: 180),
            identity: FlipEffectModifier(rotationAngle: -180)
        )
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct FlipEffectModifier: ViewModifier {
    let rotationAngle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
    }
}


extension View {
    func halfSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.background(
            HalfSheet(isPresented: isPresented, content: content)
        )
    }
}

struct HalfSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }

                VStack {
                    Spacer()
                    content
                        .frame(height: UIScreen.main.bounds.height / 2)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
