# App Store Submission Checklist for EndZone Oracle

Complete this checklist step-by-step to ensure a smooth App Store submission.

---

## PHASE 1: Pre-Submission Preparation

### ☐ 1. Apple Developer Account
- [ ] Enrolled in Apple Developer Program ($99/year)
- [ ] Account is active and in good standing
- [ ] Payment information is up to date

### ☐ 2. Privacy Policy Hosting
- [ ] Upload `PRIVACY_POLICY.md` to your website
- [ ] Accessible at: https://endzoneoracle.com/privacy
- [ ] **Alternative:** Host on GitHub Pages (free)
  - Create a GitHub repo
  - Upload privacy policy
  - Enable GitHub Pages
  - Use URL: https://yourusername.github.io/endzoneoracle/privacy

### ☐ 3. Support Contact
- [ ] Set up email: support@endzoneoracle.com
- [ ] **Alternative:** Create contact form on website
- [ ] **Alternative:** Use personal email temporarily
- [ ] Test that email is receiving messages

### ☐ 4. Website (Optional but Recommended)
- [ ] Register domain: endzoneoracle.com
- [ ] Create simple landing page
- [ ] Add privacy policy page
- [ ] Add support/contact page
- [ ] **Alternative:** Use free hosting (GitHub Pages, Wix, etc.)

---

## PHASE 2: Xcode Configuration

### ☐ 5. Open Project in Xcode
- [ ] Navigate to: `EndZone Oracle/EndZone Oracle.xcodeproj`
- [ ] Double-click to open in Xcode
- [ ] Wait for project to fully load

### ☐ 6. Configure Signing & Capabilities
- [ ] Click project name in left sidebar (blue icon)
- [ ] Select "EndZone Oracle" target
- [ ] Click "Signing & Capabilities" tab
- [ ] Enable "Automatically manage signing" checkbox
- [ ] Select your Team from dropdown (your Apple Developer account)
- [ ] Verify Bundle Identifier: `com.endzoneoracle.EndZoneOracle`
  - **If different:** Change from `endzoneoracle.com.EndZone-Oracle`
  - **Location:** General tab → Identity → Bundle Identifier

### ☐ 7. Update Info.plist (if needed)
- [ ] Open `EndZone Oracle/NFLPredictions/Info.plist`
- [ ] Verify CFBundleDisplayName is "EndZone Oracle"
- [ ] Verify CFBundleShortVersionString is "1.0"
- [ ] Verify CFBundleVersion is "1"

### ☐ 8. Review App Icon
- [ ] Go to `Assets.xcassets` → `AppIcon`
- [ ] Verify 1024x1024 icon is present
- [ ] Icon should be:
  - No transparency
  - Square (1:1 ratio)
  - High quality
  - Represents your app

### ☐ 9. Test Build in Simulator
- [ ] Select "iPhone 15 Pro Max" from device dropdown
- [ ] Press Cmd + R (or click Play button)
- [ ] Wait for app to build and launch
- [ ] Test all main features:
  - [ ] View predictions
  - [ ] Tap game for details
  - [ ] Navigate to Stats tab
  - [ ] Navigate to Results tab
  - [ ] Navigate to Settings tab
  - [ ] Check for crashes or errors

---

## PHASE 3: Screenshots

### ☐ 10. Capture App Screenshots
Follow instructions in `SCREENSHOT_GUIDE.md`

- [ ] Screenshot 1: Home/Predictions screen
- [ ] Screenshot 2: Game detail view
- [ ] Screenshot 3: Statistics dashboard
- [ ] Screenshot 4: Results entry screen
- [ ] Screenshot 5: Team statistics or settings

- [ ] All screenshots saved to Desktop
- [ ] Screenshots are 1290 x 2796 pixels
- [ ] Create folder: `AppStoreAssets/Screenshots/`
- [ ] Move screenshots to this folder
- [ ] Review each screenshot for quality

### ☐ 11. Optional: Enhanced Screenshots
- [ ] Add text overlays explaining features
- [ ] Add device frames (optional)
- [ ] Create promotional graphics
- [ ] Tools: Screenshots.pro, Figma, or Sketch

---

## PHASE 4: App Store Connect Setup

### ☐ 12. Create App in App Store Connect
- [ ] Go to: https://appstoreconnect.apple.com
- [ ] Sign in with Apple Developer credentials
- [ ] Click "My Apps"
- [ ] Click "+" button → "New App"
- [ ] Fill in required fields:
  - **Platform:** iOS
  - **Name:** EndZone Oracle
  - **Primary Language:** English (U.S.)
  - **Bundle ID:** Select `com.endzoneoracle.EndZoneOracle`
  - **SKU:** `ENDZONEORACLE001` (or any unique ID)
  - **User Access:** Full Access
