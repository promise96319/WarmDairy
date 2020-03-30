//
//  CategoryViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/16.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import DTCoreText
import SwiftDate
import ViewAnimator

class CategoryViewController: UIViewController {
    lazy var totleDairies = [DairyModel]()
    lazy var filetedDairies = [DairyModel]()
    
    lazy var searchController = UISearchController(searchResultsController: SearchDairyViewController())

    
    lazy var categories = [CategoryYearModel]()
    lazy var favoriteData = [CustomCategoryModel]()
    
    var mreader: DUAReader?
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var myFavoriteSection = CategorySection()
    lazy var categorySections = [CategorySection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavoriteData), name: .categoryDidChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAll), name: .dairyDidAdded, object: nil)
        setupUI()
        loadFavoriteData()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnimations()
    }
    
    func setupAnimations() {
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 120.0)
        view.animate(animations: [fromAnimation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 1)
        
        let cellFromAnimation = AnimationType.from(direction: .right, offset: 100.0)
        UIView.animate(views: myFavoriteSection.collectionView.orderedVisibleCells,
                       animations: [cellFromAnimation],
                       delay: 0.2,
                       duration: 1)
        for (index, section) in categorySections.enumerated() {
            UIView.animate(views: section.collectionView.orderedVisibleCells,
            animations: [cellFromAnimation],
            delay: 0.2 * Double(index + 2),
            duration: 1)
        }
    }
    
    @objc func loadFavoriteData() {
        CategoryAPI.getCategoriesWithDairies { [weak self] (categories) in
            self?.favoriteData = categories
            self?.myFavoriteSection.initFavoriteData(data: categories)
            self?.myFavoriteSection.collectionView.reloadData()
        }
    }
    
    @objc func reloadAll() {
        loadFavoriteData()
        loadData()
    }
    
    func loadData() {
        DairyAPI.getDairy() { [weak self] (dairies) in
            guard let weakSelf = self else { return }
            weakSelf.totleDairies = dairies
            weakSelf.categories = weakSelf.formatDairies(dairies: dairies)
            DispatchQueue.main.async { [weak self] in
                self?.setupCategorySection()
            }
        }
    }
    
    func formatDairies(dairies: [DairyModel]) -> [CategoryYearModel] {
        /// [
        ///  year: 2020,
        ///  months: [
        ///     [month: 2,
        ///     dairies: [DairyModel]],
        ///     [month: 3,
        ///     dairies: [DairyModel]]
        ///  ]
        /// ]
        
        var results = [CategoryYearModel]()
        
        for dairy in dairies {
            let year = dairy.createdAt.year
            let month = dairy.createdAt.month
            var foundYearIndex = -1
            var foundMonthIndex = -1
            for (yearIndex, yearData) in results.enumerated() {
                if yearData.year == year {
                    foundYearIndex = yearIndex
                    for (monthIndex, monthData) in yearData.months.enumerated() {
                        if monthData.month == month {
                            foundMonthIndex = monthIndex
                        }
                    }
                }
            }
            
            if foundYearIndex != -1 {
                if foundMonthIndex != -1 {
                    /// 每一次添加日记，判断一下日记是否加锁，如果加锁，则该分类加锁
                    if dairy.isLocked {
                        results[foundYearIndex].months[foundMonthIndex].isLocked = true
                    }
                    results[foundYearIndex].months[foundMonthIndex].dairies.append(dairy)
                } else {
                    let monthData = CategoryMonthModel()
                    monthData.month = month
                    if dairy.isLocked {
                        monthData.isLocked = true
                    }
                    monthData.dairies.append(dairy)
                    results[foundYearIndex].months.append(monthData)
                }
            } else {
                let monthData = CategoryMonthModel()
                monthData.month = month
                if dairy.isLocked {
                    monthData.isLocked = true
                }
                monthData.dairies.append(dairy)
                let newData = CategoryYearModel()
                newData.year = year
                newData.months.append(monthData)
                results.append(newData)
            }
        }
        
        results = results.sorted(by: { $0.year > $1.year })
        
        return results
    }
    
    deinit {
        CLog("category 注销")
        NotificationCenter.default.removeObserver(self, name: .categoryDidChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .dairyDidAdded, object: nil)
    }
}

// MARK: - search
extension CategoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let value = searchController.searchBar.text
        guard let v = value else {
            return
        }
        if v == "" { return }
        
        AnalysisTool.shared.logEvent(event: "category_searchbar_used")
        
        filetedDairies = totleDairies.filter { (dairy) -> Bool in
            
            let date1 = dairy.createdAt.toFormat("yyyy年MM月dd日")
            let date2 = dairy.createdAt.toFormat("yyyy-MM-dd")
            let week = dairy.createdAt.weekdayName(.default, locale: Locales.chineseSimplified)
            let isDate = date1.contains(v) || v.contains(date1) || date2.contains(v) || v.contains(date2) || v.contains(week)
            
            if isDate { return true }
            
            let isTitle = dairy.title.contains(v) || (title != "" && v.contains(dairy.title) )
            if isTitle { return true }
            
            let moods = ["开心", "得意", "充实", "惊喜", "惊讶", "迷茫", "孤独", "难过", "委屈", "烦躁", "大哭", "生气"]
            var isMood = false
            moods.forEach { (mood) in
                if mood.contains(v) || (mood != "" && v.contains(mood)) {
                    isMood = true
                }
            }
            
            if isMood { return true }
            
            let isContent = dairy.content.contains(v)
            
            if isContent { return true }
            
            return false
        }
        
        let vc = searchController.searchResultsController as? SearchDairyViewController
        vc?.initData(dairies: filetedDairies)

    }
}

