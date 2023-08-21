//
//  ProfileHeader.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 08/08/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @State var shouldUpdateView = true
    @State var image: Image?
    
    var body: some View {
        VStack {
            if shouldUpdateView {
                HStack(spacing: 16) {
                    if image != nil {
                        image!
                        .resizable()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                            .shadow(radius: 5)
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text(UserSessionManager().getFullName() ?? "")
                                .font(.headline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        HStack {
                            Text(UserSessionManager().getUserName() ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        HStack {
                            Text(verbatim: UserSessionManager().getEmail() ?? "")
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
            shouldUpdateView = false
            shouldUpdateView = true
        }
        .onAppear {
            loadImage()
            uploadImage()
        }
    }
    
    func loadImage() {
        Task {
            let usecase = StorageUseCase()
            do {
                let response = try await usecase.downloadFile(filepath: "profile_pictures/\(UserSessionManager().getUser()?._id ?? "")/profile.png")
                let uiimage = UIImage(data: response)
                image = Image(uiImage: uiimage! )
            } catch {
                print("image error")
            }
        }
    }
    
    func uploadImage() {
        Task {
            let usecase = StorageUseCase()
            do {
                let uiimageData = UIImage(systemName: "pencil")
                let imageData = uiimageData?.pngData()
                let response = try await usecase.uploadFile(imageData: imageData!, filepath: "test/\(UserSessionManager().getUser()?._id ?? "")/a.png")
                print(response)
            } catch {
                print("image error")
            }
        }
    }
    
    func getExpirationAccessToken() -> String {
        let token = UserSessionManager().getAccessTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "access token exp: \(token)"
    }
    
    func getExpirationRefreshToken() -> String {
        let token = UserSessionManager().getRefreshTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "refresh token exp: \(token)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
