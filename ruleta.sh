#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
greyColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  exit 1
}

#Ctrl+C
trap ctrl_c INT

#Funciones
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour} ${greyColour}Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour} ${greyColour}Técnica que se desea emplear${endColour} ${purpleColour}(${endColour}${turquoiseColour}martingala${endColour}${purpleColour}/${endColour}${turquoiseColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Dinero actual${endColour} ${greenColour}$money\$${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿Cuánto dinero quieres apostar? ${endColour}${blueColour}->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿A qué deseas apostar contínuamente?${endColour} ${purpleColour}(${endColour}${turquoiseColour}par${endColour}${purpleColour}/${endColour}${turquoiseColour}impar${endColour}${purpleColour})${endColour} ${blueColour}->${endColour} " && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Vamos a jugar con un monto inicial de: ${endColour}${greenColour}$initial_bet\$${endColour} ${greyColour}a ${endColour}${turquoiseColour}$par_impar${endColour}"
}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ $technique == "martingala" ]; then
    martingala
  else
    echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
