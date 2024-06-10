//
//  ContentView.swift
//  CardReader
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI

import CobyDS

struct ContentView: View {
    
    @State private var recognizedText = "No text detected"
    
    private let overlayColor = Color.black.opacity(0.5)
    private let rectangleWidth: CGFloat = BaseSize.fullWidth
    private let rectangleHeight: CGFloat = BaseSize.fullWidth * 0.62
    
    var body: some View {
        ZStack {
            CameraView(recognizedText: $recognizedText)
                .edgesIgnoringSafeArea(.all)
            
            // Transparent overlay
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .none,
                    title: "카드 사진 촬영"
                )
                
                // Top overlay
                overlayColor
                
                HStack(spacing: 0) {
                    // Left overlay
                    overlayColor
                        .frame(width: (UIScreen.main.bounds.width - rectangleWidth) / 2)
                    
                    ZStack {
                        Rectangle()
                            .strokeBorder(overlayColor, lineWidth: 4)
                            .frame(width: rectangleWidth, height: rectangleHeight)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white, lineWidth: 4)
                            .frame(width: rectangleWidth, height: rectangleHeight)
                    }
                    
                    // Right overlay
                    overlayColor
                        .frame(width: (UIScreen.main.bounds.width - rectangleWidth) / 2)
                }
                .frame(height: rectangleHeight)
                
                // Bottom overlay
                overlayColor
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            VStack {
                Spacer()
                Text(recognizedText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
