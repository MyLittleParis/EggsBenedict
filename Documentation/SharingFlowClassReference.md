# SharingFlow Class Reference

### Creating the SharingFlow

  - `init(type:)`

  ##### Declaration

  ```swift
  init(type: SharingFlowType)
  ```

  ##### Parameters

  Parameter   | Description
  --------------|---------------
  _type_       | A type of `SharingFlowType`

### Presenting Menus

  - `presentOpenInMenuWithImage:inView:documentInteractionDelegate:completion:`

  Present the menu for sending image to Instagram app.

  ##### Declaration

  ```swift
  func presentOpenInMenuWithImage(_ image: UIImage!,
      inView view: UIView!,
      documentInteractionDelegate delegate: UIDocumentInteractionControllerDelegate?,
      completion: ((result: Result<Any>) -> Void)?)
  ```

  ##### Parameters

  Parameter   | Description
  --------------|---------------
  _image_       | The image for sending to Instagram app.
  _view_          | The view from which to display the menu.
  _delegate_    | The delegate you want to receive document interaction notifications. You may specify `nil` for this parameter.
  _completion_ | The block to execute after the presenting menu. You may specify `nil` for this parameter.

  ##### Discussion

  This method is invoked if the `hasInstagramApp` property is `true`. To avoid blocking the main thread, it is invoked asynchronously with Grand Central Dispatch (GCD). 

  First, write a temporary image file in `tmp/` directory. The image data is written to a backup file, and then—assuming no errors occur—the backup file is renamed to the name specified by path. The image file is named `jpmarthaeggsbenedict.ig` or `jpmarthaeggsbenedict.igo` according to the `SharingFlowType` enumeration. For more information, see [NSData Class Reference](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSData_Class/).

  Then, call the `presentOpenInMenuFromRect:inView:animated:` method of an instance of the `UIDocumentInteractionController` class in main thread.

  You can implement a delegate object to track user interactions with menu items displayed by the document interaction controller. For more information, see [UIDocumentInteractionControllerDelegate Protocol Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDocumentInteractionControllerDelegate_protocol/).

  The completion handler is called after the `presentOpenInMenuFromRect:inView:animated:` method is called of an instance of the `UIDocumentInteractionController` class.

  > __[UIDocumentInteractionController Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDocumentInteractionController_class/)__
  >
  > This method displays the options menu asynchronously. The document interaction controller dismisses the menu automatically when the user selects an appropriate option.

### Removing Temporary Image

  - `removeTemporaryImage:`

  Remove temporary image file in `tmp/` directory.

  ##### Declaration

  ```swift
  func removeTemporaryImage(completion: ((result: Result<Any>) -> Void)?)
  ```

  ##### Parameters

  Parameter   | Description
  --------------|---------------
  _completion_ | The block to execute after the removing temporary image finishes. You may specify `nil` for this parameter.

  ##### Discussion

  It is not usually necessary to use this method because this library overwrites an existing file.

### Accessing the Device Attributes

  - `hasInstagramApp`

  Returns a Boolean value indicating whether or not Instagram app is installed on the iOS device.

  ##### Declaration

  ```swift
  var hasInstagramApp: Bool { get }
  ```

  ##### Discussion

  If `true`, the iOS device has Instagram app; otherwise it does not.