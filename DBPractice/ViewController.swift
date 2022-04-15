//
//  ViewController.swift
//  DBPractice
//
//  Created by 최기훈 on 2022/04/15.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(realm.configuration.fileURL!)
        
        test1()
        
    }
    
    func test1() {
        
        let test1 = ScheduleList()
        test1.cellTitle = "기상"
        test1.cellTime = 20220416
        
        if realm.objects(Schedule.self).isEmpty == true {
            let schedule = Schedule()
            schedule.list.append(test1)
            
            try! realm.write{
                realm.add(schedule)
            }
        } else {
            try! realm.write {
                            let schedule = realm.objects(Schedule.self)
                            schedule.first?.list.append(test1)
                    }
        }
        
        
        try! realm.write{
            realm.add(test1)
        }
    }
    
    func test2() {
        try! realm.write{
            realm.deleteAll()
        }
    }


}

class MainDB: Object {
    // 최상위 DB
    
    var savedDate = List<Date>()
    // 점수가 기록된 날짜를 기록
    // -> Date
    
    var title = List<Schedule>()
    // 스케쥴표
    // -> Schedule
    
}

class Date: Object {
    // 날짜와 점수를 기록하는 DB
    
    @objc dynamic var date: Date?
    // 각 수행된 날짜
    // 유일키 (같은 날에 계획 2개 있을 수 없음)
    
    @objc dynamic var allCnt: Int = 0
    // 해당날에 세운 총 계획 수
    
    @objc dynamic var successCnt: Int = 0
    // 해당날에 성공한 계획 수
    
    // 점수는 successCnt/allCnt를 변수로 따로 저장
}

class Schedule: Object {
    // 스케쥴표 관리하는 DB
    
    @objc dynamic var title: String = ""
    // 해당날 스케쥴표의 제목 (해당 제목으로 저장된 기록 가져오기), title로 찾아서 list를 불러오면 될 듯?
    // ex) 영어학원 가는 날, 화요일
    
    var list = List<ScheduleList>()
    // 해당날의 세부 스케쥴 표
    // -> ScheduleList
}

class ScheduleList: Object {
    // 세부 스케쥴표를 관리하는 DB
    
    @objc dynamic var cellTitle: String = ""
    // 세부 스케줄의 제목 (ex) 기상)
    @objc dynamic var cellTime: Int = 0
    // Int말고 시간으로 바꿔야 함
    // 세부 스케쥴의 시간 (ex) 08:15)
}
