//
//  DaysView.swift
//  test_native
//
//  Created by ihor on 30.10.2021.
//

import SwiftUI


struct DaysView: View {
    @ObservedObject var days: Days
    @State var selectedId: Int = -1
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 0){
                    ForEach(0..<days.count){ i in
                        DayView(id: i, day: days.days[i], f: .constant(self.selectedId == i), callback: doClick)
                    }
            }
        }
    }
    
    func doClick(id: Int){
        self.selectedId = id
//        days.days[0].tempDay += 1
//        days.days[0].tempNight += 1
        print("id = \(id)")
    }
}

struct DaysView_Previews: PreviewProvider {
    static var previews: some View {
        DaysView(days: Days())
    }
}
