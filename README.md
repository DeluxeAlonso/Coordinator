# Coordinator

A lightweight, flexible coordinator pattern implementation for iOS applications.

## Overview

The Coordinator pattern helps separate navigation logic from view controllers, creating a cleaner architecture where view controllers focus solely on view-related concerns. This package provides a robust implementation of the Coordinator pattern for iOS applications using UIKit.

## Features

- **Hierarchical Coordinator Structure**: Support for parent-child coordinator relationships
- **Multiple Presentation Modes**: Push, modal presentation, and embedding child view controllers
- **Automatic Cleanup**: Optional automatic removal of coordinators when they're no longer needed
- **Navigation Delegate Support**: Built-in UINavigationControllerDelegate for tracking navigation events
- **Split View Support**: Optional secondary navigation controller for detail views

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/DeluxeAlonso/Coordinator.git", from: "1.0.0")
]
```

## Basic Usage

### 1. Create a concrete coordinator

```swift
class HomeCoordinator: BaseCoordinator {
    
    override func start() {
        // Start with default push mode
        start(coordinatorMode: .push)
    }
    
    override func build() -> UIViewController {
        let viewController = HomeViewController()
        viewController.coordinator = self
        return viewController
    }
    
    func showDetail(for item: Item) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController)
        detailCoordinator.item = item
        detailCoordinator.parentCoordinator = self
        
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}
```

### 2. Start a coordinator flow

```swift
// In AppDelegate or SceneDelegate
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    
    let navigationController = UINavigationController()
    let coordinator = AppCoordinator(navigationController: navigationController)
    
    coordinator.start()
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
}
```

## Presentation Modes

### Push Navigation

```swift
func start() {
    start(coordinatorMode: .push)
}
```

### Modal Presentation

```swift
func showSettings() {
    let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())
    settingsCoordinator.parentCoordinator = self
    
    childCoordinators.append(settingsCoordinator)
    
    let configuration = CoordinatorModePresentConfiguration(
        modalPresentationStyle: .formSheet,
        transitioningDelegate: nil
    )
    
    settingsCoordinator.start(coordinatorMode: .present(
        presentingViewController: navigationController.viewControllers.last!,
        configuration: configuration
    ))
}
```

### Embedded Child View Controller

```swift
func showEmbeddedContent(in containerView: UIView) {
    let contentCoordinator = ContentCoordinator(navigationController: navigationController)
    contentCoordinator.parentCoordinator = self
    
    childCoordinators.append(contentCoordinator)
    
    contentCoordinator.start(coordinatorMode: .embed(
        parentViewController: navigationController.viewControllers.last!,
        containerView: containerView
    ))
}
```

## Root Coordinators

For apps with multiple main flows (like tab bar interfaces), implement the RootCoordinator protocol:

```swift
class ProfileTabCoordinator: BaseCoordinator, RootCoordinator {
    
    var rootIdentifier: String {
        return "profile"
    }
    
    override func start() {
        // Implementation for the profile tab flow
    }
    
    override func build() -> UIViewController {
        return ProfileViewController()
    }
}
```

## Split View Controller Support

```swift
// Initialize coordinator with detail navigation controller
let masterNavController = UINavigationController()
let detailNavController = UINavigationController()
let coordinator = MasterCoordinator(navigationController: masterNavController)
coordinator.detailNavigationController = detailNavController

// Set up split view controller
let splitViewController = UISplitViewController()
splitViewController.viewControllers = [masterNavController, detailNavController]
```

## Automatic Coordinator Cleanup

The BaseCoordinator implementation automatically handles cleanup in several ways:

1. When a view controller is popped from the navigation stack, its coordinator is removed
2. When a modally presented coordinator is dismissed, it's removed from its parent
3. Child coordinators marked with `shouldBeAutomaticallyFinished = true` are removed first during cleanup

## Best Practices

1. **Keep View Controllers Focused**: They should only manage their views and user interactions
2. **Coordinators Handle Navigation**: All navigation logic should be in coordinators
3. **Maintain Hierarchy**: Always set parent-child relationships correctly
4. **Clean Up**: Call `childDidFinish()` when flows complete
5. **Use Dependency Injection**: Pass data to coordinators, not directly to view controllers

## Requirements

- iOS 15.0+
- Swift 5.0+

## License

This package is available under the MIT license. See the LICENSE file for more info.
