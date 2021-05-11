//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by 서동운 on 2021/05/12.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {
    // NSDictionary 데이터를 전달받음
    var param : NSDictionary!
    
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        //네비게이션 타이틀에 상영관명 출력
        self.navigationItem.title = self.param["상영관명"] as? String
        // 데이터에서 String으로 경도 위도 값을 받아와 double값으로 캐스팅
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        
        //CLLocationCoordinate2D 생성 (인자로 위도 경도 대입)
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        //맵에 표시되는 거리
        let regionRadius: CLLocationDistance = 100
        
        //위치와 반경을 설정
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //map 객체의 setRegion 메소드를 호출
        self.map.setRegion(coordinateRegion, animated: true)
        
        // 정확한 위치를 Point로 표시해줌 (Annotation)
        let point = MKPointAnnotation()
        
        point.coordinate = location
        
        self.map.addAnnotation(point)
    }
    
}
