
# History

Fork From @ravinandan25/react-native-lottie-splash-screen
At 2026-03-16

- change dependency RN 0.82 to RN 0.81
- fix index.d.ts
- change to colored background on iOS
- change to lottie size 300 to 40% of width



# @ravinandan25/react-native-lottie-splash-screen

[![npm](https://img.shields.io/badge/npm-@ravinandan25/react--native--lottie--splash--screen-blue)](https://www.npmjs.com/package/@ravinandan25/react-native-lottie-splash-screen)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg)](https://github.com/ravinandan25/react-native-lottie-splash-screen/pulls)
[![License MIT](https://img.shields.io/badge/license-MIT-orange.svg)](https://opensource.org/licenses/MIT)

Fixed version of `react-native-lottie-splash-screen` — resolves gray overlay and status bar issues on Android. Works on React Native 0.82+ with Swift implementation on iOS.

## Contents
- Version Compatibilities
- Examples
- Installation
- iOS Setup
- Android Setup
- Usage
- API
- Contribution

## Versions Compatibilities
| React Native | Package Version |
|---|---|
| >= 0.82 | 3.x |
| >= 0.70 & < 0.77 | 2.x |
| < 0.70 | 1.x |

## Examples
![Android](screenshot/Lottie-Splash-Screen-Android.gif)
![iOS](screenshot/Lottie-Splash-Screen-IOS.gif)

Run examples:

```
yarn install
yarn bare:install
yarn bare:ios
yarn bare:android
yarn expo:install
yarn expo:ios
yarn expo:android
```

## Installation
```
yarn add "@ravinandan25/react-native-lottie-splash-screen" "lottie-react-native@7.3.4"
cd ios && bundle install && bundle exec pod install
```

## iOS Setup
1. Add your Lottie JSON (e.g., `loading.json`) to the Xcode project and include it in your app target.  
2. Replace or edit your `AppDelegate.swift`:

```
import UIKit
import SplashScreen

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    SplashScreen.setupLottieSplash(
      in: window,
      lottieName: "loading",
      backgroundColor: UIColor.white,
      forceToCloseByHideMethod: false
    )

    return true
  }
}
```

3. Remove the default launch screen or make it blank in `LaunchScreen.storyboard`.

## Android Setup
1. Create `android/app/src/main/res/layout/launch_screen.xml`:

```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    tools:context=".MainActivity"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/primary"
>
    <com.airbnb.lottie.LottieAnimationView
        android:id="@+id/lottie"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:lottie_rawRes="@raw/loading"
        app:lottie_autoPlay="true"
        app:lottie_loop="true"
    />
</LinearLayout>

```
2. Place your Lottie JSON at `android/app/src/main/res/raw/loading.json`.

3. Add colors in `android/app/src/main/res/values/colors.xml`:

```
<resources>
  <color name="windowSplashScreenBackground">#ffffff</color>
</resources>
```

4. Add styles in `android/app/src/main/res/values/styles.xml`:

```
<resources>
    <style name="AppTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <item name="android:editTextBackground">@drawable/rn_edit_text_material</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
    </style>
    <style name="SplashScreen_SplashTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">      

        <!-- Fullscreen flags -->
        <item name="android:windowFullscreen">true</item>
        <item name="android:windowTranslucentStatus">false</item>
        <item name="android:windowTranslucentNavigation">false</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>

        <!-- System bars -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>

        <!-- No title -->
        <item name="android:windowNoTitle">true</item>
        <item name="android:windowActionBar">false</item>

        <!-- For notches/cutouts -->
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    </style>
</resources>
```

5. Update `MainActivity.kt`:

```
import android.os.Bundle
import org.devio.rn.splashscreen.SplashScreen
import com.facebook.react.ReactActivity

class MainActivity : ReactActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    SplashScreen.show(this, R.style.SplashScreen_SplashTheme, R.id.lottie, false)
  }
}
```

## Usage
```
import { useEffect } from "react";
import LottieSplashScreen from "@ravinandan25/react-native-lottie-splash-screen";

export default function App() {
  useEffect(() => {
    LottieSplashScreen?.hide();
  }, []);
  return null;
}
```

## API
| Method | Type | Description |
|--------|------|-------------|
| hide() | function | Hides the Lottie splash overlay |

## Contribution
Issues and PRs are welcome. Include a minimal repro if possible.

**MIT Licensed**  
by Ravinandan
