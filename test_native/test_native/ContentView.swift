//
//  ContentView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI
import UIKit
import MapKit


struct ContentView: View {
    @ObservedObject var city: City = City()
    @State private var selected = 0

    var body: some View {
        ZStack{
            VStack(spacing: 0){
                TopView(city: self.city)
                BigView(day: self.city.currentDay)
                HoursView(data: city.hours)
                DaysView(days: city.days)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
