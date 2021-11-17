//
//  DayView.swift
//  test_native
//
//  Created by ihor on 28.10.2021.
//

import SwiftUI

struct DayFocused: ViewModifier{
    var focused: Bool
    func body(content: Content) -> some View{
        if (focused){
            content
                .clipped()
                .shadow(color: Color("BlueLight").opacity(0.25),radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .shadow(color: Color("BlueLight").opacity(0.25), radius: 10, x:0, y:5)
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        }else{
            content
        }
    }
}

struct DayView: View {
    @ObservedObject var day: Day
    var dayOfWeek: Int = 0
    var dayName: String
    var id: Int
    let callback: (Int)->()
   @Binding var focused: Bool
    var body: some View {
        HStack{
            Text(day.DayName[day.dayOfWeek])
                .foregroundColor(focused ? Color("BlueDark") : Color.black)
                .background(Color.white)
                .padding()
            Spacer()
            Text(String( format: "%02dº/%02dº", day.tempDay, day.tempNight))
                .foregroundColor(focused ? Color("BlueDark") : Color.black)
            Spacer()
            Image(day.typeWeather.rawValue)
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .foregroundColor(focused ? Color("BlueDark") : Color.black)
                .padding()
        }
       .frame(width: UIScreen.main.bounds.width, height: 50.0, alignment: .center)
        .background(Color.white)
        .modifier(DayFocused(focused: focused))
        .onTapGesture()
        {
            self.callback(self.id)
        }

    }
    init(id: Int, day: Day, f: Binding<Bool>, callback: @escaping (Int)->()){
        self.day = day
        self.id = id
        self._focused = f
        self.dayOfWeek = day.dayOfWeek
        self.callback = callback
        self.dayName = day.DayName[self.dayOfWeek]
    }
}

struct DayView_Previews: PreviewProvider {
    @State private var fs: Bool = false
    static var previews: some View {
        DayView(id: 1, day: Day(), f: .constant(false), callback: {
            i in
            
        })
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}

