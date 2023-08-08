//
//  CustomTextField.swift
//  HayEquipo
//
//  Created by David Gomez on 27/05/2023.
//

import SwiftUI

extension LocalizedStringKey {

    // This will mirror the `LocalizedStringKey` so it can access its
    // internal `key` property. Mirroring is rather expensive, but it
    // should be fine performance-wise, unless you are
    // using it too much or doing something out of the norm.
    var stringKey: String {
        (Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value ?? "") as! String
    }
}


class CustomTextFieldManager: ObservableObject {
    @Published var text: String = ""
    @Published var footerIsVisible: Bool = true
    @Published var titleIsVisible = true
    @Published var isEditing: Bool = false
    @Published var shouldShowError: Bool = false
    var message: LocalizedStringKey = ""
    
    func showError(message: LocalizedStringKey) {
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
        case phoneNumber
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
        static let footerForegroundColor: Color = Color.Red.medium
        static let footerBackgroundColor: Color = .clear
        static let footerFont: Font = .system(size: 15)
        static let titleForegroundColor: Color = Color(hex: "#545454")!
        static let secondaryColor: Color = Color(hex: "#BA1A1A")!
        static let animationDuration: TimeInterval = 0.3
        static let bodyHeight: CGFloat = 56
    }
    
    @State var title: LocalizedStringKey
    @State var placeholder: LocalizedStringKey
    @State var footer: LocalizedStringKey
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
                if !(!customTextFieldManager.shouldShowError && footer.stringKey.isEmpty) {
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
        case .phoneNumber:
            validatePhoneNumber(text)
        }
    }
    
    // Add a new property to your ViewModel to keep track of the last known count
    @State private var lastKnownCharacterCount = 0

    func validatePhoneNumber(_ number: String) {
        
        // Strip the number of everything other than digits
        let strippedNumber = number.filter { "0123456789".contains($0) }

        // Detect if backspacing
        let isBackspacing = strippedNumber.count < lastKnownCharacterCount

        // Update the last known count
        lastKnownCharacterCount = strippedNumber.count

        // Handle the case of backspacing through the country code
        if isBackspacing && strippedNumber.count == 2 {
            self.customTextFieldManager.text = "(+" + strippedNumber.prefix(1)
            return
        }

        // If more than 10 digits, do not proceed with further formatting.
        guard strippedNumber.count <= 12 else {
            self.customTextFieldManager.text.removeLast()
            return
        }

        // Split the country code from the rest of the number
        let countryCode = strippedNumber.prefix(2) // Take the first two digits for country code
        let userEnteredNumber = strippedNumber.dropFirst(2) // Drop the country code

        let formattedNumber: String
        switch userEnteredNumber.count {
        case 0 where countryCode.count == 1:
            formattedNumber = "(+" + String(countryCode)
        case 1:
            formattedNumber = "(+" + String(countryCode) + ") " + String(userEnteredNumber)
        case 2...4:
            formattedNumber = "(+" + String(countryCode) + ") " + userEnteredNumber
        case 5...7:
            let endIndex = userEnteredNumber.index(userEnteredNumber.startIndex, offsetBy: 3)
            formattedNumber = "(+" + String(countryCode) + ") " + userEnteredNumber[..<endIndex] + "-" + userEnteredNumber[endIndex...]
        case 8...:
            let firstIndex = userEnteredNumber.index(userEnteredNumber.startIndex, offsetBy: 3)
            let secondIndex = userEnteredNumber.index(userEnteredNumber.startIndex, offsetBy: 6)
            formattedNumber = "(+" + String(countryCode) + ") " + userEnteredNumber[..<firstIndex] + "-" + userEnteredNumber[firstIndex..<secondIndex] + "-" + userEnteredNumber[secondIndex...]
        default:
            formattedNumber = "(+" + String(countryCode) + ") " + userEnteredNumber
        }

        self.customTextFieldManager.text = formattedNumber
    }


}
