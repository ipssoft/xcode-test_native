//
//  HumidityView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct HumidityView: View {
    var humidity: Int = 33
    var body: some View {
        HStack{
            Image("ic_humidity")
                .frame(width: 30.0)
            Text(String(format: "%02d%%", humidity))
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                
        }
        .background(Color("BlueDark"))
    }
}

struct HumidityView_Previews: PreviewProvider {
    static var previews: some View {
        HumidityView(humidity: 3)
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
