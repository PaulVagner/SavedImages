//
//  ViewController.swift
//  SaveImages
//
//  Created by Paul Vagner on 11/11/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var savedImages: [String] = []
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBAction func prassedCapture(sender: AnyObject) {
   
    let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        
    
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        defer { picker.dismissViewControllerAnimated(true, completion: nil) }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        let s3manager = AFAmazonS3Manager(accessKeyID: accessID, secret: secretKey)
        
        s3manager.requestSerializer.bucket = "paulv-photos"
        s3manager.requestSerializer.region = "AFAmazonS3USStandardRegion"
        
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
        let filePath = paths[0] + "/Image.png"

//        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        UIImagePNGRepresentation(image)?.writeToFile(filePath, atomically: true)

        s3manager.postObjectWithFile(filePath, destinationPath: "image.png", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
        
            let percent = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            
           
            
            }, success: { (response) -> Void in
                
            }, failure: { (error) -> Void in
              
                print(error)
                
    })
    
        //save images to S3
        //get URL and add to array of URL's
        //tell collectionView to reload
        
    }

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    
        return savedImages.count
    
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath)
        
        for v in cell.contentView.subviews {
            
            v.removeFromSuperview()
            
        }
        
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        
        cell.contentView.addSubview(imageView)
        
       return cell
        
    }

    
}












