//
//  WorkspaceMockViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import Foundation

class WorkspaceViewModelMock {
    static var shared = WorkspaceViewModelMock()
    
    static func getWorkspaces() -> [WorkspaceModel] {
        
        var workspaces: [WorkspaceModel] = []
        let usecase = WorkspaceUseCaseSync(repository: WorkspaceRepositoryMockSync())
        let semasphore = DispatchSemaphore(value: 0)
        
        usecase.getWorkspaces { result in
            switch result {
            case .success(let response):
                workspaces = response.workspaces
                semasphore.signal()
                break
            case .failure(let error):
                semasphore.signal()
                break
            }
        }
        
        _ = semasphore.wait(timeout: .distantFuture)
        
        return workspaces
    }
}
