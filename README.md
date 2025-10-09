## Next steps
- feat: admin mode shift, navigation paradigm
- feat: member profile
- feat: add connection status actions to profile
- `In progress` style(icons): replace sf symbols with icons in primary nav, & post preview [PR #9](https://github.com/DaveDesigner/proto/pull/9)
- add: connect actions on profile, accessed via notification
- **iPad multi-column layouts** - Support for wide displays with responsive grid layouts
- **Enhanced video controls** - Tap to unmute, tap to fullscreen, drag to minimize PiP
- **Admin mode** - Finish Co-pilot sparkle UI edges and Figma consistency


## Features
- Invite members (interim until admin settings) [PR #17](https://github.com/DaveDesigner/proto/pull/17)
- Autoplaying video preview on scroll in Feed [Draft PR](https://github.com/DaveDesigner/proto/pull/new/feature/video-demo-player)
- Edit post settings [PR #16](https://github.com/DaveDesigner/proto/pull/16)
- Image lightbox to open and swipe down to close [PR #11](https://github.com/DaveDesigner/proto/pull/11), [PR #12](https://github.com/DaveDesigner/proto/pull/12), [PR #14](https://github.com/DaveDesigner/proto/pull/14), [PR #15](https://github.com/DaveDesigner/proto/pull/15)
- [.toolbarTitleDisplayMode(.inlineLarge)](https://developer.apple.com/documentation/swiftui/view/toolbartitledisplaymode(_:))
- tabBar expand collapse in primary tabs
- subview (eg Post details) toolbar toggle with TabBar
- avatar triggers overflow menu
- options for admin settings menu (sheet on Community tab, menu on Notifications tab)
- trigger half sheets from overflow menus
- initial post-preview components for dynamic feed with UnsplashService integration [PR #7](https://github.com/DaveDesigner/proto/pull/7)

## To do

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
- [x] Activate search on tap [Figma spec](https://www.figma.com/design/NdwIk4iFCNFsrBOA1I2S2b/%F0%9F%93%90-Mobile-Build?node-id=26801-116894&t=GwwykqKG33UxJcNw-1)
- [x] Expand virtual keyboard when search is active
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