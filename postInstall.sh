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
#  Run  straight after a clean install of Kali         #
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

##### Check if we are running as root - else this script will fail (hard!)
#if [[ "${EUID}" -ne 0 ]]; then
#  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}" 1>&2
#  echo -e ' '${RED}'[!]'${RESET}" Quitting..." 1>&2
#  exit 1
#else
#  echo -e " ${BLUE}[*]${RESET} ${BOLD}Kali Linux rolling post-install script${RESET}"
#  sleep 2s
#fi

#-----------------------START-------------------------

#Updating Kali
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Updating Kali.${RESET}"
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
#Creating New User
#(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Creating new user.${RESET}"
#useradd -m javi && usermod -aG sudo javi

#Adding NerdFont
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL})  ${GREEN}Adding Patched FiraCode Medium Font.${RESET}"
curl -fLo "Fira Code Medium Nerd Font Complete Mono.ttf" --create-dirs --output-dir ~/.local/share/fonts \
"https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.ttf" \
