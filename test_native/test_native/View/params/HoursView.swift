//
//  HoursView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI

struct HoursView: View {
    @ObservedObject var hours: Hours
//    var data: Day
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack(spacing: 0){
                    ForEach(0..<self.hours.hours.count){index in
                        HourView(hour: self.hours.hours[index])
                    }
                }
            }
        }
    }
    init(data: Hours){
        self.hours = data
    }
}

struct HoursView_Previews: PreviewProvider {
    static var previews: some View {
        HoursView(data: Hours(countHours: 24))
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
