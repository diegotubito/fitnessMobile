//
//  CustomTextField.swift
//  HayEquipo
//
//  Created by David Gomez on 27/05/2023.
//

import SwiftUI

class CustomTextFieldManager: ObservableObject {
    @Published var text: String = ""
    @Published var footerIsVisible: Bool = true
    @Published var titleIsVisible = true
    @Published var isEditing: Bool = false
    @Published var shouldShowError: Bool = false
    var message: String = ""
    
    func showError(message: String) {
        withAnimation {
            shouldShowError = true
            self.message = message
            self.footerIsVisible = true
        }
    }
    
    func hideError() {
        withAnimation {
            self.footerIsVisible = false
            self.message = ""
            self.shouldShowError = false
        }
    }
}

struct CustomTextField: View {
    @ObservedObject var customTextFieldManager: CustomTextFieldManager
    
    enum TextFieldType {
        case currency(withDecimals: Bool)
        case ascii
    }
    
    enum FocusedField {
        case price
        case none
    }
  
    struct Constants {
        static let backgroundColor: Color = Asset.Colors.Neutral.wash.swiftUIColor
        static let backgroundColorFocused: Color = Color(hex: "EBF6FF")!
        static let titleFont: Font = .system(size: 16, weight: .medium)
        static let titleTextColor: Color = Color(hex: "212121")!
        static let placeholderTextColor: Color = Color(hex: "#545454")!
        static let textFieldTextColor: Color = Color(hex: "#212121")!
        static let textFieldFont: Font = .system(size: 16)
        static let maxMargin: CGFloat = 16
        static let midMargin: CGFloat = 8
        static let separatorColor: Color = Color(hex: "#E0E0E0")!
        static let footerForegroundColor: Color = Color(hex: "#545454")!
        static let footerBackgroundColor: Color = .clear
        static let footerFont: Font = .system(size: 14)
        static let titleForegroundColor: Color = Color(hex: "#545454")!
        static let secondaryColor: Color = Color(hex: "#BA1A1A")!
        static let animationDuration: TimeInterval = 0.3
        static let bodyHeight: CGFloat = 56
    }
    
    @State var title: String
    @State var placeholder: String
    @State var footer: String
    @State var textFieldType: TextFieldType = .ascii
    
    var onChanged: ((String) -> Void)?
    var onDidBegin: ((Bool) -> Void)?

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if customTextFieldManager.titleIsVisible {
                    HStack {
                        Text(title)
                            .font(Constants.titleFont)
                            .foregroundColor(Constants.titleTextColor)
                            .foregroundColor(Constants.titleForegroundColor)
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                
                TextField(placeholder, text: $customTextFieldManager.text) { beginEditing in
                    withAnimation {
                        onDidBegin?(beginEditing)
                        customTextFieldManager.isEditing = beginEditing
                    }
                }
                .keyboardType(.default)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .price)
                .font(Constants.textFieldFont)
                .foregroundColor(Constants.textFieldTextColor)
                .onChange(of: customTextFieldManager.text, perform: { newValue in
                    validateText(newValue)
                    onChanged?(newValue)
                })
                .padding(.top, 8)
                
            }
            .padding(.horizontal)
            .background(customTextFieldManager.isEditing ? Constants.backgroundColorFocused : Constants.backgroundColor)
            
            Divider()
                .frame(height: customTextFieldManager.shouldShowError ? 2 : 1)
                .background(customTextFieldManager.shouldShowError ? Constants.secondaryColor : Constants.separatorColor)
               
            if customTextFieldManager.footerIsVisible {
                if !(!customTextFieldManager.shouldShowError && footer.isEmpty) {
                    HStack {
                        Text(customTextFieldManager.shouldShowError ? customTextFieldManager.message : footer)
                            .font(Constants.footerFont)
                            .foregroundColor(customTextFieldManager.shouldShowError ? Constants.secondaryColor : Constants.footerForegroundColor)
                            .background(Constants.footerBackgroundColor)
                        Spacer()
                    }
                }
            }
        }
        .cornerRadius(10)
        .onTapGesture {
            focusedField = .price
        }
    }
    
    func validateText(_ text: String) {
        switch textFieldType {
        case .currency(withDecimals: let withDecimals):
            let maxAmount: Double = 999999999
            // Get the current text, or "" if nil
            let currentText = text
            
            // Remove any formatting
            let strippedReplacement = currentText.filter { "0123456789".contains($0) }
            
            if let number = Double(strippedReplacement) {
                let value = NSNumber(value: number / (withDecimals ? 100 : 1) )
                if value.doubleValue > maxAmount {
                    self.customTextFieldManager.text.removeLast()
                    return
                }
                
                let formattedText = number.asCurrencyFormat(withDecimals: withDecimals)
                self.customTextFieldManager.text = formattedText
            } else {
                if !self.customTextFieldManager.text.isEmpty {
                    self.customTextFieldManager.text.removeLast()
                }
            }
        case .ascii:
            break
        }
    }
}
