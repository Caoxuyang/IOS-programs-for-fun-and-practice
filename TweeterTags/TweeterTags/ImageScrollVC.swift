//
//  ImageScrollVC.swift
//  TweeterTags
//
//  Created by Kristine Lam on 2018/3/11.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class ImageScrollVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    private var image: UIImage? = nil
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPhoto.image = image
        print("Im in the imageVC")
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgPhoto
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
