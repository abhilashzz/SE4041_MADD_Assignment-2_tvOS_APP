//
//  AddPlayerModal.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct AddPlayerModal: View {
    @Binding public var playerName: String
    public let errorMessage: String?
    public let onSave: () -> Void
    public let onDismiss: () -> Void
    
    public init(
        playerName: Binding<String>,
        errorMessage: String?,
        onSave: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self._playerName = playerName
        self.errorMessage = errorMessage
        self.onSave = onSave
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        TVModalOverlay(
            title: "Add New Player",
            subtitle: "Create a local player profile for this Apple TV",
            onDismiss: onDismiss
        ) {
            VStack(spacing: 24) {
                // Notice
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(MemoryMatchTheme.mintTeal)
                    
                    Text("These profiles are app-local and do not affect your Apple TV system accounts.")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MemoryMatchTheme.raisedSlate.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                // Name Input Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Name")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                    
                    TextField("Enter player name (e.g. Maya)", text: $playerName)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(MemoryMatchTheme.raisedSlate)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1.5)
                        )
                }
                .frame(maxWidth: 600)
                
                // Error feedback if any
                if let errorMessage = errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(MemoryMatchTheme.destructiveRed)
                        Text(errorMessage)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.destructiveRed)
                    }
                }
                
                // Action Buttons
                HStack(spacing: 24) {
                    Button(action: onSave) {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Player")
                        }
                    }
                    .buttonStyle(TVPrimaryButtonStyle(minWidth: 240, height: 64))
                    
                    Button("Cancel", action: onDismiss)
                        .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
                }
                .padding(.top, 12)
            }
            .padding(.vertical, 10)
        }
    }
}
