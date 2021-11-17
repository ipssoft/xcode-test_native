//
//  WindView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct WindView: View {
    var windSpeed: Int
    var windDirect: WindDirect
    var body: some View {
        HStack{
            Image("ic_wind")
//                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30.0)
            Text("\(windSpeed) м/сек")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Image(windDirect.rawValue)
                .aspectRatio(contentMode: .fit)
                .padding(.leading, -8.0)
                .frame(width: 30.0)
        }
        .background(Color("BlueDark"))
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        WindView(windSpeed: 5, windDirect: .windE)
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
