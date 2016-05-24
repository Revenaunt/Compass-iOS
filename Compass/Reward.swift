//
//  Reward.swift
//  Compass
//
//  Created by Ismael Alonso on 5/24/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Reward: TDCBase{
    private let TYPE_QUOTE = "quote";
    private let TYPE_FORTUNE = "fortune";
    private let TYPE_FACT = "fact";
    private let TYPE_JOKE = "joke";
    
    private var messageType: String = "";
    private var message: String = "";
    private var author: String = "";
    
    
    func isQuote() -> Bool{
        return messageType == TYPE_QUOTE;
    }
    
    func isFortune() -> Bool{
        return messageType == TYPE_FORTUNE;
    }
    
    func isFact() -> Bool{
        return messageType == TYPE_FACT;
    }
    
    func isJoke() -> Bool{
        return messageType == TYPE_JOKE;
    }
    
    func getMessage() -> String{
        return messageType;
    }
    
    func getAuthor() -> String{
        return author;
    }
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        messageType <- map["message_type"];
        message <- map["message"];
        author <- map["author"];
    }
}
