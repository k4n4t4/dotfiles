for folder in ~/.mozilla/firefox/*.default-release; do
  if [ -d "$folder" ]; then
    dot ".config/firefox/user.js" "$folder/user.js"
    dot ".config/firefox/userChrome.css" "$folder/chrome/userChrome.css"
    dot ".config/firefox/userContent.css" "$folder/chrome/userContent.css"
  fi
done
