//
//  CoordinatorModePresentConfiguration.swift
//  GithubJobs
//
//  Created by Alonso on 20/02/25.
//

import UIKit

/**
 * Configuration structure for modal presentations in coordinators.
 *
 * This structure provides a way to customize modal presentations
 * with specific presentation styles and transition animations.
 */
public struct CoordinatorModePresentConfiguration {

    /// The style for modal presentation (fullscreen, formSheet, popover, etc.).
    public let modalPresentationStyle: UIModalPresentationStyle

    /// Optional delegate for custom transition animations.
    public let transitioningDelegate: UIViewControllerTransitioningDelegate?

    public init(modalPresentationStyle: UIModalPresentationStyle,
                transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
        self.modalPresentationStyle = modalPresentationStyle
        self.transitioningDelegate = transitioningDelegate
    }

}
