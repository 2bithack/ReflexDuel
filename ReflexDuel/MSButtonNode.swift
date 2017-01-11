//
//  MSButtonNode.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 20/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case active, selected, hidden
}

class MSButtonNode: SKSpriteNode {
    
    let active: SKTexture
    let selected: SKTexture
    let hidden: SKTexture
    
    var clicks: CGFloat = 0
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    /* Button state management */
    var state: MSButtonNodeState = .active {
        didSet {
            switch state {
            case .active:
                /* Enable touch */
                self.isUserInteractionEnabled = true
                
                /* Visible */
                self.alpha = 1
                break
            case .selected:
                /* Semi transparent */
                self.alpha = 0.7
                break
            case .hidden:
                /* Disable touch */
                self.isUserInteractionEnabled = false
                
                /* Hide */
                self.alpha = 0
                break
            }
        }
    }
    
    
    init(image: SKTexture, downImage: SKTexture) {
        super.init(texture: <#T##SKTexture?#>, color: <#T##UIColor#>, size: <#T##CGSize#>)
        
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        // custom code 
        
    }
    
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .active
    }
    
}