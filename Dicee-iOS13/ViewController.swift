//
//  ViewController.swift
//  Dicee-iOS13
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class Trumpish {
    var url:URL!
    var quote: String
    var fontSize: Double
    init (urlStr:String, quote:String, fontSize:Double) {
        self.url = URL(string:urlStr)
        self.quote = quote
        self.fontSize = fontSize
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var diceImageView1:UIImageView!
    @IBOutlet weak var diceImageView2:UIImageView!
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var matchImagesLabel: UILabel!
    @IBOutlet weak var MAGALabel: UILabel!
    
    @IBOutlet weak var innerViewController: UIImageView!
    
    var player: AVAudioPlayer?
    
    private var rollButtonBackgroundImage = UIImage(named: "Jake")
    
    private var vcCgColor = UIColor(red:255/255, green:74/255, blue:41/255, alpha: 1).cgColor
    
    private var trumpCgColor = UIColor(red:255/255, green:89/255, blue:15/255, alpha: 1).cgColor
    
    private var showMatchText = true
    private var matchLabelCheckCount = 0
    private var timerCurrentCount = 0
    private var rollEm = true
    private var rollInProgress = false
    private var headsMatched = false
    private var showMatchCount = 0
    
    private var imageUrl1:URL! = URL(string:"https://static.dw.com/image/51952058_401.jpg")!
    private var imageUrl2:URL! = URL(string:"https://static.dw.com/image/51952058_401.jpg")!
    private var imageQuote1:String = "Stop The Steal!!"
    private var imageQuote2:String = "Stop The Steal!!"
    private var imageQuoteFontSize1:Double = 32.0
    private var imageQuoteFontSize2:Double = 32.0
    
    private var imageQuote0:String = "Match my very big heads.\rVery very big. Match em!\r-The Donald"
    private var imageQuoteFontSize0:Double = 26.0
    
    private var diceImageViewList = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")] as Array
    private var trumpishList = [
        Trumpish(urlStr:"https://static.dw.com/image/51952058_401.jpg", quote:"Guys tell me they want women of substance, not beautiful models. It just means they can't get beautiful models.", fontSize:20.0),
        Trumpish(urlStr:"https://www.citypng.com/public/uploads/preview/-11599764115zbhtzptpw3.png", quote:"All of the women on The Apprentice flirted with me - consciously or unconsciously. That's to be expected.", fontSize:22.0),
        Trumpish(urlStr:"https://media.newyorker.com/photos/5e7d3629358dde0009f1aa1d/4:3/w_2383,h_1787,c_limit/Glasser-CVbriefers.jpg", quote:"Frankly, I wouldn't mind if there were an anti-Viagra, something with the opposite effect. I'm not bragging. I'm just lucky.", fontSize:20.0),
        //Trumpish(urlStr:"https://www.kindpng.com/picc/m/1-11563_united-politician-trump-youtube-states-donald-crippled-donald.png", quote:"Stop The Steal!!", fontSize:50.0),
        Trumpish(urlStr:"https://cdn.shopify.com/s/files/1/0600/7078/9314/products/donald-trump-002-bh_600x.jpg?v=1654327396", quote:"You could see there was blood coming out of her eyes.", fontSize:26.0),
        Trumpish(urlStr:"https://cdn.media.amplience.net/i/partycity/901117?$large$&fmt=auto&qlt=default", quote:"The concept of global warming was created by and for the Chinese in order to make U.S. manufacturing non-competitive.", fontSize:18.0),
        Trumpish(urlStr:"https://d.newsweek.com/en/full/1823510/donald-trump-israel-jewish-voters.jpg?w=1600&h=1600&l=60&t=29&q=88&f=97f2d293405c53db6767ef4110cd58a9", quote:"I’m the least racist person you have ever interviewed.", fontSize:28.0),
        Trumpish(urlStr:"https://www.gannett-cdn.com/-mm-/c3264ce6ba306ccec4b859b7f88550efdebfde22/c=0-29-4454-2545/local/-/media/2017/04/25/USATODAY/USATODAY/636287460541206094-AP-GRIDLOCK-DEJA-VU-90480008.JPG", quote:"I would bet if you took a poll in the FBI I would win that poll by more than anybody’s won a poll.", fontSize:24.0),
        Trumpish(urlStr:"https://media.vanityfair.com/photos/5d34b4197ff7570008cb1a25/4:3/w_1186,h_889,c_limit/trump-maga-wedding.jpg", quote:"Some people would say I'm very, very, very intelligent.", fontSize:28.0),
        Trumpish(urlStr:"https://d.newsweek.com/en/full/2106022/donald-trump-reinstatement-2020-election-ridicule-reactions.jpg", quote:"Sorry losers and haters, but my IQ is one of the highest.", fontSize:28.0)
    ] as Array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addRoundedBorder(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], color: vcCgColor,  radius: 2)
        
        rollButton.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
        
        rollButton.isSelected = false
        
        diceImageView1.image = #imageLiteral(resourceName: "DiceOne")
        diceImageView1.alpha = 1
        
        diceImageView2.image = #imageLiteral(resourceName: "DiceTwo")
        diceImageView2.alpha = 1
        
        let ivLayer1:CALayer = diceImageView1.layer
        let ivLayer2:CALayer = diceImageView2.layer
            
        ivLayer1.masksToBounds = true
        ivLayer1.borderWidth = 15
        ivLayer1.borderColor = trumpCgColor
        ivLayer1.cornerRadius = diceImageView1.bounds.width / 14

        ivLayer2.masksToBounds = true
        ivLayer2.borderWidth = 15
        ivLayer2.borderColor = trumpCgColor
        ivLayer2.cornerRadius = diceImageView2.bounds.width / 14
        
        Timer.scheduledTimer(
            timeInterval: 1.1,
            target:self,
            selector:#selector(flashMatchLabel),
            userInfo:nil,
            repeats:true)
    }

    @IBAction func rollButtonPressed(_ sender: UIButton) {

        if (!rollInProgress){
            rollInProgress = true
            
            rollButton.isSelected = true
            matchImagesLabel.text = " "
            
            
            Timer.scheduledTimer(
                timeInterval: 0.3,
                target: self,
                selector: #selector(timerAction),
                userInfo: trumpishList,
                repeats: true)
        }
        //timer.tolerance = 0.3
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf:url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, diceImageView:UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                
                guard let newImage = UIImage(data: data) else { return }
                //var newSize: CGSize = CGSizeMake(1000,1000)
                
                let newHeight: Double = 0.1 * newImage.size.height
                let newWidthToHeightRatio: Double = newImage.size.width / newImage.size.height
                
                guard let self = self else { return }
                diceImageView.image = self.cropToBounds(image:newImage, width: newWidthToHeightRatio*newHeight, height: newHeight)
                //func cropToBounds(image: UIImage, width: Double, height: Double)
            }
        }
    }
    
    func keepEmRolling(){
        
        let d1 = Int.random(in: 0...8) as Int
        let d2 = Int.random(in: 0...8) as Int
        
        //diceImageView1.image = diceImageViewList[d1]
        //diceImageView2.image = diceImageViewList[d2]
        
        imageUrl1 = trumpishList[d1].url
        imageUrl2 = trumpishList[d2].url
        
        imageQuote1 = trumpishList[d1].quote
        imageQuote2 = trumpishList[d2].quote
        
        imageQuoteFontSize1 = trumpishList[d1].fontSize
        imageQuoteFontSize2 = trumpishList[d2].fontSize
        
        downloadImage(from: imageUrl1, diceImageView: diceImageView1)
        downloadImage(from: imageUrl2, diceImageView: diceImageView2)
        
        diceImageView1.alpha = 0.3
        diceImageView2.alpha = 0.3
    }
    
    @objc func deDimDaDice(){
        diceImageView1.alpha = 0.7
        diceImageView2.alpha = 0.7
        rollEm = true
    }

    @objc func flashMatchLabel(_ timer: Timer){
        
        MAGALabel.alpha =  !headsMatched ? 1 : showMatchText ? 1 : 0
        matchImagesLabel.alpha = !headsMatched ? 1 : showMatchText ? 1 : 0
        
        if (!showMatchText && showMatchCount > 3){
            showMatchText = true
            headsMatched = false
            
            if (showMatchCount > 10) {
                showMatchCount = 0
            }
        }else{
            showMatchText = !showMatchText
        }
        
        showMatchCount += 1
    }
    
    @objc func setMatchLabel(_ timer: Timer){
        
        if (imageQuote1 == imageQuote2) {
            matchImagesLabel.font = matchImagesLabel.font.withSize(_:imageQuoteFontSize1)
            matchImagesLabel.text = imageQuote1
            headsMatched = true
        }else{
            matchImagesLabel.font = matchImagesLabel.font.withSize(_:imageQuoteFontSize0)
            //matchImagesLabel.text = " "
            matchImagesLabel.text = imageQuote0
            headsMatched = false
        }

        if (matchLabelCheckCount == 3) {
            matchLabelCheckCount = 0

            rollButton.isSelected = false
            rollEm = true

            timerCurrentCount = 0
            
            timer.invalidate()
        }else{
            rollEm = false
            matchLabelCheckCount += 1
        }
    }

    @objc func timerAction(_ timer: Timer){

        if (rollEm){
            
            if timerCurrentCount == 6 {
                
                diceImageView1.alpha = 1
                diceImageView2.alpha = 1
                
                rollInProgress = false
                
                timer.invalidate() // invalidate the timer
                
                Timer.scheduledTimer(
                    timeInterval: 0.3,
                    target:self,
                    selector:#selector(setMatchLabel),
                    userInfo:nil,
                    repeats:true)
                
            } else {
                rollEm = false
                keepEmRolling()
                timerCurrentCount += 1
                
                Timer.scheduledTimer(
                    timeInterval: 0.2,
                    target:self,
                    selector: #selector(deDimDaDice),
                    userInfo:nil,
                    repeats: false)
            }
            
        }
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        //var newSize: CGSize = (widthRatio > heightRatio) ? CGSizeMake(size.width * heightRatio, size.height * heightRatio) : CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        var newSize: CGSize = CGSizeMake((image.size.width/image.size.height)*2000,  2000)


        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in:rect)
        let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func printStatus(){

    }

}

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        
        layer.cornerRadius = CGFloat(radius)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        
    }
}

extension UIViewController {
    func addRoundedBorder(corners: UIRectCorner, color: CGColor = UIColor.black.cgColor, radius: Int = 8) {

        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderColor = color
        view.layer.borderWidth = 12
        
    }
}

