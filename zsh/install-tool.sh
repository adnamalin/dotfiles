
# Powerline fonts

# Set source and target directories
powerline_fonts_dir="$( cd "$( dirname "$0" )" && pwd )"

# if an argument is given it is used to select which fonts to install
prefix="$1"

if test "$(uname)" = "Darwin" ; then
  # MacOS
  font_dir="$HOME/Library/Fonts"
else
  # Linux
  font_dir="$HOME/.local/share/fonts"
  mkdir -p $font_dir
fi

# Copy all fonts to user fonts directory
echo "Copying fonts..."
find "$powerline_fonts_dir" \( -name "$prefix*.[ot]tf" -or -name "$prefix*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" "$font_dir/"

# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$font_dir"
fi

echo "Powerline fonts installed to $font_dir"

if ! [ -x "$(command -v zsh)" ]
then
  echo "installing zsh"
  if [ "$(uname -s)" == "Darwin" ]
  then
    brew install zsh
  else
    sudo apt install -y zsh
  fi

else
  echo "zsh already installed"
  zsh --version
fi

# # Set zsh as default shell
# sudo chsh -s $(which zsh)

# Install Oh My Zsh

if [ -d "$HOME/.oh-my-zsh/" ]
then
  echo "Oh My Zsh already installed, removing it"
  rm -rf  "$HOME/.oh-my-zsh/"
fi

# https://github.com/ohmyzsh/ohmyzsh#unattended-install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Pure Prompt
# https://github.com/sindresorhus/pure#manually
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Install zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


cp zsh/.zshrc ~