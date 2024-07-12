//
//  EditableLabel.swift
//  MCBModel
//
//  Created by Ayesha Siddiqua on 20/02/24.
//

import SwiftUI

@available(macOS 10.15, *)
public struct EditableLabel: View {
    
    @Binding var text: String
    @State private var newValue: String = ""
    @State var editProcessGoing = false 
    {
        didSet {
            newValue = text
        }
    }
    
    let onEditEnd: () -> Void
    
    public init(_ txt: Binding<String>, onEditEnd: @escaping () -> Void) {
        _text = txt
        self.onEditEnd = onEditEnd
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            // Text variation of View
            Text(text)
                .opacity(editProcessGoing ? 0 : 1)
            
            // TextField for edit mode of View
            TextField("", text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { text = newValue; editProcessGoing = false; onEditEnd() } )
                .opacity(editProcessGoing ? 1 : 0)
        }
        .onTapGesture(count: 1, perform: { editProcessGoing = true } )
    }
}

