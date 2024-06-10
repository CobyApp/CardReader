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
                // Top overlay
                overlayColor
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: BaseSize.topAreaPadding + 180)
                
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
                HStack {
                    Text("카드 사진 촬영")
                        .font(.pretendard(size: 18, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                
                VStack(spacing: 16) {
                    Text("카드를 영역에 맞춰주세요.")
                        .font(.pretendard(size: 24, weight: .semibold))
                        .foregroundColor(Color.white)
                    
                    Text("초점이 맞춰지면 자동으로 촬영돼요.")
                        .font(.pretendard(size: 14, weight: .regular))
                        .foregroundColor(Color.white)
                }
                .padding(.top, 50)
                
                Spacer()
                
                Text("직접 입력하기")
                    .font(.pretendard(size: 16, weight: .medium))
                    .foregroundColor(Color.white)
            }
        }
    }
}

#Preview {
    ContentView()
}
