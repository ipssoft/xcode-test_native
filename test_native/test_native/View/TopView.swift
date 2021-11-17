//
//  TopView.swift
//  test_native
//
//  Created by ihor on 27.10.2021.
//

import SwiftUI
import MapKit

struct TopView: View {
    @ObservedObject var city: City
    @State private var region = MKCoordinateRegion()
    @State var isClickUserLock: Bool = false
    
    let userLocation = UserLocation()

    @State private var showingMap: Bool = false
    @State private var showingSearch: Bool = false
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    HStack(){
                        Button{
                            print("City button click")
                            showingSearch.toggle()
                        }
                        label:{
                            HStack{
                                Image("ic_place")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                Text(city.localName)
                                    .foregroundColor(Color(.white))
                                    .font(.title)
                            }
                        }
                        .fullScreenCover(isPresented: $showingSearch, content:{ CitySearchView(city: city)})
                    }
                    .padding(.leading, 5.0)
                    .padding(.top, 20.0)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 25, alignment: .topLeading)
                    
                    HStack(){
                        let b = Button {
                            print("click location button")
                            showingMap = true
                        }label: {
                            Image("ic_my_location")
                        }
                        
                        b.popover(isPresented: $showingMap){
                            VStack{
                                HStack{
                                    Button{
                                        print("Button click")
                                        city.region = region
                                        city.saveLocation()
                                        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                                        let geocoder = CLGeocoder()
                                        geocoder.reverseGeocodeLocation(location){(marks, error) in
                                            if error != nil{
                                                print("Geocoder file: \(error!.localizedDescription)")
                                            }
                                            if marks!.count > 0{
                                                if let mark = marks?[0]{
                                                    if let ln = mark.locality{
                                                        city.localName = ln
                                                    } else{
                                                        city.localName = "--//--"
                                                    }
                                                }
                                            }
                                        }
                                        city.coordinate = region.center
                                        showingMap = false
                                    }label: {
                                        Image("ic_back")
                                    }.padding()
                                    .background(Color("BlueLight"))
                                    Spacer()
                                    Button{
                                        if !isClickUserLock{
                                            userLocation.start{ loc in
                                                isClickUserLock = true
                                                city.region = region
                                                region.center = loc.coordinate
                                             }
                                        }
                                    }label:{
                                        Text("User loc")
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                    .foregroundColor(.white)
                                    Spacer()
                                    Button{
                                        self.isClickUserLock = false
                                        region = city.region
                                    }label:{
                                        Text("City loc")
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }.padding()
                                    .foregroundColor(.white)

                                }
                                CityMKMapView(showingMap: $showingMap, region: $region)
                                    .onAppear{
                                        self.region = self.city.region
                                    }
                            }
                            .background(Color("BlueLight"))
                        }
                    }
                    .padding(10)
                    .padding(.top, 25.0)
                    .frame(minWidth: 0, maxWidth: 40, minHeight: 0, maxHeight: 40, alignment: .topTrailing)
            }
                Text(city.dayName)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.top, 12)
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 85, alignment: .topLeading)
        .background(Color("BlueDark"))
        }
   }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(city: City()).previewLayout(.sizeThatFits)
            .colorScheme(.light)
    }
}
