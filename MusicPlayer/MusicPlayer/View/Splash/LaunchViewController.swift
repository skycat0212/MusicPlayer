//
//  LaunchViewController.swift
//  MusicPlayer
//
//  Created by 김기현 on 2020/11/20.
//

import UIKit
import SDWebImage

class LaunchViewController: UIViewController {
    @IBOutlet weak var launchImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://grepp-cloudfront.s3.ap-northeast-2.amazonaws.com/programmers_imgs/competition-imgs/2020-Flo-challenge/FLO_Splash-Img3x(1242x2688).png")
        launchImageView.sd_setImage(with: url, completed: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let viewController = MusicViewController()
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    deinit {
        print("LaunchViewController deinit")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
