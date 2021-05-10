//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 서동운 on 2021/05/09.
//

import UIKit
import Foundation

class ListViewController: UITableViewController {
    
    var page = 1
    //튜플 아이템으로 구성된 데이터 세트
//    var dataset = [
//        ("다크나이트","2008-09-04","영웅물에 철학에 음악까지 더해져 예술이 되다.",8.95,"darknight.jpg"),
//        ("호우시절","2009-10-08","떄를 알고 내리는 좋은 비",9.12,"rain.jpg"),
//        ("말할 수 없는 비밀","2015-05-07","여기서 너까지 다섯 걸음",8.93,"secret.jpg")
//    ]
    // 번거로운 데이터 방식
//    var list = [MovieVO]()
//
//    override func viewDidLoad() {
//
//        var mvo = MovieVO()
//        mvo.title = "다크나이트"
//        mvo.opendate = "2008-09-04"
//        mvo.description = "영웅물에 철학에 음악까지 더해져 예술이 되다."
//        mvo.rating = 8.95
//
//        self.list.append(mvo)
//
//        mvo = MovieVO()
//        mvo.title = "호우시절"
//        mvo.opendate = "2009-10-08"
//        mvo.description = "때를 알고 내리는 좋은 비"
//        mvo.rating = 9.12
//
//        self.list.append(mvo)
//
//        mvo = MovieVO()
//        mvo.title = "말할 수 없는 비밀"
//        mvo.opendate = "2015-05-07"
//        mvo.description = "여기서 너까지 다섯 걸음"
//        mvo.rating = 8.93
//
//        self.list.append(mvo)
//    }
// MARK: -리팩토링
    
    //lazy 사용 이유: 1. 미리생성해서 메모리 낭비하는 일이 없도록 변수를 참조할 때 초기화 하기 위함.
    //              2. dataset 프로퍼티를 참조해야 하는데 list 보다 늦게 초기화 될 수 있으므로
    
    lazy var list: [MovieVO] = { //클로저를 통한 리턴값 대입
        var datalist = [MovieVO]() // MovieVO클래스의 배열 생성
        
        //dataset에 정의된 데이터들을 for구문으로 순회하며 인스턴스를 만들어 datalist 배열에 넣는다.
//        for (title,opendate,desc,rating,thumbnail) in self.dataset {
//            let mvo = MovieVO()
//            mvo.title = title
//            mvo.description = desc
//            mvo.opendate = opendate
//            mvo.rating = rating
//            mvo.thumbnail = thumbnail
//
//            datalist.append(mvo)
//        }
        //datalist배열을 리턴
        return datalist
    }() // list 프로퍼티에 데이터들이 차례대로 대입된다.
    
    @IBOutlet var moreBtn: UIButton!
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.tableView.reloadData()
    }
    
    func callMovieAPI() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        //REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API result = \(log)")
        
        //JSON객체를 파싱하여 NSDictionary 객체로 받음
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUel"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                self.list.append(mvo)
                
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                if (self.page >= totalCount){
                    self.moreBtn.isHidden = true
                }
            }
        } catch{
            NSLog("Parsing Error!")
        }
    }
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 읽어온다.
        let row = self.list[indexPath.row]
        
        //테이블 셀 객체를 직접 생성하는 대신 큐로부터 가저옴
//        let cell1 = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "ListCell_Class") as! MovieCell
        
        //cell1
//        let title = cell1.viewWithTag(101) as? UILabel
//        let des = cell1.viewWithTag(102) as? UILabel
//        let opendate = cell1.viewWithTag(103) as? UILabel
//        let rating = cell1.viewWithTag(104) as? UILabel
//        title?.text = row.title
//        des?.text = row.description
//        opendate?.text = row.opendate
//        rating?.text = "\(row.rating!)"
        
        //cell2
        cell2.title?.text = row.title
        cell2.desc.text = row.description
        cell2.opendate.text = row.opendate
        cell2.rating.text = "\(row.rating!)"
        
        //thumbnail 이미지 생성
//        cell2.thumbnail.image = UIImage(named: row.thumbnail!) // 메모리에 캐싱
//        cell2.thumbnail.image = UIImage(contentsOfFile: row.thumbnail!) //그때그때 읽어옴.
        cell2.thumbnail.image = UIImage(data: try! Data(contentsOf: URL(string: row.thumbnail!)!))
        
        return cell2
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 50
//    }
    
}
