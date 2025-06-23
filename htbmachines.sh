#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
greyColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${yellowColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

#Ctrl+c
trap ctrl_c INT

#Variables globales

main_url="https://htbmachines.github.io/bundle.js"

#Funciones

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour} ${greyColour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}m)${endColour} ${greyColour} Buscar por nombre de maquina${endColour}"
  echo -e "\t${purpleColour}i)${endColour} ${greyColour} Buscar por direccion IP${endColour}"
  echo -e "\t${purpleColour}d)${endColour} ${greyColour} Buscar por la dificultad de una maquina${endColour}"
  echo -e "\t${purpleColour}o)${endColour} ${greyColour} Buscar por el sistema operativo${endColour}"
  echo -e "\t${purpleColour}s)${endColour} ${greyColour} Buscar por skills (si son más de 1 separar por espacios) ${endColour}"
  echo -e "\t${purpleColour}y)${endColour} ${greyColour} Obtener el link de la maquina resuelta en Youtube${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${greyColour} Mostrar este panel de ayuda${endColour}\n"
}


function updateFiles(){
  if [ ! -f bundle.js ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Descargando archivos necesarios...${endColour}"
    tput civis
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    tput cnorm
    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Se descargaron con exito :)${endColour}"
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${greyColour} Comprobando si hay actualizaciones...${endColour}"
    sleep 1.5
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    sha256_temp_value=$(sha256sum bundle_temp.js | awk '{print $1}')
    sha256_original_value=$(sha256sum bundle.js | awk '{print $1}')
    if [ $sha256_temp_value == $sha256_original_value ]; then
      echo -e "\n${yellowColour}[+]${endColour}${greyColour} No hay actualizaciones${endColour}"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${endColour}${greyColour} Hay actualizaciones${endColour}"
      sleep 0.5
      tput civis
      echo -e "\n\t${greenColour}¿Querés actualizar?${endColour} ${greyColour}(y/n)${endColour}"
      while true; do
        read -n1 -s tecla
        if [[ $tecla == "y" ]]; then
          rm bundle.js && mv bundle_temp.js bundle.js
          echo -e "\n${greyColour}Jose Maria Listorti ;)${endColour}"
          break
        elif [[ $tecla == "n" ]]; then
          echo -e "\n ${greyColour}Trank sigue igual ;)${endColour}"
          break
        fi
      done
      tput cnorm
    fi
    tput cnorm
  fi
}

function searchMachine(){
  machineName="$1"
  
  machineName_checker="$(cat bundle.js | awk "/\"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"

  if [[ "$machineName_checker" ]]; then

    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Listando las propiedades de la maquina:${endColour} ${blueColour}$machineName${endColour}\n"
    echo "$machineName_checker"
  else
    echo -e "\n${redColour}[!] La maquina $machineName no existe"
  fi

}

function searchIP(){
  ipAdress="$1"
  
  machineIP="$(cat bundle.js | grep "\"$ipAdress\"" -B 3 | grep "name" | head -n 1 | awk 'NF{print$NF}' | tr -d '"' | tr -d ',')"

  if [[ "$machineIP" ]]; then 

    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}La maquina para la IP:${endColour} ${purpleColour}$ipAdress${endColour} ${greyColour}es:${endColour} ${blueColour}$machineIP${endColour}\n"
  else
    echo -e "\n${redColour}[!] La IP${endColour} ${greyColour}$ipAdress${endColour} ${redColour}no existe${endColour}"
  fi
}

function getYoutubeLink(){
  machineName=$1

  youtubeLink=$(cat bundle.js | awk "/\"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "youtube" | awk 'NF{print$NF}')

  if [[ "$youtubeLink" ]]; then
    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}El tutorial de la maquina${endColour} ${purpleColour}$machineName${endColour} ${greyColour}esta en el siguiente enlace:${endColour} ${blueColour}$youtubeLink${endColour}"
  else
    echo -e "\n${redColour}[!] La maquina $machineName no existe"
  fi
}

function getMachineDifficulty(){ 
  difficulty="$1" 
  results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5| grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)" 
  if [ "$results_check" ]; then 
    if [ "$difficulty" == "Fácil" ]; then 
      color="${blueColour}" 
    elif [ "$difficulty" == "Media" ]; then 
      color="${greenColour}" 
    elif [ "$difficulty" == "Difícil" ]; then 
      color="${purpleColour}" 
    elif [ "$difficulty" == "Insane" ]; then 
      color="${redColour}" 
    else color="${endColour}" 
    fi 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Reprensentado las máquinas que poseen un nivel de dificultad${endColour}${blueColour} $difficulty${endColour}${grayColour}:${endColour}\n" 
    echo -e "${color}$results_check${endColour}\n" 
  else 
    echo -e "\n${redColour}[!] La dificultad indicada no existe${endColour}\n" 
  fi 
}

function getOSMachines(){
  os=$1

  os_results="$(cat bundle.js | grep "so: \"$os\"" -B4 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column)"

  if [[ "$os_results" ]]; then
    echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Listando las maquinas del SO:${endColour} ${blueColour}$os${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -B4 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] El sistema operativo indicado no existe${endColour}\n"
  fi
}

function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"

  results_check="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column)"

  if [[ "$results_check" ]]; then
    echo -e "\n ${yellowColour}[+]${endColour} ${greyColour}Listando máquinas de dificultad:${endColour} ${blueColour}$difficulty${endColour} ${greyColour}y que tengan SO:${endColour} ${purpleColour}$os${endColour}"
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] Se ha indicado incorrectamente algún parámetro${endColour}"
  fi
}

function getSkill(){
  skills=("$@")

  results_check=$(cat bundle.js)
  for skill in "${skills[@]}"; do
    results_check=$(echo "$results_check" | grep -i "$skill" -B 6)
  done

  if [[ -n "$results_check" ]]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que poseen las Skills:${endColour}${blueColour} ${skills[*]} ${endColour}\n"
    echo "$results_check" | grep "name: " | tr -d '"' | tr -d ',' | awk 'NF{print $NF}' | sort | column
  else
    echo -e "\n${redColour}[!] No existen máquinas con esas Skills${endColour}"
  fi
}


#Indicadores
declare -i parameter_counter=0

#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:h" arg; do
  case $arg in
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAdress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
    o) os="$OPTARG"; chivato_os=1; let parameter_counter+=6;;
    s) IFS=' ' read -r -a skill_array <<< "${OPTARG}"; let parameter_counter+=7;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAdress
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines $os
elif [ $parameter_counter -eq 7 ]; then
  getSkill "${skill_array[@]}"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getOSDifficultyMachines $difficulty $os
else
  helpPanel
fi
