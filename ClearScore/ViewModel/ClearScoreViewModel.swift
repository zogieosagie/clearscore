//
//  ClearScoreViewModel.swift
//  ClearScore
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

protocol ClearScoreViewModelProtocol {
    func viewModelFetchedReport(withScore creditScore:Int, maximumScore :Int, andErrorMessage errorMessage :String?)
}

struct NetworkResponse :Codable {
    var fetchedCreditReport :CreditReport

    enum CodingKeys: String, CodingKey {
        case fetchedCreditReport = "creditReportInfo"
    }
}

class ClearScoreViewModel :NSObject {
    
    private let kResourceBaseUrl = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values"
    private let kResourceUrlQuery = ""
    private let networkQueryService = NetworkQueryService()
    private var creditReport :CreditReport?
    
    var viewModelDelegate :ClearScoreViewModelProtocol?
    
    
    func fetchCreditReport()
    {
        networkQueryService.performNetworkQuery(withBaseUrlString: kResourceBaseUrl, andQueryString: kResourceUrlQuery, completion: processNetworkQuery(returnedData:queryError:))
    }
    
    func processNetworkQuery(returnedData data :Data?, queryError error :Error?){
        
        
        //Notify delegate with error when we are done.
        if(error == nil){
            do{
                
                creditReport = try JSONDecoder().decode(NetworkResponse.self, from: data!).fetchedCreditReport
                self.viewModelDelegate?.viewModelFetchedReport(withScore: creditReport?.score ?? 0, maximumScore: creditReport?.maxScoreValue ?? 0, andErrorMessage: nil)
                
            }
            catch{
                self.viewModelDelegate?.viewModelFetchedReport(withScore: 0, maximumScore: 0, andErrorMessage: NSLocalizedString("Credit report could not be retrieved.", comment: "NEEDS_LOCALIZATION"))
            }
        }
        else{
            
            self.viewModelDelegate?.viewModelFetchedReport(withScore: 0, maximumScore: 0, andErrorMessage:error?.localizedDescription)
        }
    }
}
