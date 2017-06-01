# AuthorizeMe

**AuthorizeMe** is a mobile library for iOS that designed to easy implementation of authorization with social networks. This repository holds the source code that contain a set of providers that implement the functionality needed to get credentials and information about user from various social services.

## Features

* **No dependency:** AuthorizeMe is a fully Swift framework without any dependency. Use the library without any additional Xcode project configurations after installation.
* **Authorization:** There are two ways to authorize user. Use `SystemProvider` for authorize user with iOS social accounts data. Use `WebProvider` for authorize user with `UIWebView` in case when is not possible to use first way.
* **Custom provider:** Implement own provider if AuthorizeMe does not following social network that needed. It is easy and free.

## Getting Started

### Installation

`CocoaPods` is a dependency manager for Cocoa projects. Install it with the following command:

```bash
$ gem install cocoapods
```

To integrate AuthorizeMe into Xcode project using CocoaPods, specify it in `Podfile`:

```ruby
platform :ios, '10.0'

target 'Target Name' do
use_frameworks!

pod 'AuthorizeMe'

end
```

Then, run the following command:

```bash
$ pod install
```

### First Look

Firstly, import `AuthorizeMe` framework into class in Xcode project.

````swift
import AuthorizeMe
````

Then, turn logging on for seen error messages of authorization process if needed. Do it in `AppDelegate` class is the best way.

````swift
DebugService.isNeedOutput = true
````

Finally, use `Authorize` manager that authorize user with `SystemProvider` if it possible, but in other case manager authorize user with `WebProvider`.

````swift
Authorize.me.on("Name of social network") { session, error in
// Do something
}
````

To separate usage of various providers, use `SystemProvider` and `WebProvider` apart.

````swift
let provider = FacebookSystemProvider() 
// or 
// let provider = TwitterWebProvider()

provider.authorize { session, error in
// Do something
}
````

## Guides

* **[Facebook Provider](https://github.com/radislavcrechet/AuthorizeMe/wiki/Facebook-Provider)**
* **[Twitter Provider](https://github.com/radislavcrechet/AuthorizeMe/wiki/Twitter-Provider)**
* **[Custom Provider](https://github.com/radislavcrechet/AuthorizeMe/wiki/Custom-Provider)**
