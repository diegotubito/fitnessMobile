//
//  ProfileHeader.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 08/08/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var photoPickerManager = PhotoPickerManager()
    
    struct Constants {
        static let size: CGFloat = 100
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
                photoPickerManager.getImageView()
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.size, height: Constants.size)
                    .clipShape(Circle())
                    .overlay {
                        if photoPickerManager.isLoading {
                            ProgressView()
                                .frame(width: Constants.size, height: Constants.size)
                                .overlay {
                                    Circle()
                                        .stroke(Color.Dark.tone70, lineWidth: 2)
                                }
                                .shadow(radius: 5)
                        } else {
                            Circle()
                                .stroke(Color.Dark.tone70, lineWidth: 2)
                            Text("_EDIT_BUTTON")
                                .padding(3)
                                .padding(.horizontal, 2)
                                .font(.caption)
                                .foregroundColor(Color.Blue.truly)
                                .background(Color.Dark.tone70)
                                .cornerRadius(5)
                                .offset(CGSize(width: 0, height: Constants.size / 2))
                                .shadow(radius: 5)
                        }
                    }
                    .shadow(radius: 10)
                    .onTapGesture {
                        coordinator.presentModal(.photoPicker)
                    }
               
            VStack(spacing: 2) {
                HStack {
                    Text(UserSession.getFullName() ?? "")
                        .font(.title2)
                        .foregroundColor(Color.Dark.tone70)
                    Spacer()
                }
                HStack {
                    Text(getDisplayUserName())
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone80)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Text(getDisplayEmail())
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone80)
                    Spacer()

                }
            }
            
        }
        .padding()
        .background(Color.Neutral.tone90.opacity(0.3))
        .onReceive(NotificationCenter.default.publisher(for: .UserSessionDidChanged)) { value in
            photoPickerManager.fetchProfileImage()
        }
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
    }
    
    private func getDisplayUserName() -> String {
        let userName = UserSession.getUserName() ?? ""
        let localizedUsername = NSLocalizedString("_USERNAME", comment: "Username label for login")
        return "\(localizedUsername): \(userName)"
    }

    private func getDisplayEmail() -> String {
        let email = UserSession.getEmail() ?? ""
        let localizedUsername = NSLocalizedString("_EMAIL", comment: "Email label for login")
        return "\(localizedUsername): \(email)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
