#!/bin/bash
tildes() {
	vocales=aeiou
	if echo "$vocales" | grep -q "$1";
	then 
		case "$1" in 
		"a") echo "[aá]"
		;;
		"e") echo "[eé]"
		;;
		"i") echo "[ií]"
		;;
		"o") echo "[oó]"
		;;
		"u") echo "[uúü]"
		;;
		esac
	else 
		echo "[$1]"
	fi
}

rojo="\033[1;31m"
reiniciar="\033[0m"

letras () {
if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
            clear
			letraRes=$(echo "$2" | tr '[:upper:]' '[:lower:]')
            echo "La letra $1 sera $letraRes"
			letraRes=$(tildes $2) 
            echo $letraRes
		else 
            clear
			echo "$rojo""Ingrese una sola letra""$reiniciar"
			letra_$1
		fi
	fi
}

letra_inicial() { 
	echo "\nIngrese la letra inicial"
	echo "Si desea salir presione 0\n"
	read -p "Ingrese letra > " letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	letraInicial=$(letras inicial $letra)
}


letra_inicial 

echo $letraInicial