// MARK: - UI
extension CategoryViewController {
    func setupUI() {
        setupBg()
        setupSearchBar()
        setupFavorite()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "搜索日记"
        searchController.searchBar.setValue("取消", forKey: "cancelButtonText")
        definesPresentationContext = true
        
        navigationItem.title = "归档"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            
            // TODO: - search bar 低版本下显示不全问题
            _ = searchController.searchBar.then {
                $0.backgroundImage = nil
                $0.layer.borderWidth = 0
                $0.barTintColor = UIColor(hexString: "F1F6FA")
                contentView.addSubview($0)
                $0.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: $0.frame.height)
            }
        }
    }
    
    func setupFavorite() {
        _ = myFavoriteSection.then {
            $0.delegate = self
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                if #available(iOS 11.0, *) {
                    $0.top.equalToSuperview().offset(20)
                } else {
                    $0.top.equalToSuperview().offset(64)
                }
                $0.left.right.equalToSuperview()
                $0.height.equalTo(CategorySectionFrameModel.sectionHeight)
            }
        }
    }
    
    func setupCategorySection() {
        for section in categorySections {
            section.removeFromSuperview()
        }
        categorySections = []
        
        if categories.count == 0 {
            myFavoriteSection.snp.makeConstraints {
                if #available(iOS 11.0, *) {
                    $0.top.equalToSuperview().offset(20)
                } else {
                    $0.top.equalToSuperview().offset(64)
                }
                $0.left.right.equalToSuperview()
                $0.height.equalTo(CategorySectionFrameModel.sectionHeight)
                $0.bottom.equalTo(contentView).offset(-100)
            }
        } else {
            myFavoriteSection.snp.removeConstraints()
            myFavoriteSection.snp.makeConstraints {
                if #available(iOS 11.0, *) {
                    $0.top.equalToSuperview().offset(20)
                } else {
                    $0.top.equalToSuperview().offset(64)
                }
                $0.left.right.equalToSuperview()
                $0.height.equalTo(CategorySectionFrameModel.sectionHeight)
            }
        }
        
        for (index, section) in categories.enumerated() {
            _ = CategorySection().then {
                $0.initData(year: section.year, monthData: section.months)
                $0.delegate = self
                categorySections.append($0)
                contentView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalTo(myFavoriteSection.snp.bottom).offset(CGFloat(index) * CategorySectionFrameModel.sectionHeight)
                    $0.height.equalTo(CategorySectionFrameModel.sectionHeight)
                    if index == categories.count - 1 {
                        $0.bottom.equalTo(contentView).offset(-CustomTabBarView.tabbarHeight)
                    }
                }
            }
        }
    }
    
    func setupBg() {
        view.backgroundColor = UIColor(hexString: "F1F6FA")
        
        _ = scrollView.then {
            view.addSubview($0)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        _ = contentView.then {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(view)
            }
        }
    }
}

// MARK: - reader
extension CategoryViewController: DUAReaderDelegate {
    func readerDidClickSettingFrame(reader: DUAReader) {
        if reader.bottomBar.alpha == 0 {
            reader.showBar()
        } else {
            reader.hideBar()
        }
    }
    
    func reader(reader: DUAReader, readerStateChanged state: DUAReaderState) {
        
    }
    
    func reader(reader: DUAReader, readerProgressUpdated curChapter: Int, curPage: Int, totalPages: Int) {
        
    }
    
    func reader(reader: DUAReader, chapterTitles: [String]) {
        
    }
    
}

extension CategoryViewController {
    func setupReader(dairies: [DairyModel], url: String = "") {
        mreader = DUAReader()
        let configuration = DUAConfiguration()
        
        if url == "" {
            configuration.backgroundImage =  R.image.image_editor_bg()
        } else {
            if let imageUrl = URL(string: url) {
                let data = NSData(contentsOf: imageUrl)
                if let imageData = data {
                    configuration.backgroundImage = UIImage(data: imageData as Data)
                } else {
                    configuration.backgroundImage =  R.image.image_editor_bg()
                }
            } else {
                configuration.backgroundImage =  R.image.image_editor_bg()
            }
        }
        configuration.bookType = .epub
        configuration.backgroundColor = .yellow
        mreader?.config = configuration
        mreader?.delegate = self
        mreader?.modalPresentationStyle = .fullScreen
        present(mreader!, animated: true, completion: nil)
        
        mreader?.readWith(dairies: dairies, pageIndex: 1)
        mreader?.setupUI()
    }
}
