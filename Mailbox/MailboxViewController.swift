//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Hobgood, Chad on 4/19/16.
//  Copyright © 2016 Hobgood, Chad. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var rescheduleView: UIView!
    @IBOutlet weak var listView: UIView!
    
    var messageOriginalCenter: CGPoint!
    var leftIconOriginalCenter: CGPoint!
    var rightIconOriginalCenter: CGPoint!
    
    var messageBackgroundColor = UIColor(red:0.886, green:0.886, blue:0.886, alpha:1) //grey
    var archiveColor = UIColor(red:0.439, green:0.851, blue:0.384, alpha:1) //green
    var deleteColor = UIColor(red:0.922, green:0.329, blue:0.2, alpha:1) //red
    var laterColor = UIColor(red:0.98, green:0.827, blue:0.2, alpha:1) //yellow
    var listColor = UIColor(red:0.847, green:0.651, blue:0.459, alpha:1) //tan

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSize(width: 320, height: 1400)
        
        messageOriginalCenter = messageImage.center
        leftIconOriginalCenter = leftIcon.center
        rightIconOriginalCenter = rightIcon.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        
        //print(translation)
        
        if sender.state == UIGestureRecognizerState.Began {
            
            messageOriginalCenter = messageImage.center

            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageImage.center.x = messageOriginalCenter.x + translation.x
            
            
            if translation.x > 40 {
                // Show the left icon
                leftIcon.hidden = false
                
                // Hide the right icon
                rightIcon.hidden = true
                
                // Set the check icon
                leftIcon.image = UIImage(named: "archive_icon")
                
                // Make the icon follow the message image
                leftIcon.frame.origin.x = messageImage.frame.origin.x - 40
                
                // Set the bg color
                messageView.backgroundColor = archiveColor
                
            }
            
            if translation.x > 200 {
                // Set the delete icon
                leftIcon.image = UIImage(named: "delete_icon")
                
                // Set the bg color
                messageView.backgroundColor = deleteColor
            
            }
            
            if translation.x < -40 {
                leftIcon.hidden = true
                rightIcon.hidden = false
                rightIcon.image = UIImage(named: "later_icon")
                rightIcon.frame.origin.x = messageImage.frame.origin.x + 320 + 40
                messageView.backgroundColor = laterColor
            }
            
            if translation.x < -200 {
                rightIcon.image = UIImage(named: "list_icon")
                messageView.backgroundColor = listColor
                
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            print(messageImage.frame.origin.x)
            
            // If archive
            if messageImage.frame.origin.x > 40 && messageImage.frame.origin.x < 200 {
               
                //  Slide all the way to the right
                UIView.animateWithDuration(0.4, animations: {
                    self.messageImage.frame.origin.x = 320
                    }, completion: { (Bool) -> Void in
                        
                        // Hide the first message
                        self.hideFirstMessage()
                        
                        // Reset the first message after 1 second
                        delay(1){ self.resetMessage() }
                })
            
            }
            
            // If delete
            else if messageImage.frame.origin.x >= 200 {
                
                //  Slide all the way to the right
                UIView.animateWithDuration(0.4, animations: {
                    self.messageImage.frame.origin.x = 320
                    }, completion: { (Bool) -> Void in
                        
                        self.hideFirstMessage()
                        
                        delay(1){ self.resetMessage() }
                })
                
            }
            
            // If reschedule
            else if messageImage.frame.origin.x < -40 && messageImage.frame.origin.x > -200 {
                
                //  Slide all the way to the left
                UIView.animateWithDuration(0.4, animations: {
                    self.messageImage.frame.origin.x = -320
                    }, completion: { (Bool) -> Void in
                        
                        // Show the reschedule screen
                        UIView.animateWithDuration(0.2, animations: {
                            self.rescheduleView.alpha = 1
                        })
                })
                
            }
            
            // If list
            else if messageImage.frame.origin.x <= -200 {
                
                //  Slide all the way to the left
                UIView.animateWithDuration(0.4, animations: {
                    self.messageImage.frame.origin.x = -320
                    }, completion: { (Bool) -> Void in
                        
                        // Show the reschedule screen
                        UIView.animateWithDuration(0.2, animations: {
                            self.listView.alpha = 1
                        })
                })
                
            } else {
                
                // Snap back to origin
                UIView.animateWithDuration(0.2, animations: {
                    self.messageImage.frame.origin.x = 0
                })
            }
            
            
            
            
            
        }
    }
    
    @IBAction func didPressReschedule(sender: AnyObject) {
        // Hide the first message and view
        UIView.animateWithDuration(0.2, animations: {
            self.rescheduleView.alpha = 0
            self.hideFirstMessage()
        })
        
        // Reset the first message after 1 second
        delay(1){ self.resetMessage() }
    }
    
    @IBAction func didPressList(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            self.listView.alpha = 0
            self.hideFirstMessage()
        })
        
        delay(1){ self.resetMessage() }
    }
    
    func hideFirstMessage() {
        
        // Hide the first message
        UIView.animateWithDuration(0.2, animations: {
            self.feedView.frame.origin.y -= 86
        })
        
    }
    
    func resetMessage() {
        
        messageView.backgroundColor = messageBackgroundColor
        
        self.messageImage.frame.origin.x = 0
        
        UIView.animateWithDuration(0.2, animations: {
            self.feedView.frame.origin.y += 86
        })
    
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
