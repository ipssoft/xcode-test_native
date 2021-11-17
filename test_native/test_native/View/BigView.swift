//
//  BigView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct BigView: View {
    @ObservedObject var day: Day
    let screenWidht = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            HStack{
                Image(self.day.typeWeather.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidht / 2, height: 120, alignment: .center)

                    VStack(alignment: .leading, spacing: 10){
                        TempView(tempDay: day.tempDay, tempNigth: day.tempNight)
                            .frame(height: 25.0)
                        HumidityView(humidity: day.humidity)
                            .frame(height: 25.0)
                        WindView(windSpeed: day.windSpeed, windDirect: day.windDirect)
                            .frame(height: 25.0)
                    }
                    .padding(.leading, 0.0)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
        .padding(.leading, 10.0)
        .background(Color("BlueDark"))
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 100, maxHeight: 160, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct BigView_Previews: PreviewProvider {
    static var previews: some View {
        BigView(day: Day())
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)    }
}
