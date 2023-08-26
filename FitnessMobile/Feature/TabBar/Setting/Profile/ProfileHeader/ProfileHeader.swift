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
                    if let image = image {
                        image
                        .resizable()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    } else {
                        ProgressView()
                            .frame(width: 85, height: 85)
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2) // This draws the border
                            }
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
            Task {
                guard let user = UserSessionManager().getUser() else { return }
                
                if let uiimage = await MemoryImageCache.getImage(identifier: user._id) {
                    print("image loaded from cache")
                    image = Image(uiImage: uiimage)
                } else if let uuimage = await DiskImageCache.getImage(identifier: user._id) {
                    image = Image(uiImage: uuimage)
                    MemoryImageCache.saveImage(image: uuimage, identifier: user._id)
                } else {
                    loadProfileImageFromApi()
                }
            }
        }
    }
    
    func loadProfileImageFromApi() {
        guard let user = UserSessionManager().getUser() else { return }
        
        Task {
            let usecase = StorageUseCase()
            do {
                let response = try await usecase.downloadImageWithUrl(url: user.profileImage?.url ?? "")
                if let uiimage = UIImage(data: response) {
                    image = Image(uiImage: uiimage )
                    MemoryImageCache.saveImage(image: uiimage, identifier: user._id)
                    DiskImageCache.saveImage(image: uiimage, identifier: user._id)
                    print("image loaded from api")
                }
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
                let response = try await usecase.uploadFile(imageData: imageData!, filepath: "test/\(UserSessionManager().getUser()?._id ?? "")/c.png")
                print(response)
            } catch {
                print("image error")
            }
        }
    }
    
    func getExpirationAccessToken() -> String {
        let token = UserSessionManager().getAccessTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "ATE: \(token)"
    }
    
    func getExpirationRefreshToken() -> String {
        let token = UserSessionManager().getRefreshTokenExpirationDate().toString(format: "dd/MM/yy HH:mm:ss")
        return "RTE: \(token)"
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
