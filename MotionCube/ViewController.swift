//
//  ViewController.swift
//  MotionCube
//
//  Created by Liudmyla POHRIBNIAK on 3/22/19.
//  Copyright © 2019 Liudmyla POHRIBNIAK. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var dynamicAnimator = UIDynamicAnimator()
    var gravityBehaviour = UIGravityBehavior()
    var collisionBehaviour = UICollisionBehavior()
    var itemBehaviour = UIDynamicItemBehavior()
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        dynamicAnimator.addBehavior(gravityBehaviour)
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehaviour)
        dynamicAnimator.addBehavior(itemBehaviour)
        itemBehaviour.elasticity = 0.85
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            let queue = OperationQueue.main
            motionManager.startAccelerometerUpdates(to: queue, withHandler: accHandler)
        }
    }
    
    func accHandler(data: CMAccelerometerData?, error: Error?) {
        if let myData = data {
            let x = CGFloat(myData.acceleration.x);
            let y = CGFloat(myData.acceleration.y);
            let v = CGVector(dx: x, dy: -y);
            gravityBehaviour.gravityDirection = v;
        }
    }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
       let newView = Shape(localpoint: point, maxwidth: self.view.bounds.width, maxheight: self.view.bounds.height)
        view.addSubview(newView)
        gravityBehaviour.addItem(newView)
        collisionBehaviour.addItem(newView)
        itemBehaviour.addItem(newView)
        
        let pGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture: )))
        newView.addGestureRecognizer(pGesture)
        
        let piGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture: )))
        newView.addGestureRecognizer(piGesture)
        
        let rotGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(gesture: )))
        newView.addGestureRecognizer(rotGesture)
    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
        if let gest = gesture.view {
        switch gesture.state {
        case .began:
            gravityBehaviour.removeItem(gest)
            collisionBehaviour.removeItem(gest)
            itemBehaviour.removeItem(gest)
        case .ended:
            itemBehaviour.addItem(gest)
            collisionBehaviour.addItem(gest)
            gravityBehaviour.addItem(gest)
        case .changed:
            gesture.view?.layer.bounds.size.height *= gesture.scale
            gesture.view?.layer.bounds.size.width *= gesture.scale
            if let tmp = gesture.view! as? Shape {
                if (tmp.circle) {gesture.view!.layer.cornerRadius *= gesture.scale}}
            gesture.scale = 1
        case .failed, .cancelled:
            print("failed1")
        case.possible:
            print("possible1")
        }
    }
    }
    
    @objc func rotationGesture(gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("rotationGesture began")
//            collisionBehaviour.removeItem(gesture.view!)
            gravityBehaviour.removeItem(gesture.view!)
        case .ended:
             print("rotationGesture ended")
            gravityBehaviour.addItem(gesture.view!)
//            collisionBehaviour.addItem(gesture.view!)
        case .changed:
             print("rotationGesture changed")

            gesture.view?.transform = (gesture.view?.transform.rotated(by: gesture.rotation))!

            dynamicAnimator.updateItem(usingCurrentState: gesture.view!)
            gesture.rotation = 0
        case .failed, .cancelled:
            print("failed2")
            break
        case.possible:
            print("possible2")
            break
        }
    }
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("panGesture began")
            gravityBehaviour.removeItem(gesture.view!)
        case .ended:
            print("panGesture ended")
            gravityBehaviour.addItem(gesture.view!)
        case .changed:
            print("panGesture changed")
            gesture.view?.center = gesture.location(in: gesture.view?.superview)
            dynamicAnimator.updateItem(usingCurrentState: gesture.view!)
        case .failed, .cancelled:
            print("panGesture failed")
            break
        case.possible:
            print("panGesture possible")
            break
        }
    }
}


