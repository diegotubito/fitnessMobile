//
//  WorkspaceUseCaseSync.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import Foundation

class WorkspaceUseCaseSync {
    var repository: WorkspaceRepositoryProtocolSync
    
    init(repository: WorkspaceRepositoryProtocolSync) {
        self.repository = repository
    }
    
    func getWorkspaces(completion: @escaping WorkspaceRepositoryResultSync) {
        repository.getWorkspace { result in
            completion(result)
        }
    }
}
