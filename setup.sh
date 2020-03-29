#!/usr/bin/env bash
set -ex
clear

sudo
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

install_and_update_homebrew() {
    if test ! "$(command -v brew)"; then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew update
    brew cask upgrade
}

install_brew_packages() {
    brew tap getantibody/tap
    brew tap git-duet/tap
    brew tap go-task/tap
    brew cask install corretto

    brew install \
        antibody \
        bash \
        bash-completion2 \
        git \
        git-duet \
        git-extras \
        go \
        go-task \
        google-java-format \
        gradle \
        htop \
        maven \
        sonar-scanner \
        shellcheck \
        ssh-copy-id \
        tree \
        watch \
        wget
        
    brew install vim
    
    brew cask install \
        appcleaner \
        cyberduck \
        docker \
        enpass \
        flowsync \
        google-chrome \
        github \
        gitkraken \
        intellij-idea \
        iterm2 \
        libreoffice \
        macdown \
        postman \
        shiftit \
        slack \
        the-unarchiver \
        tigervnc-viewer \
        tunnelblick \
        visual-studio-code 
        vlc
}

install_ruby_packages() {
    gem install mdl
    gem install travis
}
 
install_zsh_config() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/jaedle/zsh-config/master/install.sh)"
}

install_virtual_box() {
    brew cask install \
        vagrant \
        virtualbox

    vagrant plugin install vagrant-vbguest
}

setup_dock() {
    brew install dockutil
    dockutil --remove all

    dockutil --add "/Applications/Google Chrome.app"
    dockutil --add "/Applications/Mail.app"
    dockutil --add "/Applications/Calendar.app"
    dockutil --add "/Applications/Notes.app"
    dockutil --add "/Applications/Messages.app"
    dockutil --add "/Applications/iTunes.app"
    dockutil --add "/Applications/IntelliJ IDEA.app"
    dockutil --add "/Applications/Visual Studio Code.app"
    dockutil --add "/Applications/GitHub Desktop.app"
    dockutil --add "/Applications/iTerm.app"
    dockutil --add "/Applications/Slack.app"
    dockutil --add "/Applications/App Store.app"
    dockutil --add "/Applications/System Preferences.app"
    dockutil --add /Applications
    dockutil --add ~/Downloads
}

setup_macos() {
    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "
    
    # Automatically quit printer app once the print jobs complete
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

    # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

   # Restart automatically if the computer freezes
    sudo systemsetup -setrestartfreeze on

    # Check for software updates daily, not just once per week
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

    # Increase sound quality for Bluetooth headphones/headsets
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Save screenshots to the Pictures/Screenshots
    mkdir -p ${HOME}/Pictures/Screenshots
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # Set Desktop as the default location for new Finder windows
    # For other paths, use `PfLo` and `file:///full/path/here/`
    defaults write com.apple.finder NewWindowTarget -string "PfDe"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

    # Show icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Finder: show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Finder: allow text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool true

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Automatically open a new Finder window when a volume is mounted
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Empty Trash securely by default
    defaults write com.apple.finder EmptyTrashSecurely -bool true

    # Show the ~/Library folder
    chflags nohidden ~/Library

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0

    # Use the system-native print preview dialog
    defaults write com.google.Chrome DisablePrintPreview -bool true
    defaults write com.google.Chrome.canary DisablePrintPreview -bool true

    # Expand the print dialog by default
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
}

setup_bash_configuration() {
    path_of_repository="$( cd "$(dirname "$0")" ; pwd -P )"
    cp "$path_of_repository/.bash_profile" ~/.bash_profile
    chmod 0700 ~/.zshrc
}

install_and_update_homebrew
install_brew_packages
install_ruby_packages
install_zsh_config
install_virtual_box
setup_dock

setup_bash_configuration

setup_macos
