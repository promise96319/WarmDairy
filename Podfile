# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'WarmDairy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WarmDairy
  
  pod 'R.swift'                 # 资源管理框架（图片，本地化等等）
  pod 'Then'                    # Swift 初始化的语法糖
  pod 'SnapKit', '~> 5.0.0'     # 布局
  pod 'SwiftyUserDefaults', '~> 3.0.1'      # userDefault持久化存储

  pod 'DTCoreText'   # 阅读器解析库

#  pod "Qiniu", "~> 7.3" # 七牛图片数据
  
#  pod 'IceCream'     # iCloud 同步 realm
  pod 'Realm'
  pod 'RealmSwift'
  
  pod 'SwiftTheme'   # 主题切换
  pod 'ViewAnimator' # view 动画
  pod 'Hero'         # controller 转场动画
#  pod 'Charts'       # 表格
  pod 'Kingfisher'   # 图片加载
  pod 'FSPagerView'  # 轮播图
  pod 'RQShineLabel' # shine label
  pod 'SwiftDate'    # date 格式化
  pod 'SwiftMessages' # message
  pod 'MBProgressHUD' # loading
  
  pod 'SwiftyStoreKit' # 内购
  
  pod 'Firebase/Analytics' # 事件分析
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.13.3' # Fabric 崩溃统计包含事件统计
  script_phase :name=> 'Fabric',
  :script=> '"${PODS_ROOT}/Fabric/run"',
  :input_files=> ['$SRCROOT/$PRODUCT_NAME/$(INFOPLIST_PATH)']
  
  pod 'AMap2DMap'
  pod 'AMapSearch'
  pod 'AMapLocation'
  pod 'DZMAnimatedTransitioning'
end
