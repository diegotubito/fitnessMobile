//
//  InformationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Add WKNavigationDelegate methods if needed
    }
}

struct TwoFactorEnableInformationView: View {
    @StateObject var viewmodel = TwoFactorEnableInformationViewModel()
    @EnvironmentObject var userSession: UserSession
    @State var otpResult: OTPView.OPTResult = .none
    @EnvironmentObject var coordinator: Coordinator
    @State var shouldGoToOTP = false
    @State var shouldGoToRoor = false
    
    @State var qrImage: UIImage
    @State var activationCode: String
    
    let imageUrl = "https://example.com/your-qr-code.png"
    
    @ViewBuilder
    func helpingInformationView() -> some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Configure Two Factor Auth")
                        .padding(.trailing, 64)
                        .font(.largeTitle)
                        .foregroundColor(Color.Neutral.tone80)
                    Text("Follow the steps below to enhance your account's security: Also, this information has been sent to your email address.")
                        .font(.headline)
                        .foregroundColor(Color.Neutral.tone80)
                    HStack(alignment: .top) {
                        Image(systemName: "1.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.Yellow.trueYellow)
                        Text("Scan the QR code below using a 2FA app like Google Authenticator, Guardian, Duo Mobile, etc.")
                            .foregroundColor(Color.Neutral.tone90)
                    }
                    HStack(alignment: .center) {
                        Spacer()
                        Image(uiImage: qrImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "2.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.Yellow.trueYellow)
                        Text("Enter the code provided by the app to verify your device. You have to complete previous step first.")
                            .foregroundColor(Color.Neutral.tone90)
                    }
                    Spacer()
                   
                }
            }
            BasicButton(title: "Enter Code", style: .secondary, isEnabled: .constant(true)) {
                shouldGoToOTP = true
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.Dark.tone100)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    var body: some View {
        VStack {
            switch otpResult {
            case .none, .otpBackButton, .otpBackButtonWithFailure, .otpSuccess:
                helpingInformationView()
                    
                    .onChange(of: shouldGoToOTP, perform: { newValue in
                        switch otpResult {
                        case .none, .enableConfirmed:
                            break
                        case .otpBackButton:
                            break
                        case .otpSuccess:
                            confirm2FA()
                        case .otpBackButtonWithFailure:
                            break
                        }
                    })
                    .sheet(isPresented: $shouldGoToOTP, content: {
                        OTPView(optResult: $otpResult)
                        
                    })
                
            case .enableConfirmed:
                successView()
            }
        }
        .padding(.horizontal, 4)
        .background( LinearGradient(gradient: Gradient(colors: [Color.Yellow.trueYellow, Color.Dark.tone90]), startPoint: .top, endPoint: .bottom))
        .navigationTitle("Assignment List")
        .overlay(
            Group {
                if viewmodel.isLoading {
                    // A transparent view that captures all touches, making underlying views non-interactive
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle()) // Makes the entire view tappable
                            .onTapGesture { }
                            .allowsHitTesting(true) // Captures all touches
                        ProgressView()
                    }
                } else {
                    Color.clear
                        .contentShape(Rectangle()) // Makes the entire view tappable
                        .allowsHitTesting(false) // Captures all touches
                }
            }
        )
    }
    
    func confirm2FA() {
        viewmodel.confirm2FA() { result in
            if result != nil {
                otpResult = .enableConfirmed
                coordinator.path.removeLast()
            } else {
                coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage, completion: nil)
            }
        }
    }
    
    @ViewBuilder
        private func successView() -> some View {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 50))
                
                Text("Enabling process was successful!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Button("Go to Home") {
                    coordinator.root()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorEnableInformationView(qrImage: UIImage(named: "qrExample")!, activationCode: "")
    }
}
