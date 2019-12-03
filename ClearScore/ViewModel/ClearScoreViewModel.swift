//
//  ClearScoreViewModel.swift
//  ClearScore
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

protocol ClearScoreViewModelProtocol {
    func viewModelFetchedReport(withScore creditScore:Int, maximumScore :Int, fractionalScore :Double, andErrorMessage errorMessage :String?)
}

class ClearScoreViewModel :NSObject {
    
    private let kResourceBaseUrl = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values"
    private let kResourceUrlQuery = ""
    private var networkQueryService : NetworkQueryService!
    private var creditReport :CreditReport.CreditReportInfo?
    
    var viewModelDelegate :ClearScoreViewModelProtocol?
    
    init(withNetworkQueryService queryService: NetworkQueryService) {
        super.init()
        networkQueryService = queryService
    }
    
    
    func fetchCreditReport()
    {
        networkQueryService.performNetworkQuery(withBaseUrlString: kResourceBaseUrl, andQueryString: kResourceUrlQuery, completion: processNetworkQuery(returnedData:queryError:))
    }
    
    func processNetworkQuery(returnedData data :Data?, queryError error :Error?){
        
        
        //Notify delegate with error when we are done.
        if(error == nil){
            do{
                
                creditReport = try JSONDecoder().decode(CreditReport.self, from: data!).creditReportInfo
                
                let fractionalScore = computeFractionalScore(fromScore: creditReport?.score, andMaximum: creditReport?.maxScoreValue)
                
                if(fractionalScore != nil)
                {
                    //If we have a valid fractional score, then its safe to unwrap creditReport
                    self.viewModelDelegate?.viewModelFetchedReport(withScore: creditReport!.score, maximumScore: creditReport!.maxScoreValue, fractionalScore: fractionalScore!, andErrorMessage: nil)
                }
                else{
                    self.viewModelDelegate?.viewModelFetchedReport(withScore: 0, maximumScore: 0, fractionalScore: 0, andErrorMessage: NSLocalizedString("Credit report could not be calculated.", comment: "NEEDS_LOCALIZATION"))
                }
                
            }
            catch{
                self.viewModelDelegate?.viewModelFetchedReport(withScore: 0, maximumScore: 0, fractionalScore: 0, andErrorMessage: NSLocalizedString("Credit report could not be retrieved.", comment: "NEEDS_LOCALIZATION"))
            }
        }
        else{
            
            self.viewModelDelegate?.viewModelFetchedReport(withScore: 0, maximumScore: 0, fractionalScore: 0, andErrorMessage:error?.localizedDescription)
        }
    }
    
    func computeFractionalScore(fromScore creditScore :Int?, andMaximum maxScore :Int?) -> Double? {
        
        var fractionalScore :Double?
        
        if let cScore = creditScore, let mScore = maxScore{
            
            if(mScore > 0){
                fractionalScore = ( Double(cScore) / Double(mScore)) * 2.0 * .pi
            }
        }
        
        return fractionalScore
    }
}
