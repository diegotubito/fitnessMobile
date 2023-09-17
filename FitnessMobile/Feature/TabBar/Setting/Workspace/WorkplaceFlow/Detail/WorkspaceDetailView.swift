//
//  WorkspaceDetailView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

struct WorkspaceDetailView: View {
    @StateObject var viewmodel: WorkspaceDetailViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    func headerView() -> some View {
        HStack {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                titleAndSubtitleView()
            }
        }
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func titleAndSubtitleView() -> some View {
        return VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "pencil")
                }
                .foregroundColor(.accentColor)
                .onTapGesture {
                    print("edit title and subtitle")
                }
                
                HStack {
                    Text(viewmodel.workspace.title)
                    Spacer()
                }
                HStack {
                    Text(viewmodel.workspace.subtitle)
                    Spacer()
                }
            }
            .padding()
            .foregroundColor(Color.Neutral.tone80)
        }
    }
    
    func notVerifiedView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
            //.foregroundColor(.red)
            Text("Not Verified")
            Button("Upload document to verify") {
                
            }
            Spacer()
        }
        .foregroundColor(Color.Neutral.tone80)
    }
    
    func pendingStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
            Text("Verification pending...")
            Spacer()
        }
    }
    
    func rejectedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
            Text("Verification rejected")
            Button("Upload another document.") {
                
            }
            Spacer()
        }
    }
    
    func verifiedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Green.truly)
            Text("Verified")
            Spacer()
        }
    }
    
    func addressView() -> some View {
        return VStack(spacing: 32) {
            VStack(spacing: 4) {
                HStack {
                    Text("Address")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "pencil")
                }
                .padding(.bottom, 4)
                .foregroundColor(Color.Apricot.trueApricot)
                .onTapGesture {
                    coordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                }
                
                VStack {
                    if let formattedAddress = viewmodel.getFormattedAddress() {
                        HStack {
                            Text(formattedAddress)
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewmodel.getCoordinates())
                            Spacer()
                        }
                    }
                    
                    switch viewmodel.workspace.locationVerificationStatus {
                        
                    case .notVerified:
                        notVerifiedView()
                    case .pending:
                        pendingStatusView()
                    case .verified:
                        verifiedStatusView()
                    case .rejected:
                        rejectedStatusView()
                    case .none:
                        EmptyView()
                    }
                }
                .padding(.leading)
                
            }
            
            WarningBoxView(title: "Verification Note:", message: "Remeber that verifying your address is mandatory to be visible in user's area. Otherwise, you potential clients would never know you are running a business")
            
            
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func noAddressView() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("Address")
                    .font(.headline)
                Spacer()
                Image(systemName: "pencil")
            }
            .foregroundColor(Color.Apricot.trueApricot)
            .onTapGesture {
                coordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
            }
            
            HStack {
                Text("No address found.")
                Spacer()
            }
            .padding([.leading, .bottom])
            .foregroundColor(Color.Neutral.tone80)
            
            WarningBoxView(title: "Important Note:", message: "Set up your address so that your customers can find you.")
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    headerView()
                    if viewmodel.hasLocation {
                        addressView()
                    } else {
                        noAddressView()
                    }
                    
                }
            }
            .scrollIndicators(.hidden)
            .padding()
            .overlay {
            }
        }
    }
}

struct WorkspaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceDetailView(viewmodel: WorkspaceDetailViewModel(workspace: WorkspaceModel(_id: "0",
                                                                                          title: "Test ABC",
                                                                                          subtitle: "Testing subtitle",
                                                                                          isEnabled: true,
                                                                                          owner: "",
                                                                                          logo: "",
                                                                                          createdAt: "",
                                                                                          updatedAt: "",
                                                                                          members: [], location: nil, locationVerificationStatus: nil)))
    }
}
