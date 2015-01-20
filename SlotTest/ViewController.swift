//
//  ViewController.swift
//  SlotTest
//
//  Created by Marcus Dunlap on 1/19/15.
//  Copyright (c) 2015 Marcus Dunlap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var firstContainer:UIView!
    var secondContainer:UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    var slots:[[Slot]] = []
    
    //Constants
    let kNumberOfSlots = 3
    let kNumberOfContainers = 3
    let kMArginForView:CGFloat = 10.0
    let kSixth:CGFloat = 1.0/6.0
    let kMarginForSlots:CGFloat = 2.0
    let kThird:CGFloat = 1.0/3.0
    let kEigth:CGFloat = 1.0/8.0
    let kHalf:CGFloat = 1.0/2.0
    
    //Labels
    var betLabel:UILabel!
    var creditsLabel:UILabel!
    var winnerPaidLabel:UILabel!
    var betTitleLabel:UILabel!
    var creditsTitleLabel:UILabel!
    var winnerPaidTitleLabel:UILabel!
    var titleLabel:UILabel!
    
    //Stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    //Buttons
    var betOneButton:UIButton!
    var betMaxButton:UIButton!
    var resetButton:UIButton!
    var spinButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpContainerViews()
        setUpFirstContainer(firstContainer)
        setUpThirdContainer(thirdContainer)
        setUpFourthContainer(fourthContainer)
        hardReset()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////////////////////////////////////////////////        IBACTIONS       ////////////////////////////////////////////////////////////////////
    
    func betOneButtonPressed(button: UIButton){
        if credits <= 0 {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        }
        else{
            if currentBet < 5 {
                currentBet += 1
                credits -= 1
                updateMainView()
            }
            else{
                showAlertWithText(message: "You Can Only Bet 5 Credits At A Time")
            }
        }
    }
    
    func betMaxButtonPressed(button: UIButton){
        if credits <= 5 {
            showAlertWithText(header: "Not Enough Credits to Bet Max", message: "Bet Less")
        }
        else{
            if currentBet < 5 {
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateMainView()
            }
            else{
                showAlertWithText(message: "You Can Only Bet 5 Credits At A Time!")
            }
        }
    }
    
    func resetButtonPressed(button: UIButton){
        hardReset()
    }
    
    func spinButtonPressed(button: UIButton){
        removeSlotImageViews()
        slots = Factory.createSlots()
        setUpSecondContainer(self.secondContainer)
        var winningsMultiplier = SlotBrain.computeWinnings(slots)
        winnings = winningsMultiplier * currentBet
        credits += winnings
        currentBet = 0
        updateMainView()
    }
    
    func setUpContainerViews(){
        
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMArginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMArginForView * 2), height: self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMArginForView, y: self.firstContainer.frame.height , width: self.view.bounds.width - (kMArginForView * 2), height: self.view.bounds.height * kSixth * 3))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(secondContainer)
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMArginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height, width: self.view.bounds.width - kMArginForView * 2, height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMArginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height + self.thirdContainer.frame.height, width: self.view.bounds.width - kMArginForView * 2, height: self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
    }
    
    func setUpFirstContainer(containerView: UIView) {
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        self.firstContainer.addSubview(titleLabel)
    }
    
    func setUpSecondContainer(containerView: UIView){
        
        for var containerNum = 0; containerNum < kNumberOfContainers; containerNum++ {
            for var slotNum = 0; slotNum < kNumberOfSlots; slotNum++ {
               
                var slot:Slot
                var slotImageView = UIImageView()
                if slots.count != 0 {
                    let slotContainer = slots[containerNum]
                    slot = slotContainer[slotNum]
                    slotImageView.image = slot.image
                }
                else
                {
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNum) * kThird) + kMarginForSlots, y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNum) * kThird) + kMarginForSlots, width: containerView.bounds.width * kThird - (2 * kMarginForSlots), height: containerView.bounds.height * kThird - (2 * kMarginForSlots))
                containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setUpThirdContainer(containerView: UIView){
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 14)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(betLabel)
        
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.redColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 14)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
        self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(creditsLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 14)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 16)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 16)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winnings"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 16)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(winnerPaidTitleLabel)
    }
    
    func setUpFourthContainer(containerView: UIView){
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.lightGrayColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * kEigth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * kEigth * 3, y: containerView.frame.height * kHalf)
        self.betMaxButton.backgroundColor = UIColor.greenColor()
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEigth * 5, y: containerView.frame.height * kHalf)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(resetButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * kEigth * 7, y: containerView.frame.height * kHalf)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(spinButton)
    }
    
    func removeSlotImageViews(){
        
        if self.secondContainer != nil{
            let container:UIView? =  self.secondContainer
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset(){
        
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        self.setUpSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        updateMainView()
    }
   
    func updateMainView(){
        
        self.betLabel.text = "\(currentBet)"
        self.creditsLabel.text = "\(credits)"
        self.winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertWithText(header:String = "Warning", message:String){
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
         self.presentViewController(alert, animated: true, completion: nil)
    }
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
