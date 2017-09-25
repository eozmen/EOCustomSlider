//
//  EOCustomSlider.swift
//  EOCustomSlider
//
//  Created by Ece Ozmen on 22/09/2017.
//  Copyright © 2017 Ece Ozmen. All rights reserved.
//

import UIKit

@IBDesignable class EOCustomSlider: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var dropImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var sliderLine: UIView!
    @IBOutlet private var tapDetectView: UIView!
    @IBOutlet private var dropImage: UIImageView!
    @IBOutlet private var currentSliderValueLabel: UILabel!
    @IBOutlet private var maxValLabel: UILabel!
    @IBOutlet private var minValLabel: UILabel!
    private var leadingPartWidth : CGFloat = 0.0
    private var sliderValue = 0
    
    var maxPoint : Int = 10
    var isReferenceLabels_visible : Bool = false
    
    var colorLine_Start : UIColor = UIColor.white
    var colorLine_End : UIColor = UIColor.white
    var colorCurrentValueLabel : UIColor = UIColor.white
    var colorReference_label : UIColor = UIColor.white
    
    @IBInspectable var labelVisibility: Bool {
        get {
            return isReferenceLabels_visible
        }
        set(labelVisibility) {
            isReferenceLabels_visible = !labelVisibility
        }
    }
    @IBInspectable var max_point: Int {
        get {
            return maxPoint
        }
        set(max_point) {
            maxPoint = max_point
        }
    }
    @IBInspectable var image: UIImage {
        get {
            return dropImage.image!
        }
        set(image) {
            dropImage.image = image
        }
    }
    
    @IBInspectable var currentLabelColor: UIColor {
        get {
            return colorCurrentValueLabel
        }
        set(currentLabelColor) {
            colorCurrentValueLabel = currentLabelColor
        }
    }
    @IBInspectable var labelColor: UIColor {
        get {
            return colorReference_label
        }
        set(labelColor) {
            colorReference_label = labelColor
        }
    }
    @IBInspectable var startColor: UIColor {
        get {
            return colorLine_Start
        }
        set(startColor) {
            colorLine_Start = startColor
        }
    }
    
    @IBInspectable var endColor: UIColor {
        get {
            return colorLine_End
        }
        set(endColor) {
            colorLine_End = endColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.leadingPartWidth  = self.sliderLine.frame.origin.x - self.dropImage.frame.size.width/2
        self.getMaximumPoint()
        
        self.currentSliderValueLabel.textColor = colorCurrentValueLabel
        self.minValLabel.textColor = colorReference_label
        self.maxValLabel.textColor = colorReference_label
        self.maxValLabel.isHidden = labelVisibility
        self.minValLabel.isHidden = labelVisibility
        
        self.minValLabel.text = "0"
        slider()
        moveSliderDependOnValue()
        
    }
    // Performs the initial setup.
    private func commonInit() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
        
        
        // The Main Stuff
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        
        return view
    }
    func slider(){
        
        self.dropImageLeadingConstraint.constant = self.leadingPartWidth
        
        
        
        self.dropImage.isUserInteractionEnabled = true
        
        
        
        let pangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.followFinger))
        self.dropImage.addGestureRecognizer(pangestureRecognizer)

        
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapFinger))
        self.tapDetectView.addGestureRecognizer(tapgestureRecognizer)

        
        
        
        let gradient =  gradientColor(view:self.sliderLine, c1: colorLine_Start, c2: colorLine_End)
        
        self.sliderLine.layer.insertSublayer(gradient, at:0)
        
        self.currentSliderValueLabel.text = self.sliderValue.description
    }
    
    func moveSliderDependOnValue(){
        let realVal = CGFloat(Int(currentSliderValueLabel.text!)!)
        
        let rate = CGFloat(maxPoint) / self.sliderLine.frame.size.width
        let realX = realVal / rate
        print(realX)
        self.dropImageLeadingConstraint.constant = realX + self.leadingPartWidth
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.currentSliderValueLabel.center = CGPoint(x:self.dropImage.center.x, y:self.currentSliderValueLabel.center.y)
            self.layoutIfNeeded()
            
        })
    }
    
    func getMaximumPoint(){
        self.maxValLabel.text = String(Int(maxPoint))
    }
    
    func gradientColor(view:UIView, c1: UIColor, c2: UIColor)-> CAGradientLayer{
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [c1.cgColor, c2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        return gradient
    }
    
    //MARK: GestureRecognizer
    
    @IBAction func tapFinger(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let translation = gestureRecognizer.location(in: self)
        
        var floatval = CGFloat(maxPoint)
        floatval = floatval * (translation.x - self.sliderLine.frame.origin.x) / self.sliderLine.frame.size.width
        
        self.currentSliderValueLabel.text =  "\(Int(round(floatval)))"
        moveSliderDependOnValue()

        
    }
    
    @IBAction func followFinger(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if (gestureRecognizer.view!.center.x + translation.x <= contentView.frame.size.width-10) &&
                (gestureRecognizer.view!.center.x + translation.x>=10){
                // note: 'view' is optional and need to be unwrapped
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                
                var floatval = CGFloat(maxPoint)
                floatval = floatval * (gestureRecognizer.view!.center.x - self.sliderLine.frame.origin.x) / self.sliderLine.frame.size.width
                
                self.currentSliderValueLabel.text =  "\(Int(round(floatval)))"
                self.currentSliderValueLabel.center = CGPoint(x: currentSliderValueLabel.center.x + translation.x, y: self.currentSliderValueLabel.center.y)
                
                
                
            }
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        }else
            if gestureRecognizer.state == .ended  {
                moveSliderDependOnValue()
        }
    }
    

}
