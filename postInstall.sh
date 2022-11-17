#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: postInstall.sh              (Update: 2022-11-15) #
#-Info--------------------------------------------------------#
#  Personal post-install script for Kali Linux Rolling        #
#-Author(s)---------------------------------------------------#
#  Javi.Infosec ~ Twitter		                      #
#  Based on g0tmi1k kali.rolling.sh 	  		      #
#-Operating System--------------------------------------------#
#  Designed for: Kali Linux Rolling [x64] (VM - VMware)       #
#     Tested on: Kali Linux 2022.3 x64			      #
#-Notes-------------------------------------------------------#
#  Run  straight after a clean install of Kali         	      #
#                             ---                             #
#-------------------------------------------------------------#

if [ 1 -eq 0 ]; then    # This is never true, thus it acts as block comments ;)
################################################################################
### One liner - Grab the latest version and execute! ###########################
################################################################################
wget -qO postInstall.sh \
https://raw.githubusercontent.com/Javi-Infosec/Kali-Post-Install/main/postInstall.sh \
&& sudo bash postInstall.sh
################################################################################
fi

##### (Cosmetic) Colour output
RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal

STAGE=0                                                         # Where are we up to
TOTAL=$( grep '(${STAGE}/${TOTAL})' $0 | wc -l );(( TOTAL-- ))  # How many things have we got todo

##### Check if we are running as javi - else create it
##### Comment those lines you don't need to have a user with my name :D 

if [[ "${EUID}" -ne 1337 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as javi(uid 1337)${RESET}" 1>&2
  echo -e ' '${YELLOW}'[!]'${RESET}" Checking if javi is created" 1>&2
  if (grep -q 'javi' /etc/passwd 2>/dev/null); then
	echo -e ' '${YELLOW}'[!]'${RESET}" javi exists, please check UID or sudo." 1>&2
	exit 1
  else
  	echo -e ' '${RED}'[!]'${RESET}" ${RED}javi is not created.${RESET} Creating it..." 1>&2
	sudo useradd -u 1337 -m javi && sudo usermod -aG sudo javi;
	sudo chsh -s /usr/bin/zsh javi
 	echo -e ' '${YELLOW}'[*]'${RESET}" javi has been created, ${RED}CHANGE the password${RESET} and  login with the user." 1>&2
  	exit 1
  fi

else
  echo -e " ${BLUE}[*]${RESET} ${BOLD}Kali Linux rolling post-install script${RESET}"
  sleep 1s
fi

#-----------------------START-------------------------

#Updating Kali
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Updating Kali.${RESET}"
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

#Adding NerdFont
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Adding Patched FiraCode Medium Font.${RESET}"
file="~/.local/share/fonts/Fira Code Medium Nerd Font Complete Mono.ttf";
if [ ! -e "${file}" ]; then
	curl -fLo "Fira Code Medium Nerd Font Complete Mono.ttf" --create-dirs --output-dir ~/.local/share/fonts \
	"https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.ttf"
	fc-cache -fv
fi
#Setting Keyboard to Spanish
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Setting keyboard to Spanish. ${RESET}"
setxkbmap es

#Change Timezone
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Setting Timezone to Madrid. ${RESET}"
sudo timedatectl set-timezone  Europe/Madrid

#Installing Brave
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Installing Brave Web Browser. ${RESET}"
sudo apt install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"| \
sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser


#Installing lsd - alias should come from config files

(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Installing lsd. ${RESET}"
curl -fLo "lsd_0.23.1_amd64.deb" --create-dirs --output-dir ./tmp "https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb" && \
sudo dpkg -i ./tmp/lsd_0.23.1_amd64.deb

# Installing bat - alias should come from config files
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Installing bat. ${RESET}"
sudo apt install bat -y

# Installing kitty -  config on dotfiles
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Installing kitty. ${RESET}"
sudo apt install kitty -y

# Setup git config
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Configuring git user. ${RESET}"
git config --global user.email "javi.infosec@gmail.com"
git config --global user.name "javi"

# Setup git alias to get dotfiles
#Reference https://www.atlassian.com/git/tutorials/dotfiles
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Configuring git aliases. ${RESET}"
echo ".cfg" >> $HOME/.gitignore
git clone --bare git@github.com:Javi-Infosec/.cfg.git $HOME/.cfg
#alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
mkdir -p $HOME/.cfg-backup
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
if [ $? = 0 ]; then
    echo -e "\n\n ${GREEN}[+]${RESET}  ${GREEN}Checked out config. ${RESET}";
else
    echo -e "\n\n ${YELLOW}[!]${RESET} ${YELLOW}Backing up pre-existing dot iles. ${RESET}"
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv $HOME/{} $HOME/.cfg-backup/{}
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
    echo -e "\n\n ${GREEN}[+]${RESET}  ${GREEN}Checked out config. ${RESET}";

fi;
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config status.showUntrackedFiles no

