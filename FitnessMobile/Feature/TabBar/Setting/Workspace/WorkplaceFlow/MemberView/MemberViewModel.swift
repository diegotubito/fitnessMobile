//
//  MemberListViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 17/09/2023.
//

import SwiftUI

class MemberViewModel: BaseViewModel {
    var receivedMembers: [WorkspaceModel.WorkspaceMember]
    var members: [WorkspaceMember] = []
    
    init(members: [WorkspaceModel.WorkspaceMember]) {
        self.receivedMembers = members
       
        super .init()
        self.mapMembers()
    }
    
    func mapMembers() {
        for member in receivedMembers {
            let new = WorkspaceMember(user: member.user, role: member.role, image: nil)
            self.members.append(new)  // Note the use of 'self' and the corrected method
        }
    }
    
    @MainActor
    func fetchProfileImage(member: WorkspaceMember) {
        isLoading = true
        guard let index = receivedMembers.firstIndex(where: {$0.user._id == member.user._id}) else { return }
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
    func loadProfileImageFromApi(member: WorkspaceMember) {
        guard let index = receivedMembers.firstIndex(where: {$0.user._id == member.user._id}) else { return }
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
    
    struct WorkspaceMember: Identifiable, Codable, Hashable {
        var id: UUID? = UUID()
        
        let user: User
        let role: String
        var image: Data?
    }
}
