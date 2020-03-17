//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 5 files.
  struct file {
    /// Resource file `Books.bundle`.
    static let booksBundle = Rswift.FileResource(bundle: R.hostingBundle, name: "Books", pathExtension: "bundle")
    /// Resource file `editor.css`.
    static let editorCss = Rswift.FileResource(bundle: R.hostingBundle, name: "editor", pathExtension: "css")
    /// Resource file `editor.js`.
    static let editorJs = Rswift.FileResource(bundle: R.hostingBundle, name: "editor", pathExtension: "js")
    /// Resource file `index.html`.
    static let indexHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "index", pathExtension: "html")
    /// Resource file `squire-raw.js`.
    static let squireRawJs = Rswift.FileResource(bundle: R.hostingBundle, name: "squire-raw", pathExtension: "js")
    
    /// `bundle.url(forResource: "Books", withExtension: "bundle")`
    static func booksBundle(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.booksBundle
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "editor", withExtension: "css")`
    static func editorCss(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.editorCss
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "editor", withExtension: "js")`
    static func editorJs(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.editorJs
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "index", withExtension: "html")`
    static func indexHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.indexHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "squire-raw", withExtension: "js")`
    static func squireRawJs(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.squireRawJs
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 33 images.
  struct image {
    /// Image `icon_editor_align_center`.
    static let icon_editor_align_center = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_align_center")
    /// Image `icon_editor_align_left`.
    static let icon_editor_align_left = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_align_left")
    /// Image `icon_editor_align_right`.
    static let icon_editor_align_right = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_align_right")
    /// Image `icon_editor_back`.
    static let icon_editor_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_back")
    /// Image `icon_editor_bold`.
    static let icon_editor_bold = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_bold")
    /// Image `icon_editor_font`.
    static let icon_editor_font = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_font")
    /// Image `icon_editor_fontcolor`.
    static let icon_editor_fontcolor = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_fontcolor")
    /// Image `icon_editor_fontsize`.
    static let icon_editor_fontsize = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_fontsize")
    /// Image `icon_editor_image`.
    static let icon_editor_image = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_image")
    /// Image `icon_editor_italic`.
    static let icon_editor_italic = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_italic")
    /// Image `icon_editor_keyboard`.
    static let icon_editor_keyboard = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_keyboard")
    /// Image `icon_editor_location_selected`.
    static let icon_editor_location_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_location_selected")
    /// Image `icon_editor_location`.
    static let icon_editor_location = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_location")
    /// Image `icon_editor_love_selected`.
    static let icon_editor_love_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_love_selected")
    /// Image `icon_editor_love`.
    static let icon_editor_love = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_love")
    /// Image `icon_editor_mood`.
    static let icon_editor_mood = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_mood")
    /// Image `icon_editor_redo`.
    static let icon_editor_redo = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_redo")
    /// Image `icon_editor_underline`.
    static let icon_editor_underline = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_underline")
    /// Image `icon_editor_undo`.
    static let icon_editor_undo = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_undo")
    /// Image `icon_editor_weather`.
    static let icon_editor_weather = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_editor_weather")
    /// Image `icon_me_premium`.
    static let icon_me_premium = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_me_premium")
    /// Image `icon_tabbar_category`.
    static let icon_tabbar_category = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_tabbar_category")
    /// Image `icon_tabbar_edit`.
    static let icon_tabbar_edit = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_tabbar_edit")
    /// Image `icon_tabbar_user`.
    static let icon_tabbar_user = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_tabbar_user")
    /// Image `icon_today_back`.
    static let icon_today_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_today_back")
    /// Image `image_editor_bg`.
    static let image_editor_bg = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_editor_bg")
    /// Image `image_home_bg_sun`.
    static let image_home_bg_sun = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_home_bg_sun")
    /// Image `image_home_cr1`.
    static let image_home_cr1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_home_cr1")
    /// Image `image_home_cr2`.
    static let image_home_cr2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_home_cr2")
    /// Image `image_home_cr3`.
    static let image_home_cr3 = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_home_cr3")
    /// Image `image_me_bg`.
    static let image_me_bg = Rswift.ImageResource(bundle: R.hostingBundle, name: "image_me_bg")
    /// Image `test1`.
    static let test1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "test1")
    /// Image `test`.
    static let test = Rswift.ImageResource(bundle: R.hostingBundle, name: "test")
    
    /// `UIImage(named: "icon_editor_align_center", bundle: ..., traitCollection: ...)`
    static func icon_editor_align_center(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_align_center, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_align_left", bundle: ..., traitCollection: ...)`
    static func icon_editor_align_left(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_align_left, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_align_right", bundle: ..., traitCollection: ...)`
    static func icon_editor_align_right(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_align_right, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_back", bundle: ..., traitCollection: ...)`
    static func icon_editor_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_back, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_bold", bundle: ..., traitCollection: ...)`
    static func icon_editor_bold(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_bold, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_font", bundle: ..., traitCollection: ...)`
    static func icon_editor_font(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_font, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_fontcolor", bundle: ..., traitCollection: ...)`
    static func icon_editor_fontcolor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_fontcolor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_fontsize", bundle: ..., traitCollection: ...)`
    static func icon_editor_fontsize(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_fontsize, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_image", bundle: ..., traitCollection: ...)`
    static func icon_editor_image(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_image, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_italic", bundle: ..., traitCollection: ...)`
    static func icon_editor_italic(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_italic, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_keyboard", bundle: ..., traitCollection: ...)`
    static func icon_editor_keyboard(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_keyboard, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_location", bundle: ..., traitCollection: ...)`
    static func icon_editor_location(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_location, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_location_selected", bundle: ..., traitCollection: ...)`
    static func icon_editor_location_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_location_selected, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_love", bundle: ..., traitCollection: ...)`
    static func icon_editor_love(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_love, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_love_selected", bundle: ..., traitCollection: ...)`
    static func icon_editor_love_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_love_selected, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_mood", bundle: ..., traitCollection: ...)`
    static func icon_editor_mood(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_mood, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_redo", bundle: ..., traitCollection: ...)`
    static func icon_editor_redo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_redo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_underline", bundle: ..., traitCollection: ...)`
    static func icon_editor_underline(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_underline, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_undo", bundle: ..., traitCollection: ...)`
    static func icon_editor_undo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_undo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_editor_weather", bundle: ..., traitCollection: ...)`
    static func icon_editor_weather(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_editor_weather, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_me_premium", bundle: ..., traitCollection: ...)`
    static func icon_me_premium(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_me_premium, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_tabbar_category", bundle: ..., traitCollection: ...)`
    static func icon_tabbar_category(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_tabbar_category, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_tabbar_edit", bundle: ..., traitCollection: ...)`
    static func icon_tabbar_edit(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_tabbar_edit, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_tabbar_user", bundle: ..., traitCollection: ...)`
    static func icon_tabbar_user(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_tabbar_user, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_today_back", bundle: ..., traitCollection: ...)`
    static func icon_today_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_today_back, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_editor_bg", bundle: ..., traitCollection: ...)`
    static func image_editor_bg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_editor_bg, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_home_bg_sun", bundle: ..., traitCollection: ...)`
    static func image_home_bg_sun(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_home_bg_sun, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_home_cr1", bundle: ..., traitCollection: ...)`
    static func image_home_cr1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_home_cr1, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_home_cr2", bundle: ..., traitCollection: ...)`
    static func image_home_cr2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_home_cr2, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_home_cr3", bundle: ..., traitCollection: ...)`
    static func image_home_cr3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_home_cr3, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image_me_bg", bundle: ..., traitCollection: ...)`
    static func image_me_bg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.image_me_bg, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "test", bundle: ..., traitCollection: ...)`
    static func test(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.test, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "test1", bundle: ..., traitCollection: ...)`
    static func test1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.test1, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `bottomMenu`.
    static let bottomMenu = _R.nib._bottomMenu()
    /// Nib `topMenu`.
    static let topMenu = _R.nib._topMenu()
    
    /// `UINib(name: "bottomMenu", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.bottomMenu) instead")
    static func bottomMenu(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.bottomMenu)
    }
    
    /// `UINib(name: "topMenu", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.topMenu) instead")
    static func topMenu(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.topMenu)
    }
    
    static func bottomMenu(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.bottomMenu.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func topMenu(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.topMenu.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _bottomMenu.validate()
      try _topMenu.validate()
    }
    
    struct _bottomMenu: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "bottomMenu"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "A+", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'A+' is used in nib 'bottomMenu', but couldn't be loaded.") }
        if UIKit.UIImage(named: "A-", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'A-' is used in nib 'bottomMenu', but couldn't be loaded.") }
        if UIKit.UIImage(named: "bookDir", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bookDir' is used in nib 'bottomMenu', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct _topMenu: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "topMenu"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "bookMark", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bookMark' is used in nib 'topMenu', but couldn't be loaded.") }
        if UIKit.UIImage(named: "mback", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'mback' is used in nib 'topMenu', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
