#!/bin/bash

echo "Configuring dock"
# - Dock: Enable Magnification
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 128
# - Hot Corners: Top Left - Sleep Display
# - Hot Corners: Bottom Left - Disable Screen Saver
# - Hot Corners: Bottom Right - Lock Screen
# - Hot Corners: Top Right - Notification Center
defaults write com.apple.dock "wvous-bl-corner" -int 5
defaults write com.apple.dock "wvous-br-corner" -int 13
defaults write com.apple.dock "wvous-tl-corner" -int 10
defaults write com.apple.dock "wvous-tr-corner" -int 12
killall Dock

echo "Configuring Trackpad"
# - Trackpad: Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.finder "$(defaults export com.apple.finder - | plutil -replace StandardViewSettings.IconViewSettings.arrangeBy -string "name" - -o -)"
echo "Configuring Finder"
# - Desktop: Show HDD
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool YES
# - Finder: Group and Sort Icons
defaults write com.apple.finder "_FXSortFoldersFirst" -bool YES

# - Finder: Show Path Bar
defaults write com.apple.finder ShowPathbar -bool YES
# - Finder: Set default search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
# - Desktop: Icon Size/Spacing
defaults write com.apple.finder "$(defaults export com.apple.finder - | plutil -replace DesktopViewSettings.IconViewSettings.iconSize -float "128" - -o -)"
defaults write com.apple.finder "$(defaults export com.apple.finder - | plutil -replace DesktopViewSettings.IconViewSettings.gridSpacing -float "100" - -o -)"
# - Finder: Show Library Folder
chflags nohidden ~/Library
# - Finder: System Preferences, Accessibility, Display, Show window title icons
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool YES # Terminal Full Disk Access
# - Spaces: Disable automatic arrangement
defaults write com.apple.dock "mru-spaces" -bool NO
# - Accessibility - Zoom: Enable scroll gesture zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool YES

killall Finder

echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "export PATH=/opt/homebrew/bin:$PATH" >> "$HOME/.zshrc"
source ~/.zshrc
brew install pygments
brew install font-fira-code
brew install font-fira-mono
brew install mas
source ~/.zshrc

echo "Configuring Terminal"
# - Set Terminal Theme
#defaults write com.apple.terminal "Default Window Settings" -string Homebrew
# - Enable TouchID sudo
sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
sudo sed -i '' 's/#auth/auth/g' /etc/pam.d/sudo_local

echo "Installing Apps"
# - 1Password
mas install 1333542190
# - Textastic
mas install 572491815
# - DevCleaner for Xcode
mas install 1388020431
# - Slack
mas install 803453959
# - Pure Paste
mas install 1611378436
# - Ice
brew install jordanbaird-ice

echo "Importing Settings"
# - Terminal Settings
defaults import com.apple.Terminal TerminalSettings.plist
# - Ice Settings
defaults import com.jordanbaird.Ice IceSettings.plist
# - Textastic Settings
defaults import com.textasticapp.textastic-mac TextasticSettings.plist
# - Tower Settings
defaults import com.fournova.Tower3 TowerSettings.plist
# - Kaleidoscope Settings
defaults import app.kaleidoscope.v4 KaleidoscopeSettings.plist

echo "Adding aliases"
echo "alias cat='pygmentize -g'" >> "$HOME/.zshrc"
echo "alias txt='open -a Textastic'" >> "$HOME/.zshrc"
echo "alias odd='cd ~/Library/Developer/Xcode/;open DerivedData'" >> "$HOME/.zshrc"
source ~/.zshrc

echo "Development Configuration"
# - Create Developer Folder
mkdir -p ~/Developer
# - Xcode: Dark Theme
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cp "Dusk Fira.xccolortheme" ~/Library/Developer/Xcode/UserData/FontAndColorThemes/

echo "Done!"