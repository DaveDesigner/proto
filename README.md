## Next steps
- fix: truncation rule for post preview should be two line descriptions and that style should be secondary not
- fix: accent color light/dark mode defined to switch like primary on nav in dark mode
- add: connect actions on profile, accessed via notification
1. **Image lightbox** - Tap on images to open full-screen lightbox view
2. **Video inline player** - Native video player with autoplay on scroll position
3. **iPad multi-column layouts** - Support for wide displays with responsive grid layouts
4. **Enhanced video controls** - Tap to unmute, tap to fullscreen, drag to minimize PiP
5. **Search functionality** - Activate search on tap with virtual keyboard expansion
6. **Admin mode completion** - Finish Co-pilot sparkle UI edges and Figma consistency


## Features
- [.toolbarTitleDisplayMode(.inlineLarge)](https://developer.apple.com/documentation/swiftui/view/toolbartitledisplaymode(_:))
- tabBar expand collapse in primary tabs
- subview (eg Post details) toolbar toggle with TabBar
- avatar triggers overflow menu
- options for admin settings menu (sheet on Community tab, menu on Notifications tab)
- trigger half sheets from overflow menus
- initial post-preview components for dynamic feed with UnsplashService integration [PR #7](https://github.com/DaveDesigner/proto/pull/7)

## To do
### Deployment
TestFlight via email invite Apple ID. Won’t do: public URL, as proto won't pass review.
- [x] validate best method for stakeholder review (app clip, test flight, app store release?)
- [x] testflight internal release
- [x] Apple review for TestFlight external URL

### Toolbar
- [x] avatar image without button border [PR #6](https://github.com/DaveDesigner/proto/pull/6)
- [x] menu item avatar circled

### Video
- [x] segment control component add "Video" tab [PR #4](https://github.com/DaveDesigner/proto/pull/4)
- [ ] native inline video player
- [ ] autoplay on scroll
- [ ] tap to unmute
- [ ] tap to fullscreen
- [ ] drag to minimize PiP

### Admin mode
- [x] Admin settings sheet [Figma](https://www.figma.com/design/H6KATGFhQ5fAOsegREtzBg/Circle-4.0-Mobile?node-id=2040-53037&t=Kcwlyc56hddeSD0c-1)
- [ ] `In progress` Co-pilot sparkle UI edges [PR #2](https://github.com/DaveDesigner/proto/pull/2)
- [ ] Figma consistency across settings destinations
- [x] Drafts sheet [PR #3](https://github.com/DaveDesigner/proto/pull/3)

### Search
- [ ] Activate search on tap [Figma spec](https://www.figma.com/design/NdwIk4iFCNFsrBOA1I2S2b/%F0%9F%93%90-Mobile-Build?node-id=26801-116894&t=GwwykqKG33UxJcNw-1)
- [ ] Expand virtual keyboard when search is active
- [ ] Render search input as a toolbar above the tab bar (toggle bar state)

### Posts toolbar actions
- [x] Click through from Feed to post view
- [x] Post toolbar toggles native tab bar with primary heart action
- [x] Comment text input bottom toolbar
- [x] Native menu for overflow and admin tasks (edit post, etc, [Figma spec](https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=12807-69973&t=wAl175S4870CppoP-1))

### iPad
- [x] validate native tab bar and toolbars play nicely
- [ ] Feed layout change for wide displays
- [ ] Support Split View and Stage Manager