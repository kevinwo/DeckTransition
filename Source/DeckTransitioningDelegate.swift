//
//  DeckTransitioningDelegate.swift
//  DeckTransition
//
//  Created by Harshil Shah on 15/10/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit

/// The DeckTransitioningDelegate class vends out the presentation and animation
/// controllers required to present a view controller with the Deck transition
/// style
///
/// The following snippet described the steps for presenting a given
/// `ModalViewController` with the `DeckTransitioningDelegate`
///
/// ```swift
/// let modal = ModalViewController()
/// let transitionDelegate = DeckTransitioningDelegate()
/// modal.transitioningDelegate = transitionDelegate
/// modal.modalPresentationStyle = .custom
/// present(modal, animated: true, completion: nil)
/// ```
open class DeckTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Variables
    
    public let isSwipeToDismissEnabled: Bool
    public let presentDuration: TimeInterval?
    public let presentAnimation: (() -> ())?
    public let presentCompletion: ((Bool) -> ())?
    public let dismissDuration: TimeInterval?
    public let dismissAnimation: (() -> ())?
    public let dismissCompletion: ((Bool) -> ())?
    
    /// Determines how far the modal view controller needs to be swiped before its dismissed.
    public var dismissThreshold: CGFloat = 240
    /// Extra vertical padding between the status bar and the content view
    public var extraVerticalInset: CGFloat = 0
    
    // MARK: - Initializers
    
    /// Returns a transitioning delegate to perform a Deck transition. All
    /// parameters are optional. Swipe-to-dimiss is enabled by default. Leaving
    /// the duration parameters empty gives you animations with the default
    /// durations (0.3s for both)
    ///
    /// - Parameters:
    ///   - isSwipeToDismissEnabled: Whether the modal view controller should
    ///     be dismissed with a swipe gesture from top to bottom
    ///	  - presentDuration: The duration for the presentation animation
    ///   - presentAnimation: An animation block that will be performed
    ///		alongside the card presentation animation
    ///   - presentCompletion: A block that will be run after the card has been
    ///		presented
    ///	  - dismissDuration: The duration for the dismissal animation
    ///   - dismissAnimation: An animation block that will be performed
    ///		alongside the card dismissal animation
    ///   - dismissCompletion: A block that will be run after the card has been
    ///		dismissed
    @objc public init(isSwipeToDismissEnabled: Bool = true,
                      dismissThreshold: NSNumber? = nil,
                      extraVerticalInset: NSNumber? = nil,
                      presentDuration: NSNumber? = nil,
                      presentAnimation: (() -> ())? = nil,
                      presentCompletion: ((Bool) -> ())? = nil,
                      dismissDuration: NSNumber? = nil,
                      dismissAnimation: (() -> ())? = nil,
                      dismissCompletion: ((Bool) -> ())? = nil) {
        self.isSwipeToDismissEnabled = isSwipeToDismissEnabled
        self.presentDuration = presentDuration?.doubleValue
        self.presentAnimation = presentAnimation
        self.presentCompletion = presentCompletion
        self.dismissDuration = dismissDuration?.doubleValue
        self.dismissAnimation = dismissAnimation
        self.dismissCompletion = dismissCompletion
        
        if let threshold = dismissThreshold {
            self.dismissThreshold = CGFloat(threshold.doubleValue)
        }
        if let verticalInset = extraVerticalInset {
            self.extraVerticalInset = CGFloat(verticalInset.doubleValue)
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    /// Returns an animation controller that animates the modal presentation
    ///
    /// This is internal infrastructure handled entirely by UIKit and shouldn't
    /// be called directly
    ///
    /// - Parameters:
    ///   - presented: The modal view controller to be presented onscreen
    ///   - presenting: The view controller that will be presenting the modal
    ///   - source: The view controller whose `present` method is called
    /// - Returns: An animation controller that animates the modal presentation
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DeckPresentingAnimationController(duration: presentDuration)
    }
    
    /// Returns an animation controller that animates the modal dismissal
    ///
    /// This is internal infrastructure handled entirely by UIKit and shouldn't
    /// be called directly
    ///
    /// - Parameter dismissed: The modal view controller which will be dismissed
    /// - Returns: An animation controller that animates the modal dismisall
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DeckDismissingAnimationController(duration: dismissDuration)
    }
    
    /// Returns a presentation controller that manages the modal presentation
    ///
    /// This is internal infrastructure handled entirely by UIKit and shouldn't
    /// be called directly
    ///
    /// - Parameters:
    ///   - presented: The modal view controller
    ///   - presenting: The view controller which presented the modal
    ///   - source: The view controller whose `present` method was called to
    ///     present the modal
    /// - Returns: A presentation controller that manages the modal presentation
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DeckPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            isSwipeToDismissGestureEnabled: isSwipeToDismissEnabled,
            dismissThreshold: dismissThreshold,
            extraVerticalInset: extraVerticalInset,
            presentAnimation: presentAnimation,
            presentCompletion: presentCompletion,
            dismissAnimation: dismissAnimation,
            dismissCompletion: dismissCompletion)
        presentationController.transitioningDelegate = self
        return presentationController
    }
    
}
