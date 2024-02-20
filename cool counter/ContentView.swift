//
//  ContentView.swift
//  cool counter
//
//  Created by Richard Nkanga on 13/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State var dragoffset = CGSize.zero
    @State var number = 0
    @State var numberOpacity = 1.0
    @State var additionButtonOpacity = 1.0
    @State var minusButtonOpacity = 1.0
    @State var xButtonScale: CGFloat = 0.5
    @State var xButtonVisible = false
    @State var animate = false
    @State var effect = 0.0
    @State var a = 0.0
    @State var b = 0.0
    @State var c = 0.0

    var body: some View {
        ZStack {
            Color(Color.lightGreen)
                .ignoresSafeArea(.all)

            VStack {





                ZStack {
                    Capsule()
                        .frame(width: 250, height: 80)
                        .foregroundStyle(.darkGreen)
                        .rotation3DEffect(.degrees(rotationAngle()), axis: (x: 1, y: 1, z: 0))

                    Image(systemName: "xmark")
                        .font(.system(size: 30))
                        .opacity(xButtonVisible ? effect : 0)
                        .scaleEffect(effect)
                        .onAppear {
                            withAnimation(
                                .spring(response: 0.2, dampingFraction: 2.5)
                                //                                .repeatForever(autoreverses: true)
                            ) {
                                effect = 1
                            }
                        }

                    Capsule()
                        .frame(width: 65, height: 65)
                        .foregroundStyle(.white)
                        .offset(dragoffset)
                        .rotation3DEffect(.degrees(rotationAngle()), axis: (x: 1, y: 1, z: 0))
                        .gesture(
                            DragGesture()

                                .onChanged { value in


                                    a = value.translation.width
                                    b = value.location.x


                                    withAnimation {
                                        // Limit the movement to a maximum of 100 points in either direction
                                        let limitedXTranslation = max(min(value.translation.width, 85), -85)
                                        let limitedYTranslation = max(min(value.translation.height, 60), 0)
//                                        let horizontalTranslation = CGSize(width: limitedXTranslation, height: limitedYTranslation)
//                                        self.dragoffset = horizontalTranslation

                                        if abs(value.translation.width) > abs(value.translation.height) {
                                            // Dragging more horizontally
                                            self.dragoffset = CGSize(width: limitedXTranslation, height: 0)

                                            withAnimation(.easeInOut) {
                                                self.numberOpacity = 1.0

                                                let threshold: CGFloat = 50

                                                if value.translation.width > threshold {
                                                    additionButtonOpacity = 0.5
                                                    minusButtonOpacity = 1

                                                } else if value.translation.width < threshold {
                                                    minusButtonOpacity = 0.5
                                                    additionButtonOpacity = 1
                                                }
                                            }

                                        } else {
                                            // Dragging more vertically
                                            self.dragoffset = CGSize(width: 0, height: limitedYTranslation)

                                            withAnimation {
//                                                self.numberOpacity = 0
                                                additionButtonOpacity = 0
                                                minusButtonOpacity = 0
                                                xButtonScale = 1.0
                                                xButtonVisible = true
//                                                animate.toggle()
                                            }
                                        }
                                    }
                                }
                                .onEnded { value in

                                    withAnimation(.easeInOut) {
                                        self.numberOpacity = 1.0
                                        additionButtonOpacity = 1
                                        minusButtonOpacity = 1
                                        xButtonScale = 0.5
                                        xButtonVisible = false
                                    }

                                    withAnimation {
                                        let threshold: CGFloat = 100

                                        if value.translation.width > threshold {
                                            additionButtonOpacity = 1
                                            self.number += 1

                                        } else if value.translation.width < threshold {
                                            minusButtonOpacity = 1
                                            if value.translation.height > threshold {
                                                self.number = 0
                                            } else {
                                                self.number -= 1
                                            }
                                        }

                                        self.dragoffset = .zero
                                    }
                                }
                        )
                        .overlay(
                            Text("\(number)")
                                .offset(dragoffset)
                                .bold()
                                .rotation3DEffect(.degrees(rotationAngle()), axis: (x: 0, y: 1, z: 0))
                                .opacity(numberOpacity)
                                .foregroundStyle(Color.black)
                        )

                    HStack {
                        Image(systemName: "minus")
                            .font(.system(size: 50))
                            .opacity(minusButtonOpacity)
                            .foregroundStyle(Color.black)

                        Spacer()
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)

                        Image(systemName: "plus")
                            .font(.system(size: 50))
                            .opacity(additionButtonOpacity)
                            .foregroundStyle(Color.black)
                    }
                    .rotation3DEffect(.degrees(rotationAngle()), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
    }

    private func rotationAngle() -> Double {
        let rotationFactor: CGFloat = -10.05
        let angle = -atan2(dragoffset.width, dragoffset.height)
        //          return Angle(radians: Double(angle * rotationFactor))
        return Double(angle * rotationFactor)
    }
}

#Preview {
    ContentView()
}
