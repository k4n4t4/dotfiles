if cmd_exists firefox; then
    firefox_folder=~/.config/mozilla/firefox
    firefox_profile_name="$(grep -m 1 '^Default=' $firefox_folder/profiles.ini | cut -d= -f2)"
    firefox_profile="$firefox_folder/$firefox_profile_name"

    if [ -d "$firefox_profile" ]; then
        dothome ".config/firefox/user.js" "$firefox_profile/user.js"
        dothome ".config/firefox/userChrome.css" "$firefox_profile/chrome/userChrome.css"
        dothome ".config/firefox/userContent.css" "$firefox_profile/chrome/userContent.css"
    else
        echo "Firefox profile not found at $firefox_profile"
    fi
fi
