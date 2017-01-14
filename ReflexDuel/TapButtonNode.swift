

import SpriteKit

enum TapButtonNodeState {
    case Active, Tapped, Lit, Hidden
}

class TapButtonNode: SKSpriteNode {
    
    var active: SKTexture!
    var tapped: SKTexture!
    var lit: SKTexture!
    var hidden1: SKTexture!
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    func setButtonState(){
        switch state {
        case .Active:
            texture = active
            /* Enable touch */
            self.isUserInteractionEnabled = true
            
            /* practically inVisible */
            self.alpha = 0.0000001
            break
        case .Tapped:
            texture = tapped
            /* inVisible */
            self.alpha = 0
            break
        case .Lit:
            texture = lit
            /* Disable touch */

            self.alpha = 1
            break
        case .Hidden:
            texture = hidden1
            /* Disable touch */
            self.isUserInteractionEnabled = false
            /* Hide */
            self.alpha = 0
            break
        }
    }
    
    /* Button state management */
    var state: TapButtonNodeState = .Active {
        didSet {
            setButtonState()
        }
    }
    
    init(activeImageNamed: String, tappedImageNamed: String, hiddenImageNamed: String, litImageNamed: String) {
        active = SKTexture(imageNamed: activeImageNamed)
        tapped = SKTexture(imageNamed: tappedImageNamed)
        hidden1 = SKTexture(imageNamed: hiddenImageNamed)
        lit = SKTexture(imageNamed: litImageNamed)
        super.init(texture: active, color: UIColor.clear, size: active.size())
        
        isUserInteractionEnabled = false
        
        state = .Hidden
        setButtonState()
    }
    
    
//    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//        
//        // custom code 
//        
//    }
    
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .Tapped
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .Active
    }
    
}
