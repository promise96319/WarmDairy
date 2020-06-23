//
//  DiaryLocationManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/4.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation
import CoreLocation
import AMapSearchKit
import AMapLocationKit

protocol DiaryLocationDelegate {
    func onGeoCodeSearchDone(latitude: CGFloat?, longitude: CGFloat?) -> Void
}

class DiaryLocationManager: NSObject {
    static let shared = DiaryLocationManager()
    
    var delegate: DiaryLocationDelegate?
    
    /// 高德地图 api key
    var key = "51102dd22bf68906ef06addb7da8e54a"
    
    lazy var searchManager = AMapSearchAPI()!
    lazy var locationManager = AMapLocationManager()
    lazy var lm = CLLocationManager()
    
    private override init() {
        super.init()
        AMapServices.shared()?.apiKey = key
        searchManager.delegate = self
    }
}

extension DiaryLocationManager {
    /// 检查是否开启定位服务
    /// 返回 （是否开启，alert）
    /// 第一个参数为true说明开启了，否则没有开启
    /// 第二参数为 UIAlertController, 没开启时返回这个参数，则需 present 进行开启
    func checkAuth() -> (Bool, UIAlertController?) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return (true, nil)
        case .notDetermined:
            lm.requestWhenInUseAuthorization()
            break
        case .denied:
            let alert = UIAlertController(title: "温馨提示", message: "您还未开启定位服务，无法进行定位", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "拒绝", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "前往设置", style: .default, handler: {
                ACTION in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                                    CLog("开启设置")
                        })
                    } else {
                        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                        
                    }
                })
            })
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            return (false, alert)
        default:
            DispatchQueue.main.async {
                MessageTool.shared.showMessage(theme: .error, title: "当前设备不支持定位服务")
            }
            break
        }
        return (false, nil)
    }
    
    func getCurrentPosition(completion: @escaping (CLLocation?, AMapLocationReGeocode?, Error?) -> Void) {
        locationManager.locationTimeout = 6
        locationManager.reGeocodeTimeout = 4
        locationManager.requestLocation(withReGeocode: true) { (location, code, error) in
            completion(location, code, error)
        }
    }
    
    func getGeocodeCoordirateFromAddress(address: String) {
        let request = AMapGeocodeSearchRequest()
        request.address = address
        searchManager.aMapGeocodeSearch(request)
    }
}

extension DiaryLocationManager: AMapSearchDelegate {
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.count == 0 {
            delegate?.onGeoCodeSearchDone(latitude: nil, longitude: nil)
            return
        }
        
        let res = response.geocodes[0].location

        delegate?.onGeoCodeSearchDone(latitude: res?.latitude, longitude: res?.longitude)
        
    }
}
