<img src="http://i.imgur.com/gVyy5D1.png" height="85">
# AppExplorer

AppExplorer demos the use of some of Apple's private frameworks. The application is capable of retrieving all of the devices installed apps as well as their icons and can launch any of the applications.

<img src="http://i.imgur.com/H542zX3.png" width=500>

## Theory 
Each application on iOS is a type of `LSApplicationProxy`. This class contains a number of defining properties associated with each applicaton. `LSApplicationWorkspace` manages these application proxies, controlling the launch of the application, installation, and deletion.

By using these class headers (as well as the classes they inherit from) I was able to reverse-engineer some private calls and launch applications based on their bundle identifier. These bundle identifiers could, in turn, be found by the application workspace.

In order to recieve the applications' icon images I used the original `UIImage.h` class header from UIKit. I created an UIImage extention for the important private methods from the original UIImage header which I want to call. The one I was primarily interested in was `_applicationIconImageForBundleIdentifier:(id)arg1 format:(id)arg2;`.

## Implementation
I created two classes `SystemApplicationManager` and `SystemApplication` which aim to allow for easier use of interfacing with the underlying classes stated above. Adopting the principals of Swift, I wanted to make sure any data being passed was safely handled, since the private classes these are based on could change at any time.


## Do it yourself!
1. Link the framework `MobileCoreServices.framework`.
2. Copy the `Private Headers` folder to your project.
3. Copy the `SystemApplicationManager` and `SystemApplication` classes to your project.
4. Get Swifty with it!
```Swift
let installedApps = SystemApplicationManager.sharedManager.allInstalledApplications()
```
Thats about it. Now you can get a number of properties from each of the SystemApplication objects in the array.



