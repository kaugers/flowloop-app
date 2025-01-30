//
//  ProgressBar.swift
//  FlowLoop
//
//  Created by Viesturs Kaugers on 04/01/2021.
//  Copyright © 2021 Viesturs Kaugers. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    @Binding var color: Color
    @Binding var opacity: Double
    @State var hovered = false
    @ObservedObject var config = Configuration.shared
    @ObservedObject var state = StateMachine.shared
    
    var body: some View {
        GeometryReader { geometry in
            if (config.getDisplayStatus() == 1) {
                if (self.config.getShapeAlignment() == 0) {
                    Text(state.description(horizontal: false))
                        .foregroundColor(.black)
                        .font(
                            .system(size: 12)
                        )
                        .alignmentGuide(
                            VerticalAlignment.center, computeValue: {
                                $0[.bottom]
                            }
                        )
                        .zIndex(100)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                } else {
                    Text(state.description(horizontal: true))
                        .foregroundColor(.black)
                        .font(
                            .system(size: 12)
                        )
                        .alignmentGuide(
                            HorizontalAlignment.center, computeValue: {
                                $0[.bottom]
                            })
                        .zIndex(100)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(
                        width: config.getShapeAlignment() == 1 ? geometry.size.height: geometry.size.width,
                        height: config.getShapeAlignment() == 1 ? geometry.size.height : geometry.size.width
                    )
                    
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .zIndex(150)
                        .frame(
                            width: config.getShapeAlignment() == 1 ? geometry.size.height * 0.65 : geometry.size.width * 0.65,
                            height: config.getShapeAlignment() == 1 ? geometry.size.height * 0.65 : geometry.size.width * 0.65
                        )
                        .gesture(TapGesture().onEnded {
                            exit(0)
                        })
                        .onHover { over in
                            self.hovered.toggle()
                        }
                    
                    if (self.hovered) {
                        Text("X")
                            .foregroundColor(Color.black)
                            .fontWeight(.thin)
                            .zIndex(200)
                            .gesture(TapGesture().onEnded {
                                exit(0)
                            })
                    }
                }
            }.zIndex(100)

            ZStack(alignment:
                    self.config.getShapeAlignment() == 0 ? .bottomTrailing : .leading) {
                Rectangle()
                    .foregroundColor(Configuration.shared.getProgressBarColor())
                    .opacity(opacity)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                if (self.config.getShapeAlignment() == 0) {
                    ZStack (alignment: .center) {
                        Rectangle()
                            .foregroundColor(self.color)
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height * (CGFloat(self.value)))
                            .animation(.linear(duration: 0))
                    }
                } else {
                    ZStack (alignment: .center) {
                        Rectangle()
                            .foregroundColor(self.color)
                            .frame(
                                width: geometry.size.width * (CGFloat(self.value)),
                                height: geometry.size.height)
                            .animation(.linear(duration: 0))
                    }
                }
            }
            .cornerRadius(45.0)
            .overlay(
                RoundedRectangle(cornerRadius: 45)
                    .stroke(Configuration.borderColor, lineWidth: 0.6)
            )
        }
    }
}
