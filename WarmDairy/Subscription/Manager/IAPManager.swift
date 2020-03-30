//
//  IAPManager.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/25.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import Foundation

import SwiftyStoreKit
import StoreKit

public typealias PurchaseCompletion = (_ result: IAPPurchaseResult) -> Void
public typealias RestoreCompletion = (_ result: IAPRestoreResult) -> Void
public typealias VerifyCompletion = (_ result: IAPVerifyResult) -> Void

/// purchase结果
public enum IAPPurchaseResult {
    case success(product: SKProduct, expireDate: Date?)
    case canceled
    case notPurchased
    case purchaseFail
    case expired
    case verifyFail(product: SKProduct)
    case networkError
}

/// restore结果
public enum IAPRestoreResult {
    case fail
    case nothing
    case success(expireDate: Date?)
    case expired
    case networkError
}

/// verify结果
public enum IAPVerifyResult {
    case success(expireDate: Date?)
    case expired
    case notPurchased
    case netError
    case fail
}

public class IAPManager: NSObject {
    
    // 验证密钥
    public var shareSecret = "c13f00b9daf440e0882d3a80955f0e08"
    
    // Product ID
    enum ProductID {
        static let month = "com.GuanghuiQin.WarmDiary.month"
        static let year = "com.GuanghuiQin.WarmDiary.year"
        static let lifetime = "com.GuanghuiQin.WarmDiary.lifetime"
    }
    
    public static let shared = IAPManager()
    private override init() {}
}

