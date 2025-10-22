for folder in ~/.mozilla/firefox/*.default-release; do
  if [ -d "$folder" ]; then
    dothome ".config/firefox/user.js" "$folder/user.js"
    dothome ".config/firefox/userChrome.css" "$folder/chrome/userChrome.css"
    dothome ".config/firefox/userContent.css" "$folder/chrome/userContent.css"
  fi
done
