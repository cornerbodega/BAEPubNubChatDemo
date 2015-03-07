//
//  ViewController.swift
//  BAEPubNubDemo2
//
//  Created by Dr. Marv on 3/5/15.
//  Copyright (c) 2015 Dr. Marv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var bob = User(userID: "Bob12345")
    var sally = User(userID: "Sally12345")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToPubNub()
        bobChatToSally() // Simulate Bob chatting to Sally
        sallyChatToBob() // Simulate Sally chatting to Bob
    }

    func connectToPubNub(){
        //Set PubNub API keys
        let myPNConfig = PNConfiguration(publishKey: "pub-c-f30c2bc8-324f-485a-9280-195c6c1794fb", subscribeKey: "sub-c-aa7e0bc6-c3d3-11e4-ad09-02ee2ddab7fe", secretKey: "sec-c-ZDMzNDZkMDItN2U2Ni00ZDYzLWIxODMtN2M2ZGM4YzkxZGQw")
        
        //Set Singleton Configuration
        PubNub.setConfiguration(myPNConfig)
        PubNub.connect()

        //Determine whether connected to PubNub
        PNObservationCenter.defaultCenter().addClientConnectionStateObserver(self) { (origin: String!, connected: Bool!, error: PNError!) -> Void in
            if ((connected) != nil) {
                println("Connected")
             //   PubNub.subscribeOn([myChannel])
              //  PubNub.sendMessage("Test Message!", toChannel: myChannel, storeInHistory: true)
            } else if ((error) != nil) {
                println(error.localizedDescription)
            } else if (error == nil) {
                println("Slow Connection")
            }
        }
    }
    
    func chat(message : String, channel : PNChannel){
    //   PubNub.sendMessage(message: message as String, toChannel: channel, storeInHistory: true)
        PubNub.sendMessage(message, toChannel: channel, storeInHistory: true)
    }
    
    func bobChatToSally(){
        var channel : PNChannel = PNChannel.channelWithName(sally.userID, shouldObservePresence: true) as PNChannel
        var message = "Hi Sally! I'm outside come open the door"
        chat(message, channel: channel)
        saveChatHistoryToChannel(bob, user2: sally, message: message)
    }
    
    func sallyChatToBob() {
        var channel : PNChannel = PNChannel.channelWithName(bob.userID, shouldObservePresence: true) as PNChannel
        var message = "Oh my god who is this?"
        chat(message, channel: channel)
        saveChatHistoryToChannel(bob, user2: sally, message : message)
    }
    
    func saveChatHistoryToChannel(user1 : User, user2 : User, message : String){
        var channel : PNChannel = PNChannel.channelWithName(bob.userID+sally.userID, shouldObservePresence: true) as PNChannel
        chat(message, channel: channel)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

