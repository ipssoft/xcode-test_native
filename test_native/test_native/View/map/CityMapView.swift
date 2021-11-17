//
//  CityMap.swift
//  test_native
//
//  Created by ihor on 02.11.2021.
//
import MapKit
import SwiftUI

struct CityMapView: View {
    @Binding var showingMap: Bool
    @Binding var lat: Double
    @Binding var lon: Double

    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 47.4922, longitude: 35.1125
//            latitude: $lat, longitude: $lon
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1, longitudeDelta: 1
        )
    )
    
    @State var places: [PlaceMap] = [PlaceMap(lat: 47.8244, long: 35.005)]
    
    let userLocation = UserLocation()
    
    var body: some View {
        GeometryReader{geo in
        VStack{
            Button{
                print("close city map")
                //                print(region.center)
                lat = region.center.latitude
                lon = region.center.longitude
                
                print("latitude = \(lat), longtitude = \(lon)")
                showingMap = false
            }label: {
                Text("< Back")
            }
            Map(coordinateRegion: $region,
//                interactionModes: .all,
                showsUserLocation: true,
//                userTrackingMode: .constant(.follow),
                annotationItems: places){
                place in
            MapAnnotation(coordinate: place.location){
                Circle()
                    .fill(Color.red.opacity(0.8))
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        print("latitude = \(place.location.latitude), longtitude = \(place.location.longitude)")
                        showingMap = false                        }
            }
               
            }
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onEnded{ gesture in
                        
                        print(gesture.translation)
                        print(gesture.location)
                        print(UIScreen.main.bounds.width)
                        
                        var deltaX: Double{
                            let d = region.span.longitudeDelta / Double(UIScreen.main.bounds.width)
                            return Double(gesture.translation.width) * d
                        }
                        print("geo \(geo.size)")
                        var deltaY: Double{
                            let d = region.span.latitudeDelta / (Double(geo.size.height))
                            return Double(gesture.translation.height) * d
                        }
                        if abs(gesture.translation.width) > 5{
                            withAnimation{
                                region.center.longitude = region.center.longitude - deltaX
                            }
                        }

                        if abs(gesture.translation.height) > 5{
                            withAnimation{
                                region.center.latitude = region.center.latitude + deltaY
                            }
                        }

                        if gesture.translation.width == 0 && gesture.translation.height == 0{
                            print ("tap gesture")
                            var deltaX: Double{
                                let d = region.span.longitudeDelta / Double(geo.size.width)
                                let x: Double = Double(geo.size.width / 2)
                                let xm = x - Double(gesture.location.x)
                                return xm * d
                            }
                            
                            var deltaY: Double{
//                                let d = region.span.longitudeDelta / Double(UIScreen.main.bounds.width)
                                let d: Double = region.span.latitudeDelta / Double(geo.size.height)
                                let y: Double = Double((geo.size.height) / 2)
                                let ym = y - Double(gesture.location.y)
                                return ym * d
                            }
                            print("deltaX = \(region.span.longitudeDelta) deltaY = \(region.span.latitudeDelta)")

                            places[0] = PlaceMap(
                                lat: region.center.latitude + deltaY,
                                long: region.center.longitude - deltaX)
                       }
                    }
            )
                .onAppear{
                    self.region.center.latitude = self.lat
                    self.region.center.longitude = self.lon
                    places[0] = PlaceMap(
                        lat: self.lat, long: self.lon)
                    
                    userLocation.start{ loc in
                        print(loc)
                        self.region.center.latitude = loc.coordinate.latitude
                        self.region.center.longitude = loc.coordinate.longitude
                        places[0] = PlaceMap(
                            lat: loc.coordinate.latitude,
                            long: loc.coordinate.longitude)
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
        }
    }

    
    init(showingMap: Binding<Bool>, lat: Binding<Double>, lon: Binding<Double>){
        self._showingMap = showingMap
        self._lat = lat
        self._lon = lon
        self.region.center.latitude = self.lat
        self.region.center.longitude = self.lon
    }
}

struct CityMapView_Previews: PreviewProvider {
    static var previews: some View {
        CityMapView(showingMap: .constant(true), lat: .constant(47.4922), lon: .constant(35.1125))
    }
}