extension IAPManager {
    /// 结束未完成的购买，每次启动时要在didFinishLaunchingWithOptions里调用
    func completeTransaction() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                default:
                    CLog("没有未完成的交易")
                    break
                }
            }
        }
    }
    
    func retrieveProductsInfo(productIDs: Set<String>, completion: @escaping (_ result: RetrieveResults) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(productIDs) { result in
            completion(result)
        }
    }
    
    /// 自动续期订阅
    ///
    /// - Parameters:
    ///   - productID: 商品ID
    ///   - completion: 购买结束后的回调
    func purchaseAutoRenewable(productID: String, completion: @escaping PurchaseCompletion) {
        
        SwiftyStoreKit.purchaseProduct(productID, atomically: true) { [weak self] result in
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                self?.verifyAutoRenewable(productID: productID, completion: { (result) in
                    switch result {
                    case .success(let expireDate):
                        completion(IAPPurchaseResult.success(product: purchase.product, expireDate: expireDate))
                    case .expired:
                        completion(IAPPurchaseResult.purchaseFail)
                    case .notPurchased:
                        completion(IAPPurchaseResult.purchaseFail)
                    case .netError:
                        completion(IAPPurchaseResult.networkError)
                    default:
                        completion(IAPPurchaseResult.verifyFail(product: purchase.product))
                    }
                })
            } else  {
                if case .error(let error) = result {
                    switch error.code {
                    case .paymentCancelled:
                        completion(IAPPurchaseResult.canceled)
                    default:
                        completion(IAPPurchaseResult.purchaseFail)
                    }
                } else {
                    completion(IAPPurchaseResult.purchaseFail)
                }
            }
        }
    }
    
    /// 购买消耗型产品
    ///
    /// - Parameters:
    ///   - productID: 商品ID
    ///   - verifyFromApple: 是否向苹果服务器验证购买有效性，默认为false，在自己服务器做验证
    ///   - completion: 购买结束后的回调
    func purchaseConsumable(productID: String, verifyFromApple: Bool = false, completion: @escaping PurchaseCompletion) {
        
        SwiftyStoreKit.purchaseProduct(productID, atomically: true) { [weak self] result in
            
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                if verifyFromApple {
                    self?.verifyConsumable(productID: productID, completion: { (result) in
                        switch result {
                        case .success:
                            completion(IAPPurchaseResult.success(product: purchase.product, expireDate: nil))
                        case .expired:
                            completion(IAPPurchaseResult.expired)
                        case .notPurchased:
                            completion(IAPPurchaseResult.notPurchased)
                        case .netError:
                            completion(IAPPurchaseResult.networkError)
                        case .fail:
                            completion(IAPPurchaseResult.verifyFail(product: purchase.product))
                        }
                    })
                } else {
                    completion(IAPPurchaseResult.success(product: purchase.product, expireDate: nil))
                }
            } else {
                if case .error(let error) = result {
                    switch error.code {
                    case .paymentCancelled:
                        completion(IAPPurchaseResult.canceled)
                    default:
                        completion(IAPPurchaseResult.purchaseFail)
                    }
                } else {
                    completion(IAPPurchaseResult.purchaseFail)
                }
            }
        }
    }
    
    /// 恢复自动续期订阅
    ///
    /// - Parameters:
    ///   - productID: 商品ID
    ///   - completion: 恢复结束后的回调
    func restore(productID: String, completion: @escaping RestoreCompletion) {
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            if results.restoreFailedPurchases.count > 0 {
                CLog("restore 失败")
                completion(IAPRestoreResult.fail)
            } else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                
                self?.verifyAutoRenewable(productID: productID, completion: { (result) in
                    switch result {
                    case .success(let expireDate):
                        completion(IAPRestoreResult.success(expireDate: expireDate!))
                    case .expired:
                        completion(IAPRestoreResult.expired)
                    default:
                        completion(IAPRestoreResult.fail)
                    }
                })
            } else {
                CLog("没有购买")
                completion(IAPRestoreResult.nothing)
            }
        }
    }
    
    /// 恢复购买自动订阅
    func restore(subscription productIDs: Set<String>, completion: @escaping RestoreCompletion) {
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] (results) in
            if results.restoreFailedPurchases.count > 0 {
                CLog("恢复购买失败: \(results.restoreFailedPurchases)")
                completion(.fail)
            } else if results.restoredPurchases.count > 0 {
                CLog("曾今购买成功过: \(results.restoredPurchases)")
                
                for id in productIDs {
                    self?.verifyAutoRenewable(productID: id, completion: { (result) in
                        switch result {
                        case .success(let expireDate):
                            completion(.success(expireDate: expireDate!))
                            break
                        case .expired:
                            completion(.expired)
                            break
                        case .netError:
                            completion(.networkError)
                            break
                        case .notPurchased:
                            completion(.nothing)
                            break
                        case .fail:
                            completion(.fail)
                            break
                        }
                    })
                }
                
            } else {
                CLog("没有购买产品，无法恢复")
                completion(.nothing)
            }
        }
    }
    
    /// 恢复（非）消耗类型订阅
    func restore(nonConsumable productID: String, completion: @escaping RestoreCompletion) {
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] (results) in
            if results.restoreFailedPurchases.count > 0 {
                CLog("Restore 失败: \(results.restoreFailedPurchases)")
                completion(.fail)
            } else if results.restoredPurchases.count > 0 {
                
                CLog("restore的值为: \(results.restoredPurchases)")
                
                CLog("Restore 曾今购买过: \(results.restoredPurchases)")
                guard let purchase = results.restoredPurchases.first else { return }
                
                self?.verifyConsumable(productID: purchase.productId, completion: { (result) in
                    switch result {
                    case .notPurchased:
                        completion(.fail)
                        break
                    case .fail:
                        completion(.fail)
                        break
                    case .success(expireDate: nil):
                        completion(.success(expireDate: Date()))
                        break
                    case .netError:
                        completion(.networkError)
                        break
                    case .expired:
                        completion(.expired)
                        break
                    default:
                        break
                    }
                })
            } else {
                CLog("没有购买（非）消耗性产品")
                completion(.nothing)
            }
        }
    }
    
    /// 验证自动续期订阅票据
    ///
    /// - Parameters:
    ///   - productID: 商品ID
    ///   - completion: 验证结束后的回调
    func verifyAutoRenewable(productID: String, completion: @escaping VerifyCompletion) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.shareSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productID,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expireDate, _):
                    completion(IAPVerifyResult.success(expireDate: expireDate))
                    break
                case .expired(_, _):
                    completion(IAPVerifyResult.expired)
                    break
                case .notPurchased:
                    completion(IAPVerifyResult.notPurchased)
                    break
                }
            case .error(let error):
                
                switch error {
                case .networkError(_):
                    completion(IAPVerifyResult.netError)
                    break
                default:
                    completion(IAPVerifyResult.fail)
                    break
                }
            }
        }
    }
    
    /// 验证消耗型产品票据
    ///
    /// - Parameters:
    ///   - productID: 商品ID
    ///   - completion: 验证结束后的回调
    func verifyConsumable(productID: String, completion: @escaping VerifyCompletion) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.shareSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased:
                    completion(IAPVerifyResult.success(expireDate: nil))
                case .notPurchased:
                    completion(IAPVerifyResult.notPurchased)
                }
            case .error(let error):
                
                switch error {
                case .networkError(_):
                    completion(IAPVerifyResult.netError)
                default:
                    completion(IAPVerifyResult.fail)
                }
            }
        }
    }
}
