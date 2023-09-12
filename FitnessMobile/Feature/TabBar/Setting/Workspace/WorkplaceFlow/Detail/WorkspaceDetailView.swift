//
//  WorkspaceDetailView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

struct WorkspaceDetailView: View {
    @StateObject var viewmodel: WorkspaceDetailViewModel
    
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
        .background(Color.Neutral.tone100.opacity(0.3))
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
                .foregroundColor(Color.Dark.tone110)
                .onTapGesture {
                    print("edit title and subtitle")
                }
                
                VStack {
                    HStack {
                        Text("Cochabamba 375 4A")
                        Spacer()
                    }
                    HStack {
                        Text("Banfield, CP 1828")
                        Spacer()
                    }
                    
                    HStack {
                        Text("Buenos Aires, Argentina")
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        //.foregroundColor(.red)
                        Text("Not Verified")
                        Button("Upload document to verify") {
                            
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                        Text("Verification pending...")
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text("Verification rejected")
                        Button("Upload another document.") {
                            
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.shield.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.Green.truly)
                        Text("Verified")
                        Spacer()
                    }
                }
                .padding(.leading)
            }

            WarningBoxView(title: "Verification Note:", message: "Remeber that verifying your address is mandatory to be visible in user's area. Otherwise, you potential clients would never know you are running a business")

          
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.3))
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
            .foregroundColor(Color.Dark.tone110)
            .onTapGesture {
                print("edit title and subtitle")
            }
            
            HStack {
                Text("No address found.")
                Spacer()
            }
            .padding([.leading, .bottom])
            
            WarningBoxView(title: "Important Note:", message: "Set up your address so that your customers can find you.")
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.3))
        .cornerRadius(10)
    }
    
    var body: some View {
        VStack {
            headerView()
            addressView()
            noAddressView()
            
        }
        .padding()
        .overlay {
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
                                                                                          members: [])))
    }
}
