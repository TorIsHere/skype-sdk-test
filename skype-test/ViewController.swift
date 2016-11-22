//
//  ViewController.swift
//  skype-test
//
//  Created by Kittikorn Ariyasuk on 2016/11/20.
//  Copyright © 2016 torishere. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation

class ViewController: UIViewController, SfBConversationHelperDelegate {
    
    var conversationHelper:SfBConversationHelper? = nil
        
    @IBOutlet weak var participantVideoView: GLKView!
    @IBOutlet weak var selfVideoView: UIView!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    
    @IBAction func endCall(_ sender: Any) {
        do{
            try self.conversationHelper?.conversation.leave()
            self.conversationHelper?.conversation.removeObserver(self, forKeyPath: "canLeave")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func toggleMuted(_ sender: Any) {
        do{
            try self.conversationHelper?.toggleAudioMuted()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.joinMeeting()
    }
    
    func joinMeeting() {
        let sfb: SfBApplication = SfBApplication.shared()!
        
        do {
            
            let meetingURLString:String = "https://meet.lync.com/focalintelligence/supanut/ND62KIV9"
            let urlText:String = meetingURLString.addingPercentEncoding(
                withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let url = URL(string:urlText)
            let conversation: SfBConversation  = try sfb.joinMeetingAnonymous(
                withUri: url!, displayName: "Skype User 1").conversation
            
            self.conversationHelper = SfBConversationHelper(
                conversation: conversation,
                delegate: self,
                devicesManager: sfb.devicesManager,
                outgoingVideoView: self.selfVideoView,
                incomingVideoLayer: self.participantVideoView.layer as! CAEAGLLayer,
                userInfo: ["displayName":"Skype User 1"])
            
            conversation.addObserver(self, forKeyPath: "canLeave", options: .initial, context: nil)
        }
        catch {
            print(error.localizedDescription)
            self.endCallButton.isEnabled = true
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "canLeave") {
            self.endCallButton.isEnabled = (self.conversationHelper?.conversation.canLeave)!
        }
    }
    
    // Ready to start delegate.
    func conversationHelper(_ conversationHelper: SfBConversationHelper, videoService: SfBVideoService,
                            didChangeCanStart canStart: Bool) {
        if (canStart) {
            if (self.selfVideoView.isHidden) {
                self.selfVideoView.isHidden = false
            }
            do {
                try videoService.start()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //Subscribed or unsubcribed to incoming video
    func conversationHelper(_ conversationHelper: SfBConversationHelper,
                            didSubscribeTo video: SfBParticipantVideo?) {
        self.participantVideoView.isHidden = false
    }
    
    // When the audio status changes delegate
    func conversationHelper(_ conversationHelper: SfBConversationHelper,
                            selfAudio audio: SfBParticipantAudio, didChangeIsMuted isMuted: Bool) {
        // To force microphone on at the begining
        if isMuted {
            do {
                try self.conversationHelper?.toggleAudioMuted()
            } catch {
                print(error.localizedDescription)
            }
        }
        if isMuted {
            self.muteButton.setTitle("Unmute", for: .normal)
        }
        else {
            self.muteButton.setTitle("Mute", for: .normal)
        }
    }

}

