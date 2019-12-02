//
//  ViewController.swift
//  ClearScore
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import UIKit

class ClearScoreViewController: UIViewController, ClearScoreViewModelProtocol {

    
    @IBOutlet weak var creditScoreLabel: UILabel!
    @IBOutlet weak var outermeterFrame: UIView!
    @IBOutlet weak var maximumScoreLabel: UILabel!
    @IBOutlet weak var creditViewContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var creditViewContainerheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorMessageContainer: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var refreshReportButton: UIButton!
    var clearScoreViewModel :ClearScoreViewModel?
    
    @IBOutlet weak var innerMeterFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearScoreViewModel?.fetchCreditReport()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshReportButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        forceRedrawWithExistingParameters()
    }
    
    func configureController(withViewModel viewModel :ClearScoreViewModel){
        clearScoreViewModel =  viewModel
        clearScoreViewModel?.viewModelDelegate = self
    }
    
    func viewModelFetchedReport(withScore creditScore: Int, maximumScore: Int, andErrorMessage errorMessage: String?) {
        
        DispatchQueue.main.async { [weak self] in
            
            if(errorMessage == nil){
                
                self?.errorMessageContainer.isHidden = true
                let creditPercent = CGFloat(self?.computeFractionalScore(fromScore :creditScore, andMaximum :maximumScore) ?? -1.0 * .pi/2)
                
                self?.addCircle(inView: self!.outermeterFrame, withAngle: (2 * .pi), lineWidth: 3, color: UIColor.black)
                self?.addCircle(inView: self!.innerMeterFrame, withAngle: creditPercent, lineWidth: 7, color: UIColor(red: 253.0/255.0, green: 197.0/255.0, blue: 100.0/255.0, alpha: 1.0))
                
                self?.creditScoreLabel.text = "\(creditScore)"
                self?.maximumScoreLabel.text = "out of \(maximumScore)"
            }
            else{
                self?.errorMessageContainer.isHidden = false
                self?.errorMessageLabel.text = errorMessage!
            }
        }
    }
    
    func computeFractionalScore(fromScore creditScore :Int, andMaximum maxScore :Int) -> Double {
        
        var fractionalScore = -1.0 * .pi/2 //We start drawing at -90deg
        if(maxScore > 0){
            fractionalScore = fractionalScore + ( Double(creditScore) / Double(maxScore)) * 2.0 * .pi
        }
        
        return fractionalScore
    }
    
    func addCircle(inView targetView:UIView, withAngle angle:CGFloat, lineWidth :CGFloat, color :UIColor)
    {
        let circleWidth = targetView.frame.size.width
        let circleHeight = circleWidth

            // Create a new CircleView
        
        let frame = CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight)
        let circleView = CreditScoreMeter(frame: frame, requiredAngle:angle, lineWidth: lineWidth, color: color)

         targetView.addSubview(circleView)

         // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 1.0)
    }
    
    func forceRedrawWithExistingParameters()
    {
        let maximumAvailableSpace = min(self.view.frame.size.width, self.view.frame.size.height)
        
        creditViewContainerWidthConstraint.constant = maximumAvailableSpace - 2 * 40
        creditViewContainerheightConstraint.constant = maximumAvailableSpace - 2 * 40
        
        if (self.view.frame.size.width > self.view.frame.size.height){
            captionLabel.isHidden = true
            refreshReportButton.isHidden = true
        }
        else{
            captionLabel.isHidden = false
            refreshReportButton.isHidden = false
        }
    }
    
    @IBAction func refreshReportRequest(_ sender: Any)
    {
        creditScoreLabel.text = "-- --"
        maximumScoreLabel.text = ""
        let subViews = innerMeterFrame.subviews
        
        for thisSubview in subViews {
            thisSubview.removeFromSuperview()
        }
        
        clearScoreViewModel?.fetchCreditReport()
    }
    


}

