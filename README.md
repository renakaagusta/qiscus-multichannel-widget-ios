# ios-multichannel-widget

## Requirements

- iOS 10.0+
- minimum Xcode 11.4
- Swift 5

## Dependency

* Alamofire
* AlamofireImage
* SwiftyJSON
* QiscusCoreAPI
* SDWebImage

## How to run the Example

### Step 1 : Get Your APP ID

Firstly, you need to register to Qiscus Multichannel, by accessing this link [dashboard](https://multichannel.qiscus.com). The APP ID can be retrieved from setting section.
![Qiscus Widget Integration](/Readme/multichannel_setting.png)

### Step 2 : Activate Qiscus Widget Integration

In your Qiscus Multichannel, activate Qiscus Widget Integration.
![Qiscus Widget Integration](/Readme/multichannel_integration.png)

### Step 3 : Run pod install

After cloned the example, you will need to run
```
pod install
```
This will install all cocoapods dependencies needed by the Example

### Step 4 : Set Your APP ID in Example
Set the example Qiscus Multichannel APP ID you got from step 1. Open Example/ChatManager.swift, replace the appId at line 21 with your APP ID.
```swift
lazy  var  widget: MultichannelWidget = {
    return  MultichannelWidget(appID: "YOUR_APP_ID_FROM_STEP_1")
}()
```

### Step 5: Start Chatting
The Example is ready to use. You can start chatting with your customer service.
![Ready to Chat Image](/Readme/ready_to_chat.png)

### Step 5: Setup Push Notification

The Qiscus Chat SDK receives pushes through both the Qiscus Chat SDK protocol and Apple Push Notification Service (APNS), depending on usage and other conditions. Default notification sent by Qiscus Chat SDK protocol. In order to enable your application to receive apple push notifications, some setup must be performed in both application and the Qiscus Dashboard.

Do the following steps to setup push notifications:

1. Create a Certificate Signing Request(CSR).
2. Create a Push Notification SSL certificate in Apple Developer site.
3. Export a p12 file and upload it to Qiscus Dashboard.
4. Register a device token in Qiscus SDK and parse Qiscus APNS messages.

#### Step Push Notification 1:  Create A Certificate Signing Request(CSR)

Open **Keychain Access** on your Mac (Applications -> Utilities -> Keychain Access). Select **Request a Certificate From a Certificate Authority**.
<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns1.png" width="100%" /><br/></p>

In the **Certificate Information** window, do the following:

* In the **User Email Address** field, enter your email address.
* In the **Common Name** field, create a name for your private key (for example, John Doe Dev Key).
* The **CA Email Address** field must be left empty.
* In the **Request is** group, select the **Saved to disk** option.

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns2.png" width="100%" /><br/></p>

#### Step Push Notification 2: Create A Push Notification SSL Certificate In Apple Developer Site.

Log in to the [Apple Developer Member Center](https://developer.apple.com/) and find the **Certificates, Identifiers & Profiles** menu. Select **App IDs**, find your target application, and click the **Edit** button.
<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns3.png" width="100%" /><br/></p>

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns4.png" width="100%" /><br/></p>

Turn on **Push Notifications** and create a development or production certificate to fit your purpose. 
<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns5.png" width="100%" /><br/></p>
Upload the **CSR file** that you created in section (1) to complete this process. After doing so, download a **SSL certificate**.
Double-click the file and register it to your **login keychain.**


#### Step Push Notification 3: Export A p12 File and Upload It To Qiscus Dashboard

Under the Keychain Access, click the Certificates category from the left menu. Find the Push SSL certificate you just registered and right-click it without expanding the certificate. Then select Export to save the file to your disk.

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns6.png" width="100%" /><br/></p>

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns7.png" width="100%" /><br/></p>

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns8.png" width="100%" /><br/></p>

Then, log in to the [dashboard](https://www.qiscus.com/dashboard/login) and upload your `.p12` file to the Push Notification section, under Settings.

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns9.png" width="100%" /><br/></p>

klik add and fill the form upload certificates

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns10.png" width="100%" /><br/></p>


> **Note:  
**Example of this certificate for production, you need create cert Push Notification for development, and Export A p12 File and Upload It To Qiscus Dashboard if you run from Xcode

#### Step Push Notification 4: Register A Device Token In Qiscus SDK And Parse Qiscus APNS Messages.   

In your app's AppDelegate, store your device token as a variable.

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
```

```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var tokenString: String = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("token = \(tokenString)")
        QiscusCore.shared.register(deviceToken: tokenString, onSuccess: { (response) in
            //
        }) { (error) in
            //
        }
    }
    

func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
       print("AppDelegate. didReceive: \(notification)")
}
    
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("AppDelegate. didReceiveRemoteNotification: \(userInfo)")
}
    
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("AppDelegate. didReceiveRemoteNotification2: \(userInfo)")
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
```

Don't forget set **Remote notifications and Background fetch** in menu **Capabilities**

<p align="center"><br/><img src="https://d3p8ijl4igpb16.cloudfront.net/docs/assets/apns11.png" width="100%" /><br/></p>

#### Step Push Notification 6: Test PN from third party

for example using tool Easy APNs Provider :

<p align="center"><br/><img src="https://d1edrlpyc25xu0.cloudfront.net/kiwari-prod/image/upload/MZukRQrLqf/Screen+Shot+2019-03-20+at+11.02.14.png" width="100%"/><br/></p>

> **Note:  
**Follow step 1 - 6 tools to test push notification.
**We test using cert Apple Development IOS Push Service


## Contribution
ios-multichannel-widget is fully open-source. All contributions and suggestions are welcome!

### Color Customization
You can customize widget components color.
![Color Customization Image](/Readme/color_config_example.png)
