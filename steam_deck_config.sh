#sets a password
passwd

#disables readonly if in steamos
if ! command -v steamos-readonly &>/dev/null; then
  echo "disabling readonly"
  sudo steamos-readonly disable
fi

# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

# Update Homebrew and Upgrade any already-installed formulae
brew update
brew upgrade
brew cleanup

# Define an array of packages to install using Homebrew.
packages=(
    "python"
    "python@3.11"
    "zoxide"
    "bat"
    "helix"
    "gh"
    "tmux"
    "neofetch"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^$package\$"; then
        echo "$package is already installed. Skipping..."
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

apps=(
    "firefox"
    "spotify"
    "discord"
    "bitwarden"
)

# install programs
for app in "${apps[@]}"; do
    if flatpak list | grep -q "^$app\$"; then
        echo "$app is already installed. Skipping..."
    else
        echo "Installing $app..."
        flatpak install "$app"
    fi
done

# Git config name
echo "Please enter your FULL NAME for Git configuration:"
read git_user_name

# Git config email
echo "Please enter your EMAIL for Git configuration:"
read git_user_email

# Set my git credentials
$(brew --prefix)/bin/git config --global user.name "$git_user_name"
$(brew --prefix)/bin/git config --global user.email "$git_user_email"

#login to gh
if ! command -v gh &>/dev/null; then
  gh auth login
fi

echo "Sign in to Firefox. Press enter to continue..."
read

echo "Sign in to Spotify. Press enter to continue..."
read

echo "Sign in to Discord. Press enter to continue..."
read

#moving dotfiles to home
cp .bash_profile ~
cp .bashrc ~
cp .hx.conf.toml ~
cp .tmux.conf ~

# insert brew in path
echo 'if [ $(basename $(printf "%s" "$(ps -p $(ps -p $$ -o ppid=) -o cmd=)" | cut --delimiter " " --fields 1)) = konsole ] ; then '$'\n''eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'$'\n''fi'$'\n' >> ~/.bash_profile

#set wallpaper
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var allDesktops = desktops();
    for (i=0;i<allDesktops.length;i++) 
    {
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
        d.writeConfig("Image", "wallpaper.png")
    }
'

#set kde theme
if command -v pip3.11 &> /dev/null; then
    pip3.11 install konsave
    if command -v konsave &> /dev/null; then
        konsave -i kde_theme.knsv
        konsave -a my_kde_theme
    else
        echo "failed to install konsave"
    fi
else
    echo "pip3.11 not installed, please install"
fi

#set konsole theme
if ! test -d ~/.local/share/konsole/; then
    mkdir ~/.local/share/konsole
fi
cp MaterialYou.colorscheme ~/.local/share/konsole
cp TempMyou.profile ~/.local/share/konsole
if command -v konsoleprofile; then
    echo "setting konsole profile and color scheme"
    konsoleprofile Path=~/.local/share/konsole/TempMyou.profile
    konsoleprofile ColorScheme=MaterialYou.colorscheme
else
    echo "konsoleprofile command not working, set its theme and profile manually"
fi
    
#put steamos back to readonly  
if ! command -v steamos-readonly &>/dev/null; then
  echo "enabling readonly"
  sudo steamos-readonly enable
fi
