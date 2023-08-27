//
//  ProfileHeader.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 08/08/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @State var shouldUpdateView = true
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var photoPickerManager = PhotoPickerManager()
    
    var body: some View {
        VStack {
            if shouldUpdateView {
                HStack(spacing: 16) {
                    if let image = photoPickerManager.imageData?.asImage {
                        image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .overlay {
                            if photoPickerManager.isLoading {
                                ProgressView()
                                    .frame(width: 85, height: 85)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2) // This draws the border
                                    }
                                    .shadow(radius: 5)
                            } else {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                        }
                        .shadow(radius: 10)
                        .onTapGesture {
                            coordinator.presentModal(.photoPicker)
                        }
                    } else {
                        if !photoPickerManager.isLoading {
                            Image(systemName: "photo.circle")
                                .resizable()
                                .frame(width: 85, height: 85)
                                .onTapGesture {
                                    coordinator.presentModal(.photoPicker)
                                }
                        }
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text(UserSession.getFullName() ?? "")
                                .font(.headline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        HStack {
                            Text(UserSession.getUserName() ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        HStack {
                            Text(verbatim: UserSession.getEmail() ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                            
                            Spacer()
                        }
                        HStack {
                            Text(getExpirationAccessToken())
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text(getExpirationRefreshToken())
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .padding()
        .background(Color.Neutral.tone90)
        .onReceive(NotificationCenter.default.publisher(for: .UserSessionDidChanged)) { value in
            photoPickerManager.fetchProfileImage()
        }
        .onAppear {
            photoPickerManager.fetchProfileImage()
        }
    }
    
    func getExpirationAccessToken() -> String {
        let token = UserSession.getAccessTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "ATE: \(token)"
    }
    
    func getExpirationRefreshToken() -> String {
        let token = UserSession.getRefreshTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "RTE: \(token)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
