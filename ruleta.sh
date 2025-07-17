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
  tput cnorm; exit 1
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

  #echo -e "\n${yellowColour}[+]${endColour}${greyColour} Vamos a jugar con un monto inicial de: ${endColour}${greenColour}$initial_bet\$${endColour} ${greyColour}a ${endColour}${turquoiseColour}$par_impar${endColour}"

  #Variables
  backup_bet=$initial_bet
  play_counter=0
  jugadas_malas="[ "
  mayor_cant=$money
  mayor_pos=$play_counter
#  sleep 2
  tput civis #Ocultar el cursor

  #Verificación de datos
  if [[ "$initial_bet" =~ ^[1-9][0-9]*$ ]] && ! [[ "$par_impar" =~ ^[0-9]+$ ]]; then
    #Arranca el bucle
    while true; do 
      let play_counter+=1
      if [ "$money" -lt "$initial_bet" ]; then
        echo -e "\n${redColour}[!] Saldo insuficiente: $initial_bet$ (apuesta) > $money$ (monto)${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Se han hecho${endColour} ${blueColour}$(($play_counter-1))${endColour}${greyColour} jugadas${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Malas jugadas consecutivas:${endColour}"
        echo -e "\n${blueColour}$jugadas_malas]${endColour}"
        if [ "$mayor_pos" -eq 0 ]; then
          echo -e "\n${yellowColour}[+]${endColour} ${greyColour}La mayor cantidad de dinero que se tuvo fué la del monto inicial:${endColour} ${greenColour}$mayor_cant\$${endColour} ${greyColour}en la jugada${endColour} ${blueColour}$mayor_pos${endColour}"
        else
          echo -e "\n${yellowColour}[+]${endColour} ${greyColour}La mayor cantidad de dinero que se tuvo fué de:${endColour} ${greenColour}$mayor_cant\$${endColour} ${greyColour}en la jugada${endColour} ${blueColour}$mayor_pos${endColour}"
        fi 
        tput cnorm; exit 0
      fi
      
  #    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Bet:${endColour} ${greenColour}$initial_bet\$${endColour} ${purpleColour}/${endColour} ${greyColour}Dinero actual:${endColour} ${greenColour}$money\$${endColour}\n"
      money=$(($money-$initial_bet))
      random_number="$(($RANDOM % 37))"
  #    echo -e "${yellowColour}[+]${endColour} ${greyColour}Ha salido el número${endColour} ${blueColour}$random_number${endColour}"
      
      if [ "$par_impar" == "par" ]; then
        #PARES
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
  #          echo -e "\n${redColour}[!] Salió el 0, perdiste${endColour}"
  #          echo -e "${redColour}[!] Pérdida: $initial_bet\$${endColour}"
            initial_bet=$(($initial_bet*2))
  #          echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Tienes:${endColour} ${greenColour}$money\$${endColour}"
  #          echo -e "\n----------------------------------------------------------------------------------------------------"
            jugadas_malas+="$random_number "
        else
  #          echo -e "\n${turquoiseColour}[+] Salió un número par, ¡GANAS!${endColour}"
            reward=$(($initial_bet*2))
  #          echo -e "${turquoiseColour}[+] Beneficio:${endColour} ${greenColour}$reward\$${endColour}"
            money=$(($money+$reward))
  #          echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Tienes: ${endColour}${greenColour}$money\$${endColour}"
            initial_bet=$backup_bet
  #          echo -e "\n----------------------------------------------------------------------------------------------------"
            jugadas_malas="[ "
            if [ ! $money -le $mayor_cant ]; then
              mayor_cant=$money
              mayor_pos=$play_counter
            fi
          fi
        else
  #        echo -e "\n${redColour}[!] Salió un número impar, perdiste${endColour}"
  #        echo -e "${redColour}[!] Pérdida: $initial_bet\$${endColour}"
          initial_bet=$(($initial_bet*2))
  #        echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Tienes: ${endColour}${greenColour}$money\$${endColour}"
  #        echo -e "\n----------------------------------------------------------------------------------------------------"
          jugadas_malas+="$random_number "
        fi

      elif [ "$par_impar" == "impar" ]; then
        #IMPAR
        if [ "$(($random_number % 2))" -eq 1 ]; then
  #          echo -e "\n${turquoiseColour}[+] Salió un número impar, ¡GANAS!${endColour}"
          reward=$(($initial_bet*2))
  #          echo -e "${turquoiseColour}[+] Beneficio:${endColour} ${greenColour}$reward\$${endColour}"
          money=$(($money+$reward))
  #          echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Tienes: ${endColour}${greenColour}$money\$${endColour}"
          initial_bet=$backup_bet
  #          echo -e "\n----------------------------------------------------------------------------------------------------"
          jugadas_malas="[ "
          if [ ! $money -le $mayor_cant ]; then
            mayor_cant=$money
            mayor_pos=$play_counter
          fi
        else
  #        echo -e "\n${redColour}[!] Salió un número par, perdiste${endColour}"
  #        echo -e "${redColour}[!] Pérdida: $initial_bet\$${endColour}"
        initial_bet=$(($initial_bet*2))
  #        echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Tienes: ${endColour}${greenColour}$money\$${endColour}"
  #        echo -e "\n----------------------------------------------------------------------------------------------------"
        jugadas_malas+="$random_number "
        fi
      else
        echo -e "\n${redColour}[!]${endColour} ${greyColour}Valores válidos${endColour} ${blueColour}->${endColour} ${purpleColour}(${endColour}${turquoiseColour}par${endColour}${purpleColour}/${endColour}${turquoiseColour}impar${endColour}${purpleColour})${endColour}"
        exit 1
      fi
    done
  else
    echo -e "\n${redColour}[!] Asegurate de ingresar valores válidos${endColour}"
    exit 1
  fi

  tput cnorm #Recuperar el cursor
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
