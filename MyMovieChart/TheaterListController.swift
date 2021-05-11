//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by 서동운 on 2021/05/11.
//

import UIKit

class TheaterListController: UITableViewController {
    
    // 제네릭 선언 : 배열에 저장되는 객체 타입이 NSDictionary타입이라는 선언
    var list = [NSDictionary]()
    
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    func callTheaterAPI() {
        let reqURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        
        //URL 객체 정의
        let urlObj = URL(string: "\(reqURI)?s_page=\(self.startPoint)&s_List=\(sList)&type=\(type)")
        
        //do~try catch문 : do{} 진행 중간에 오류가 발생하면 catch 블록으로 옮긴다
        do {
            //NSString 객체룰 이용하여 API를 호출하고 그 결과값을 인코딩된 문자열로 받아온다.
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            //NSString으로 받은 문자열 데이터를 utf8로 인코딩 처리한 데이터로 변환
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do {
                //data 객체를 파싱해서 NSArray 객체로 변환
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                for obj in apiArray!{
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석 실패", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
            }
            self.startPoint += sList
        } catch {
            let alert = UIAlertController(title: "실패", message: "데이터 로딩 실패", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        
        //재사용 큐로부터 tCell 식별자에 맞는 셀 객체를 전달받음.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        
        cell.name?.text = obj["상영관명"] as? String
        cell.tel.text = obj["연락처"] as? String
        cell.address.text = obj["소재지도로명주소"] as? String
        return cell
    }
}

