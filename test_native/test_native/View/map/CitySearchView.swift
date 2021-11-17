//
//  CitySearchView.swift
//  test_native
//
//  Created by ihor on 08.11.2021.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cityName: String = ""
    @ObservedObject var completerService = CompleterService()
    @ObservedObject var city: City
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    }label:{
                        Image("ic_back")
                    }.padding()
                    .background(Color("BlueDark"))
                    Spacer(minLength: 15)

                    TextField("Enter City", text: $completerService.queryFragment)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .background(Color.white)

                    Spacer(minLength: 15)
                    Button{
                        completerService.queryFragment = cityName
                    }label:{
                        Image("ic_search")
                    }
                    .padding()
                    .background(Color("BlueDark"))
                }
                .background(Color("BlueDark"))
                .padding(.top, 25 )
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 40, maxHeight: 40, alignment: .top)

                VStack{
                    List{
                        ForEach(completerService.searchResults, id: \.self){result in
                            Text("\(result.title), \(result.subtitle)")
                                .onTapGesture {
                                    CLGeocoder().geocodeAddressString(
                                        result.title + " " + result.subtitle, completionHandler: {
                                            (placemarks, error) -> Void in
                                            if error != nil{
                                                print("Geocoder faile: \(error!.localizedDescription)")
                                            }
                                            guard let marks = placemarks else{return}
                                            for mark in marks{
                                                if ((mark.name?.range(of: result.title)) != nil){
                                                    city.localName = result.title
                                                    city.coordinate = mark.location!.coordinate
                                                    break
                                                }
                                            }
                                               presentationMode.wrappedValue.dismiss()
                                            }
                                    )
                                }
                        }
                    }.padding(.top, 25)
                }
            }
            .background(Color("BlueDark"))
            .edgesIgnoringSafeArea(.top)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        }

    }
    
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchView(city: City())
    }
}
