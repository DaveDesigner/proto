# Proto

Initial app prototype for iOS development.

## Overview
This is a SwiftUI-based iOS application prototype.

## Features
- [.toolbarTitleDisplayMode(.inlineLarge)](https://developer.apple.com/documentation/swiftui/view/toolbartitledisplaymode(_:))
- tabBar expand collapse in primary tabs
- subview (eg Post details) toolbar toggle with TabBar
- avatar triggers overflow menu
- options for admin settings menu (sheet on Community tab, menu on Notifications tab)
- trigger half sheets from overflow menus

## To do
### Deployment
- [x] validate best method for stakeholder review (app clip, test flight, app store release?)
- [ ] testflight release

### Toolbar
- [ ] avatar image without button border
- [ ] menu item avatar circled

### Video
- [ ] `In progress` segment control component add "Video" tab
- [ ] native inline video player
- [ ] autoplay on scroll
- [ ] tap to unmute
- [ ] tap to fullscreen
- [ ] drag to minimize PiP

### Admin mode
- [x] Admin settings sheet [Figma](https://www.figma.com/design/H6KATGFhQ5fAOsegREtzBg/Circle-4.0-Mobile?node-id=2040-53037&t=Kcwlyc56hddeSD0c-1)
- [ ] Co-pilot interface

### Search
[Figma spec](https://www.figma.com/design/NdwIk4iFCNFsrBOA1I2S2b/%F0%9F%93%90-Mobile-Build?node-id=26801-116894&t=GwwykqKG33UxJcNw-1)
- [ ] Activate search on tap 
- [ ] Expand virtual keyboard when search is active
- [ ] Render search input as a toolbar above the tab bar (toggle bar state)

### Posts toolbar actions
- [ ] Click through from Feed to post view
- [ ] Post toolbar toggles native tab bar with primary heart action
- [ ] Comment text input bottom toolbar
- [ ] Native menu for overflow and admin tasks (edit post, etc, [Figma spec](https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=12807-69973&t=wAl175S4870CppoP-1))

### iPad
- [x] validate native tab bar and toolbars play nicely
- [ ] Feed layout change for wide displays
- [ ] Support Split View and Stage Manager