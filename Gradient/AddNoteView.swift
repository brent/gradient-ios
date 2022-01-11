//
//  AddNoteView.swift
//  Gradient
//
//  Created by Brent Meyer on 1/9/22.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    @Binding var noteContent: String

    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .font(.system(size: 48))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                .padding(.top, 16)
                .onTapGesture {
                    dismiss()
                }

            TextEditor(text: $noteContent)
                .frame(maxHeight: .infinity)
                .padding(.vertical)
                .focused($isFocused)

            Button {
                dismiss()
            } label: {
                Text("Save")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color(red: 0.34, green: 0.68, blue: 0.45))
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFocused = true
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(noteContent: .constant("Text"))
    }
}
