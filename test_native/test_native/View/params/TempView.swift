//
//  TermView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct TempView: View {
    var tempDay: Int
    var tempNigth: Int
    var body: some View {
        HStack{
            Image("ic_temp")
                .frame(width: 30.0)
            Text(String(format: "%02dº/%02dº", tempDay, tempNigth))
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                
        }
        .background(Color("BlueDark"))
        
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView(tempDay: 23, tempNigth: 17)
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