- [ ] Click "Create"

### ☐ 13. Complete App Information
In App Store Connect → Your App → App Information:

- [ ] **Subtitle:** NFL Predictions & Analytics
- [ ] **Privacy Policy URL:** https://endzoneoracle.com/privacy (or your URL)
- [ ] **Category:** Primary = Sports, Secondary = Entertainment
- [ ] **Content Rights:** Yes, I have rights to all content
- [ ] **Age Rating:** Click "Edit" and answer questionnaire (should be 4+)

### ☐ 14. Set Pricing and Availability
- [ ] Click "Pricing and Availability"
- [ ] **Price:** Free (0.00)
- [ ] **Availability:** All countries (or select specific ones)
- [ ] **Pre-orders:** No (for first release)

### ☐ 15. Complete App Privacy
- [ ] Click "App Privacy"
- [ ] Click "Get Started"
- [ ] Answer questions:
  - **Do you collect data from this app?** No (if you don't collect any)
  - Or select minimal data types if you do
- [ ] Save privacy details

---

## PHASE 5: Create Archive Build

### ☐ 16. Prepare for Archive
- [ ] In Xcode, ensure project is saved
- [ ] Close simulator if running
- [ ] Select target device: "Any iOS Device (arm64)" from dropdown
  - **Important:** Must select "Any iOS Device", NOT a simulator

### ☐ 17. Create Archive
- [ ] Go to Xcode menu: **Product → Archive**
- [ ] Wait for build to complete (2-5 minutes)
- [ ] If build fails:
  - [ ] Read error messages
  - [ ] Fix any code signing issues
  - [ ] Ensure valid Developer account is selected
  - [ ] Try again

### ☐ 18. Organizer Window
After successful archive:
- [ ] Organizer window opens automatically
- [ ] Your archive appears in the list
- [ ] Note the version number (1.0) and build (1)

---

## PHASE 6: Upload to App Store Connect

### ☐ 19. Distribute Archive
In Organizer window:
- [ ] Select your archive
- [ ] Click "Distribute App" button
- [ ] Select "App Store Connect"
- [ ] Click "Next"

### ☐ 20. Distribution Options
- [ ] Select "Upload"
- [ ] Click "Next"
- [ ] Check options:
  - ☑ Upload app symbols for Apple to symbolicate crash reports
  - ☑ Manage Version and Build Number (if available)
- [ ] Click "Next"

### ☐ 21. Automatic Signing
- [ ] Select "Automatically manage signing"
- [ ] Click "Next"
- [ ] Review app information
- [ ] Click "Upload"

### ☐ 22. Wait for Processing
- [ ] Upload progress bar completes (1-5 minutes)
- [ ] Success message appears
- [ ] Click "Done"
- [ ] Wait for Apple to process build (5-30 minutes)
- [ ] Check email for processing confirmation

---

## PHASE 7: Submit for Review

### ☐ 23. Add Build to Version
In App Store Connect:
- [ ] Go to your app → "App Store" tab
- [ ] Scroll to "Build" section
- [ ] Click "Select a build before you submit your app"
- [ ] Wait if build shows "Processing" (check back in 10-30 min)
- [ ] Once available, click the "+" button next to your build
- [ ] Select your build (1.0 / 1)

### ☐ 24. Add Screenshots
- [ ] Scroll to "App Store Screenshots" section
- [ ] Select "6.7" iPhone Display"
- [ ] Drag and drop your 5 screenshots
- [ ] Arrange in order (drag to reorder)
- [ ] Optional: Add captions to describe each screenshot

### ☐ 25. Complete Version Information
- [ ] **Description:** Copy from `APP_STORE_METADATA.md`
- [ ] **Keywords:** Copy from metadata file
- [ ] **Support URL:** https://endzoneoracle.com/support (or your URL)
- [ ] **Marketing URL:** (optional)
- [ ] **Promotional Text:** Copy from metadata (optional)
- [ ] **What's New:** Copy version 1.0 notes from metadata

### ☐ 26. App Review Information
- [ ] Scroll to "App Review Information"
- [ ] Fill in your contact details:
  - **First Name:** [Your Name]
  - **Last Name:** [Your Name]
  - **Phone Number:** [Your Number]
  - **Email:** support@endzoneoracle.com
- [ ] **Notes:** Add any special instructions for reviewers
  - "This app tracks NFL predictions. No login required. All features accessible from main tabs."

### ☐ 27. Version Release
- [ ] Select "Automatically release this version"
  - **Or:** "Manually release this version" (you control release date)
- [ ] Recommended: Automatic for first release

### ☐ 28. Export Compliance
- [ ] Answer: "Is your app designed to use cryptography?"
  - **Yes** → Then select "uses standard iOS encryption only" → Qualifies for exemption
- [ ] No export compliance documentation needed

### ☐ 29. Content Rights
- [ ] Confirm you have rights to all content
- [ ] Check the box

### ☐ 30. Advertising Identifier
- [ ] Answer: "Does this app use the Advertising Identifier (IDFA)?"
  - **No** (unless you're using ad networks)

---

## PHASE 8: Final Submission

### ☐ 31. Save All Changes
- [ ] Click "Save" at top right
- [ ] Verify no errors or missing fields

### ☐ 32. Submit for Review
- [ ] Click "Submit for Review" button (top right)
- [ ] Confirm submission in dialog
- [ ] Status changes to "Waiting for Review"

### ☐ 33. Confirmation
- [ ] Check email for submission confirmation
- [ ] Note submission date/time
- [ ] Status in App Store Connect: "Waiting for Review"

---

## PHASE 9: After Submission

### ☐ 34. Monitor Status
Check App Store Connect daily for status updates:
- **Waiting for Review:** ~1-3 days
- **In Review:** ~1-24 hours
- **Pending Developer Release:** Approved! (if manual release selected)
- **Ready for Sale:** Live on App Store!

### ☐ 35. Possible Outcomes

**If APPROVED:**
- [ ] App goes live automatically (or you release manually)
- [ ] Test by searching App Store for "EndZone Oracle"
- [ ] Download and verify it works
- [ ] Share with friends!

**If REJECTED:**
- [ ] Read rejection reason carefully
- [ ] Address issues mentioned
- [ ] Make necessary changes
- [ ] Create new build
- [ ] Upload and resubmit
- [ ] Common issues:
  - Missing privacy policy
  - App crashes
  - Missing functionality described
  - Incorrect metadata

### ☐ 36. Post-Launch
- [ ] Monitor reviews and ratings
- [ ] Respond to user feedback
- [ ] Fix any reported bugs
- [ ] Plan updates and new features
- [ ] Promote your app!

---

## Quick Reference: Important Links

- **App Store Connect:** https://appstoreconnect.apple.com
- **Developer Portal:** https://developer.apple.com/account
- **App Store Review Guidelines:** https://developer.apple.com/app-store/review/guidelines/
- **TestFlight (Beta Testing):** https://appstoreconnect.apple.com → TestFlight
- **Sales and Trends:** https://appstoreconnect.apple.com → Sales and Trends

---

## Troubleshooting Common Issues

### Build Fails with Code Signing Error
- Ensure you're logged into Xcode with Apple ID
- Check Developer account is active
- Try: Xcode → Preferences → Accounts → Download Manual Profiles
- Clean build folder: Product → Clean Build Folder (Shift + Cmd + K)

### Archive Option is Greyed Out
- Make sure you selected "Any iOS Device" (not simulator)
- Scheme must be set to "Release" build configuration

### Build Processing Takes Forever
- Usually takes 10-30 minutes
- Check email for processing complete notification
- If stuck >1 hour, try uploading again

### Missing Required Icon
- Need 1024x1024 icon in Assets.xcassets → AppIcon
- Must be PNG, no transparency
- Use Image editing tool to create if needed

### Privacy Policy URL Not Working
- Test URL in browser before submitting
- Must be HTTPS (secure)
- Must be publicly accessible
- Use GitHub Pages if you don't have a website

---

## Estimated Timeline

**Preparation:** 2-4 hours
- Creating materials, screenshots, testing

**First Archive & Upload:** 30-60 minutes
- Building, archiving, uploading

**App Store Connect Setup:** 30-60 minutes
- Filling in all metadata, screenshots, info

**Apple Review:** 1-7 days
- Typically 1-2 days for simple apps

**TOTAL:** ~3-10 days from start to App Store

---

## Support

If you get stuck:
- **Apple Documentation:** https://developer.apple.com/documentation/
- **Developer Forums:** https://developer.apple.com/forums/
- **Stack Overflow:** Tag questions with [ios] [app-store-connect]
- **My Help:** Feel free to ask me for guidance on any step!

---

## You're Ready! 🚀

You now have everything you need:
- ✅ Privacy Policy
- ✅ App Store Description
- ✅ Keywords and Metadata
- ✅ Screenshot Guide
- ✅ Complete Checklist

**Next Steps:**
1. Start with Phase 1 (Pre-Submission Preparation)
2. Work through each phase systematically
3. Check off items as you complete them
4. Don't rush - take your time on each step

Good luck with your App Store submission! 🏈
