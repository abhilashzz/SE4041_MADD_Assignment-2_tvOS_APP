//
//  TVCardIllustrationView.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct TVCardIllustrationView: View {
    @State private var animateFloat = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Dark card back in background
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 32/255, green: 52/255, blue: 76/255),
                            Color(red: 20/255, green: 34/255, blue: 52/255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Image(systemName: "square.on.square")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(MemoryMatchTheme.textSecondary.opacity(0.4))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(MemoryMatchTheme.slateBorder, lineWidth: 2)
                )
                .frame(width: 170, height: 210)
                .rotationEffect(.degrees(12))
                .offset(x: 40, y: 50)
                .shadow(color: Color.black.opacity(0.4), radius: 16, x: 10, y: 15)
            
            // Apple Card (tilted left)
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                
                VStack(spacing: 8) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 74, weight: .semibold))
                        .foregroundColor(Color(red: 239/255, green: 68/255, blue: 68/255))
                    
                    Text("Apple")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textDark)
                }
            }
            .frame(width: 170, height: 210)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 20, x: -8, y: 12)
            .rotationEffect(.degrees(-10))
            .offset(x: -50, y: animateFloat ? -6 : 6)
            
            // Book Card (tilted right)
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                
                VStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 70, weight: .semibold))
                        .foregroundColor(Color(red: 59/255, green: 130/255, blue: 246/255))
                    
                    Text("Book")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textDark)
                }
            }
            .frame(width: 170, height: 210)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 20, x: 8, y: 14)
            .rotationEffect(.degrees(14))
            .offset(x: 75, y: animateFloat ? 6 : -6)
        }
        .frame(width: 420, height: 360)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true)) {
                animateFloat = true
            }
        }
    }
}
