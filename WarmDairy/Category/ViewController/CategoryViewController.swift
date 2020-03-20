//
//  CategoryViewController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/16.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit
import DTCoreText

class CategoryViewController: UIViewController {
    
    lazy var categories = [CategoryYearModel]()
    
    var mreader: DUAReader?
    
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var categorySections = [CategorySection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    func loadData() {
        DairyAPI.getDairy() { (dairies) in
            self.categories = self.formatDairies(dairies: dairies)
            DispatchQueue.main.async {
                self.setupCategorySection()
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
                    results[foundYearIndex].months[foundMonthIndex].dairies.append(dairy)
                } else {
                    let monthData = CategoryMonthModel()
                    monthData.month = month
                    monthData.dairies.append(dairy)
                    results[foundYearIndex].months.append(monthData)
                }
            } else {
                let monthsData = CategoryMonthModel()
                monthsData.month = month
                monthsData.dairies.append(dairy)
                let newData = CategoryYearModel()
                newData.year = year
                newData.months.append(monthsData)
                results.append(newData)
            }
        }
        return results
    }
}

extension CategoryViewController: DUAReaderDelegate {
    func readerDidClickSettingFrame(reader: DUAReader) {
        print("测试 ===> dianjiale的值为: \(111)")
        print("测试 ===> red的值为: \(reader.bottomBar.alpha)")
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
    func setupReader(dairies: [DairyModel]) {
        mreader = DUAReader()
        let configuration = DUAConfiguration()
        configuration.backgroundImage = R.image.image_editor_bg()
        configuration.bookType = .epub
        configuration.backgroundColor = .green
        mreader?.config = configuration
        mreader?.delegate = self
        mreader?.modalPresentationStyle = .fullScreen
        present(mreader!, animated: true, completion: nil)
        
        mreader?.readWith(dairies: dairies, pageIndex: 1)
        mreader?.setupUI()
    }
}


extension CategoryViewController {
    func setupUI() {
        setupBg()
    }
    
    func setupCategorySection() {
        for section in categorySections {
            section.removeFromSuperview()
        }
        categorySections = []
        
        for (index, section) in categories.enumerated() {
            _ = CategorySection().then {
                $0.initData(year: section.year, monthData: section.months)
                $0.delegate = self
                categorySections.append($0)
                contentView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalToSuperview().offset(200 + CGFloat(index) * CategorySectionFrameModel.sectionHeight)
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
