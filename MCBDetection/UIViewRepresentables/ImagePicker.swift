//
//  ImagePicker.swift
//  MCBDetection
//
//  Created by Ayesha Siddiqua on 14/02/24.
//

import SwiftUI
import Vision
import CoreML

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var vm: ViewModel
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewmodel: vm)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        var viewModel: ViewModel
        var detector = ObjectDetection(vm: ViewModel())
        
        init(_ parent: ImagePicker, viewmodel: ViewModel) {
            self.parent = parent
            self.viewModel = viewmodel
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                //Converting the UIImage to CIImage
                if let ciImage = CIImage(image: parent.selectedImage!) {
                    let (mcbLabel, mcbArray) = detector.detectAndProcess(image: ciImage)
                    viewModel.classification1 = mcbLabel
                    viewModel.classification = mcbArray
                    backhroundImage = image
                    for _ in 0 ..< viewModel.classification.count {
                        viewModel.rowCountUUID.append(UUID().uuidString)
                    }
                    viewModel.isMCBProcesed = true

//                    ForEach(viewModel.classification1, id: \.self){ row  in
//                        ForEach(row, id: \.self) { column in
//                            var item = MCBDetails(logo:  self.viewModel.logos.randomElement()!, name: self.viewModel.applicationNames.randomElement()!, areaName:  self.viewModel.areaNames.randomElement()!,referenceNumber: column)
//                            viewModel.arrayOfmcbDetails.append(item)
//                        }
//                        
//                    }
                    //viewModel.arrayOfmcbDetails =  viewModel.all(classification: viewModel.classification1)
                    //viewModel.isImageUploaded = true
                   
                   // viewModel.classification1 = detector.row1Labels
                    //viewModel.classification2 = detector.row2Labels
                    // New */
                }
                else {
                    print("CIImage convert error")
                }
                parent.presentationMode.wrappedValue.dismiss()
                
            }
           
        }
        
    }
    
}
