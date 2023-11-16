//
//  SingleSelector.swift
//  HayEquipo
//
//  Created by David Gomez on 27/05/2023.
//

import SwiftUI

class SingleSelectorManager: ObservableObject {
    @Published var selectedOption: String? = nil
    @Published var options: [OptionModel] = []
    
    struct OptionModel: Identifiable, Hashable {
        let id: String
        let title: String
        let subtitle: String
    }
    
    func isSelected(_ _id: String) -> Bool {
        if selectedOption == _id {
            return true
        } else {
           return false
        }
    }
}

struct SingleSelectorView: View {
    @ObservedObject var singleSelectorManager: SingleSelectorManager
    
    private struct Constants {
        static let imageSize: CGFloat = 25
        static let maxMargin: CGFloat = 16
        static let midMargin: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let titleLabelFont: Font = .system(size: 16)
        static let subtitleLabelFont: Font = .system(size: 14)
        static let titleLabelTextColor: Color = Color(hex: "#212121")!
        static let subtitleLabelTextColor: Color = Color(hex: "#757575")!
        static let selectedBorderColor: Color = Color(hex: "2196F5")!
        static let deselectedBorderColor: Color = Color(hex: "#DCDFE8")!
        static let selectedBackgroundColor: Color = Color(hex: "#EBF6FF")!
        static let deselectedBackgroundColor: Color = Color(hex: "FAFAFA")!
        static let borderWidth: CGFloat = 1
        static let imageForSelectedOption: String = "circle.inset.filled"
        static let imageForDeselectedOption: String = "circlebadge"
        static let imageForegroundColorSelected: Color = Color(hex: "2196F5")!
        static let imageForegroundColorDeselected: Color = Color(hex: "DCDFE8")!
    }
    
    var onSelectedOption: ((String?) -> Void)?
    
    fileprivate func mainView(_id: String, option: SingleSelectorManager.OptionModel) -> some View {
        return HStack(alignment: .top, spacing: 0) {
            VStack(spacing: Constants.midMargin) {
                HStack(spacing: 0) {
                    Text(option.title)
                        .font(Constants.titleLabelFont)
                        .foregroundColor(Constants.titleLabelTextColor)
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Text(option.subtitle)
                        .font(Constants.subtitleLabelFont)
                        .foregroundColor(Constants.subtitleLabelTextColor)
                    
                    Spacer()
                }
            }
            
            Image(systemName: singleSelectorManager.isSelected(_id) ? Constants.imageForSelectedOption: Constants.imageForDeselectedOption)
                .resizable()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .foregroundColor(singleSelectorManager.isSelected(_id) ? Constants.imageForegroundColorSelected : Constants.imageForegroundColorDeselected)
            
        }
        .contentShape( RoundedRectangle(cornerRadius: Constants.cornerRadius)) // Apply contentShape modifier to enable tap gesture recognition on the entire view
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(singleSelectorManager.isSelected(_id) ? Constants.selectedBackgroundColor : Constants.deselectedBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(singleSelectorManager.isSelected(_id) ? Constants.selectedBorderColor: Constants.deselectedBorderColor,
                        lineWidth: Constants.borderWidth)
        )
    }
    
    var body: some View {
        
        VStack(spacing: Constants.midMargin) {
            ForEach(singleSelectorManager.options) { option in
                mainView(_id: option.id, option: option)
                    .onTapGesture {
                        if singleSelectorManager.isSelected(option.id) { return }
                        withAnimation {
                            self.singleSelectorManager.selectedOption = option.id
                            self.onSelectedOption?(option.id)
                        }
                    }
            }
        }
        
    }
}

struct SingleSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSelectorView(singleSelectorManager: SingleSelectorManager())
    }
}

