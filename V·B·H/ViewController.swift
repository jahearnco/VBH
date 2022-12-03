//
//  ViewController.swift
//  Very Big Heads
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class Trumpish {
    var url:URL!
    var quote: String
    var audio: String
    var fontSize: Double
    init (urlStr:String, quote:String, audio:String, fontSize:Double) {
        self.url = URL(string:urlStr)
        self.quote = quote
        self.audio = audio
        self.fontSize = fontSize
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var diceImageView1:UIImageView!
    @IBOutlet weak var diceImageView2:UIImageView!
    @IBOutlet weak var rollButton: UIButton!

    @IBOutlet weak var matchImagesLabel: UILabel!
    @IBOutlet weak var MAGALabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!

    @IBOutlet weak var textResultView: UIView!
    @IBOutlet weak var bottomView: UIView!
    private var player: AVPlayer?
    
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
    private var imageAudio1:String = "https://everphase.net/audio/i_like_china.mp3"
    private var imageAudio2:String = "https://everphase.net/audio/i_like_china.mp3"
    private var imageQuoteFontSize1:Double = 32.0
    private var imageQuoteFontSize2:Double = 32.0
    
    private var imageQuote0:String = "Match my very big heads.\rVery very big. Match em!\r-The Donald"
    private var imageQuoteFontSize0:Double = 24.0
    
    private let diceImageViewList = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")] as Array
    
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

        matchImagesLabel.font = matchImagesLabel.font.withSize(_:imageQuoteFontSize0)
        matchImagesLabel.text = imageQuote0
        
        print("viewDidLoad Loaded")
        
        Timer.scheduledTimer(
            timeInterval: 1.1,
            target:self,
            selector:#selector(flashMatchLabel),
            userInfo:nil,
            repeats:true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            //imageView.image = UIImage(named: const2)
            middleView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            matchImagesLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            diceImageView1.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            diceImageView2.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        } else {
            print("Portrait")
            //imageView.image = UIImage(named: const)
            middleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            matchImagesLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            diceImageView1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            diceImageView2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
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

    func initPlaySound(audioURL: String) {

        let url  = URL.init(string: audioURL)

        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
                self.view.layer.addSublayer(playerLayer)
            
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
        
        let d1 = Int.random(in: 0...3) as Int
        let d2 = Int.random(in: 0...3) as Int
        
        //diceImageView1.image = diceImageViewList[d1]
        //diceImageView2.image = diceImageViewList[d2]
        
        imageUrl1 = trumpishList[d1].url
        imageUrl2 = trumpishList[d2].url
        
        imageQuote1 = trumpishList[d1].quote
        imageQuote2 = trumpishList[d2].quote
    
        imageAudio1 = trumpishList[d1].audio
        imageAudio2 = trumpishList[d2].audio
        
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

    @objc func playClip(){
        player?.play()
    }
    
    @objc func setMatchLabel(_ timer: Timer){
        
        var imageQuoteFontSize = imageQuoteFontSize0
        var imageQuote = imageQuote0
        
        headsMatched = imageQuote1 == imageQuote2

        if (headsMatched){
            imageQuoteFontSize = imageQuoteFontSize1
            imageQuote = imageQuote1
            
            initPlaySound(audioURL: imageAudio1)
            
            Timer.scheduledTimer(
                timeInterval: 0.4,
                target:self,
                selector: #selector(playClip),
                userInfo:nil,
                repeats: false)

        }
        
        rollEm = headsMatched || matchLabelCheckCount == 3
        
        if (rollEm) {
            matchLabelCheckCount = 0
            timerCurrentCount = 0
            rollButton.isSelected = false
            timer.invalidate()
            
            matchImagesLabel.font = matchImagesLabel.font.withSize(_:imageQuoteFontSize)
            matchImagesLabel.text = imageQuote
            trumpishList.shuffle()

        }else{
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
    
    
    func printStatus(){

    }

    private var trumpishList = [
        Trumpish(urlStr:"https://static.dw.com/image/51952058_401.jpg", quote:"Guys tell me they want women of substance, not beautiful models. It just means they can't get beautiful models.", audio:"https://everphase.net/audio/and-we-say-bye-bye.mp3", fontSize:20.0),
        Trumpish(urlStr:"https://www.citypng.com/public/uploads/preview/-11599764115zbhtzptpw3.png", quote:"All of the women on The Apprentice flirted with me - consciously or unconsciously. That's to be expected.", audio:"https://everphase.net/audio/i_like_china.mp3", fontSize:22.0),
        Trumpish(urlStr:"https://media.newyorker.com/photos/5e7d3629358dde0009f1aa1d/4:3/w_2383,h_1787,c_limit/Glasser-CVbriefers.jpg", quote:"Frankly, I wouldn't mind if there were an anti-Viagra, something with the opposite effect. I'm not bragging. I'm just lucky.", audio:"https://everphase.net/audio/hair-pt1.mp3", fontSize:20.0),
        Trumpish(urlStr:"https://www.kindpng.com/picc/m/1-11563_united-politician-trump-youtube-states-donald-crippled-donald.png", quote:"Stop The Steal!!", audio:"https://everphase.net/audio/i-will-be-the-greatest-president-for-many-many-years-to.mp3", fontSize:46.0),
        Trumpish(urlStr:"https://cdn.shopify.com/s/files/1/0600/7078/9314/products/donald-trump-002-bh_600x.jpg?v=1654327396", quote:"You could see there was blood coming out of her eyes.", audio:"https://everphase.net/audio/hair-pt2.mp3", fontSize:26.0),
        Trumpish(urlStr:"https://cdn.media.amplience.net/i/partycity/901117?$large$&fmt=auto&qlt=default", quote:"The concept of global warming was created by and for the Chinese in order to make U.S. manufacturing non-competitive.", audio:"https://everphase.net/audio/im-a-nice-guy.mp3", fontSize:18.0),
        Trumpish(urlStr:"https://d.newsweek.com/en/full/1823510/donald-trump-israel-jewish-voters.jpg?w=1600&h=1600&l=60&t=29&q=88&f=97f2d293405c53db6767ef4110cd58a9", quote:"I’m the least racist person you have ever interviewed.", audio:"https://everphase.net/audio/wet-racoon-pt1.mp3", fontSize:28.0),
        Trumpish(urlStr:"https://www.gannett-cdn.com/-mm-/c3264ce6ba306ccec4b859b7f88550efdebfde22/c=0-29-4454-2545/local/-/media/2017/04/25/USATODAY/USATODAY/636287460541206094-AP-GRIDLOCK-DEJA-VU-90480008.JPG", quote:"I would bet if you took a poll in the FBI I would win that poll by more than anybody’s won a poll.", audio:"https://everphase.net/audio/the-system-is-rigged.mp3", fontSize:24.0),
        Trumpish(urlStr:"https://media.vanityfair.com/photos/5d34b4197ff7570008cb1a25/4:3/w_1186,h_889,c_limit/trump-maga-wedding.jpg", quote:"Some people would say I'm very, very, very intelligent.", audio:"https://everphase.net/audio/and_it_not_just_mexicans.mp3", fontSize:28.0),
        Trumpish(urlStr:"https://d.newsweek.com/en/full/2106022/donald-trump-reinstatement-2020-election-ridicule-reactions.jpg", quote:"Sorry losers and haters, but my IQ is one of the highest.", audio:"https://everphase.net/audio/ah-im-smart.mp3", fontSize:28.0)
    ] as Array
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

