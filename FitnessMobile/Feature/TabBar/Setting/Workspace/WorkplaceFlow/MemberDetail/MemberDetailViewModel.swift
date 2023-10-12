//
//  MemberDetailViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 30/09/2023.
//

import SwiftUI

class MemberDetailViewModel: BaseViewModel {
    var workspace: WorkspaceModel
    var member: WorkspaceModel.WorkspaceMember
    @Published var memberDeleted: Bool = false
    @Published var imageLoaded: Image = Image(systemName: "person.crop.circle.fill")
    
    init(workspace: WorkspaceModel, member: WorkspaceModel.WorkspaceMember) {
        self.workspace = workspace
        self.member = member
    }
    
    @MainActor
    func deleteMember() {
        Task {
            let usecase = WorkspaceUseCase()
            isLoading = true
            do {
                let response = try await usecase.deleteWorkspaceMember(workspace: workspace._id, user: member.user._id)
                isLoading = false
                memberDeleted = true
            } catch {
                isLoading = false
            }
        }
    }
    
    @MainActor
    func loadProfileImageFromApi() {
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: member.user.profileImage?.url ?? "")
                setImage(response)
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
    
    func setImage(_ imageData: Data) {
        if let uuimage = UIImage(data: imageData) {
            imageLoaded = Image(uiImage: uuimage)
        }
    }
}
