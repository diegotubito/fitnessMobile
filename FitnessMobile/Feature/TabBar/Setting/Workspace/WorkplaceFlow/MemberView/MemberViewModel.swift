//
//  MemberListViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 17/09/2023.
//

import SwiftUI

class MemberViewModel: BaseViewModel {
    @Published var members: [WorkspaceModel.WorkspaceMember]

    init(members: [WorkspaceModel.WorkspaceMember]) {
        self.members = members
    }
    
    /*
    @MainActor
    func fetchProfileImage(member: WorkspaceModel.WorkspaceMember) {
        isLoading = true
        guard let index = members.firstIndex(where: {$0.user._id == member.user._id}) else { return }
        Task {
            if let dataFromMemory = await DataCache.getData(identifier: "member_profile_image_\(member.user._id)") {
                members[index].image = dataFromMemory
                isLoading = false
            } else if let dataFromDisk = await DataDisk.getData(identifier: "member_profile_image_\(member.user._id)") {
                members[index].image = dataFromDisk
                DataCache.saveData(data: dataFromDisk, identifier: "member_profile_image_\(member.user._id)")
                isLoading = false
            } else {
                loadProfileImageFromApi(member: member)
            }
        }
    }
    
    @MainActor
    func loadProfileImageFromApi(member: WorkspaceModel.WorkspaceMember) {
        guard let index = members.firstIndex(where: {$0.user._id == member.user._id}) else { return }
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: member.user.profileImage?.url ?? "")
                DataCache.saveData(data: response, identifier: "member_profile_image_\(member.user._id)")
                DataDisk.saveData(data: response, identifier: "member_profile_image_\(member.user._id)")
                isLoading = false
                members[index].image = response
            } catch {
                members[index].image = nil
                isLoading = false
            }
        }
    }
     
     */
     
}
