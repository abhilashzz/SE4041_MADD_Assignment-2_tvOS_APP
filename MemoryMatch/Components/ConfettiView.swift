//
//  ConfettiView.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct ConfettiParticle: Identifiable {
    public let id = UUID()
    public let x: CGFloat
    public let y: CGFloat
    public let size: CGFloat
    public let color: Color
    public let rotation: Double
    public let isCircle: Bool
}

public struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    private let colors: [Color] = [
        MemoryMatchTheme.mintTeal,
        MemoryMatchTheme.amber,
        Color(red: 96/255, green: 165/255, blue: 250/255),
        Color(red: 248/255, green: 113/255, blue: 113/255),
        Color(red: 251/255, green: 191/255, blue: 36/255)
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ForEach(particles) { p in
                Group {
                    if p.isCircle {
                        Circle()
                            .fill(p.color)
                    } else {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(p.color)
                    }
                }
                .frame(width: p.size, height: p.size * (p.isCircle ? 1.0 : 1.6))
                .rotationEffect(.degrees(p.rotation))
                .position(x: p.x, y: p.y)
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        var items: [ConfettiParticle] = []
        // Fixed deterministic distribution around trophy (radius 140 to 240)
        let angles: [Double] = [20, 45, 75, 110, 135, 160, 200, 230, 260, 290, 320, 345, 30, 60, 125, 215, 305]
        let distances: [CGFloat] = [120, 160, 190, 140, 180, 210, 130, 170, 200, 150, 185, 220, 175, 135, 195, 165, 145]
        
        let centerX: CGFloat = 200
        let centerY: CGFloat = 160
        
        for i in 0..<angles.count {
            let rad = angles[i] * .pi / 180.0
            let dist = distances[i]
            let px = centerX + cos(rad) * dist
            let py = centerY + sin(rad) * dist
            
            items.append(ConfettiParticle(
                x: px,
                y: py,
                size: CGFloat(8 + (i % 5) * 2),
                color: colors[i % colors.count],
                rotation: Double((i * 37) % 360),
                isCircle: i % 2 == 0
            ))
        }
        self.particles = items
    }
}
