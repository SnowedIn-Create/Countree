//
//  ContentView.swift
//  Countree
//
//  Created by Onur Com on 30.05.2020.
//  Copyright © 2020 Onur Com. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Color {
    static let offWhite = Color(red: 225/255, green: 225/255, blue: 235/255)
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.darkEnd)
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)

            } else {
                shape
                    .fill(Color.darkEnd)
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                        .fill(Color.offWhite)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 8)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                        )
                        
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
        )
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            Circle()
                .trim(from: 0.0, to:
                    CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct ContentView: View {
    
    @State var counter = 0
    @State var progressValue: Float = 0.0
    @State var limitAmount = ""
    @State var startingPosition: CGSize = .zero
    @State var endPosition: CGSize = .zero
    
    var body: some View {
        ZStack{
            LinearGradient(Color.darkStart, Color.darkEnd)
            VStack {
                Text("Enter Limit amount")
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .thin))
                ZStack {
                    ProgressBar(progress: self.$progressValue)
                    .frame(width: 280, height: 280)
                    .padding(20)
                    Circle()
                        .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .frame(width: 250, height: 250)
                        .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                        .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
                        .padding(30)
                    Text("\(counter)")
                        .foregroundColor(.white)
                        .font(.system(size: 55, weight: .thin))
                }
                
                //Spacer()
                HStack {
                    Button(action: {
                        
                        print("Button tapped")
                        if self.counter == 0 {
                            return
                        } else {
                            self.counter -= 1
                            self.progressValue -= 0.007
                        }
                        
                        
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(DarkButtonStyle())
                    .padding(35)
                    Spacer()
                    Button(action: {
                        
                        print("Button tapped")
                        self.counter += 1
                        self.progressValue += 0.007
                        
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(DarkButtonStyle())
                    .padding(35)
                }
                
            }

        }
        .edgesIgnoringSafeArea(.all)
        .gesture(DragGesture().onChanged { value in
            self.startingPosition = CGSize(width: value.translation.width + self.endPosition.width, height: value.translation.height + self.endPosition.height)
            print("starting pos \(self.startingPosition.height)")
            print("ending pos \(self.endPosition.height)")
        }
        .onEnded { value in
            if self.startingPosition.height < self.endPosition.height {
                self.counter += 1
                self.progressValue += 0.007
            } else if self.startingPosition.height < self.endPosition.height || self.counter > 0{
                self.counter -= 1
                self.progressValue -= 0.007
            }
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
