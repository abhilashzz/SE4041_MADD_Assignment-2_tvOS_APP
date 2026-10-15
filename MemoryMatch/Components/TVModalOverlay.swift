//
//  TVModalOverlay.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct TVModalOverlay<Content: View>: View {
    public let title: String
    public let subtitle: String?
    public let content: Content
    public let onDismiss: () -> Void
    
    public init(
        title: String,
        subtitle: String? = nil,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            // Dark Blur Backdrop
            MemoryMatchTheme.modalBackdrop
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Modal Panel
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textPrimary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(MemoryMatchTheme.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Close / Dismiss Pill Button
                    Button(action: onDismiss) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                            Text("Close")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                    }
                    .buttonStyle(TVSmallPillButtonStyle())
                }
                
                Divider()
                    .background(MemoryMatchTheme.slateBorder)
                
                // Body Content
                content
            }
            .padding(36)
            .frame(maxWidth: 880)
            .background(MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                    .stroke(MemoryMatchTheme.slateBorder, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.6), radius: 30, x: 0, y: 15)
        }
    }
}
