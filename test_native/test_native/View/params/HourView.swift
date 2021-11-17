//
//  HourView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct HourView: View {
    @ObservedObject var hour: Hour

    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .top, spacing: 0){
                Text(String(format: "%02d", hour.hour))
                    .frame(alignment: .topTrailing)
                    .foregroundColor(.white)
                Text("00")
                    .foregroundColor(.white)
                    .font(.system(size: 8))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            .padding(.top, 15.0)
            .padding(.bottom, 15.0)
            Image( hour.typeWeather.rawValue)
            Text(String(format: "%02dº", hour.temp))
                .padding(.bottom, 15.0)
                .frame(alignment: .topTrailing)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 15.0)
        .background(Color("BlueLight"))
    }
}

struct HourView_Previews: PreviewProvider {
    static var previews: some View {
        HourView(hour: Hour(hour: 1))
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
