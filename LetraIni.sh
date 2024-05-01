#!/bin/bash

# Valores Iniciales
letraInicial=0
letraFinal=0
letraContenida=0
usuario=Luis #Motivos de test.


rojo="\033[1;31m"
reiniciar="\033[0m"
# Funciona perfectamente
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


letra_inicial() { 
	echo "\nIngrese la letra inicial"
	echo "Si desea salir presione 0\n"
	read -p "Ingrese letra > " letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
            clear
			letraInicial=$(echo "$letra" | tr '[:upper:]' '[:lower:]')
            echo "La letra inicial sera $letraInicial"
			letraInicial=$(tildes $letra) 
		else 
            clear
			echo "$rojo""Ingrese una sola letra""$reiniciar"
			letra_inicial
		fi
	fi
}
letra_contenida() { 
	echo "\nIngrese la letra contenida"
	echo "Si desea salir presione 0\n"
	read -p "Ingrese letra > " letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
            clear
			letraContenida=$(echo "$letra" | tr '[:upper:]' '[:lower:]')
            echo "La letra contenida sera $letraContenida"
			letraContenida=$(tildes $letra) 
		else 
            clear
			echo "$rojo""Ingrese una sola letra""$reiniciar"
			letra_contenida
		fi
	fi
}
letra_final() { 
	echo "\nIngrese la letra final"
	echo "Si desea salir presione 0\n"
	read -p "Ingrese letra > " letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
            clear
			letraFinal=$(echo "$letra" | tr '[:upper:]' '[:lower:]')
            echo "La letra inicial sera $letraFinal"
			letraFinal=$(tildes $letra) 
		else 
            clear
			echo "$rojo""Ingrese una sola letra""$reiniciar"
			letra_final
		fi
	fi
}
salida() {
		if [ -e "$1" ];
		then
			echo Sobreescribiendo $1
			rm "$1"
			echo "" >> $1 # Inicializa el archivo output.
		else
			echo "Generando archivo $1"
			echo "" >> $1 # Inicializa el archivo output.
		fi
}
consultar_diccionario () {
	## Valida que se hayan ingresado las 3 letras.
	if [ $letraInicial = 0 ] || 
	[ $letraFinal = 0 ] ||
	[ $letraContenida = 0 ]; 
	then
	echo "Verifique que todas las letras hayan sido escogidas.
		 Letra Inicial: $(echo "$letraInicial" | cut -c2)
		 Letra Contenida: $(echo "$letraContenida" | cut -c2)
		 Letra Final: $(echo "$letraFinal" | cut -c2)
		"
	return

	else 

# Archivo de salida de resultados
		archivoSalida=resultados.txt
		salida $archivoSalida

		patron="^$letraInicial.*$letraContenida.*$letraFinal$"
		iconv -f ISO-8859-1 -t UTF-8 diccionario.txt | 			# Reformatea el diccionario ya que esta en una codificacion que causa problemas con los tildes
		awk '{print $1}' |										# Elimina Verbo u otras palabras
		grep "${patron}" > resultados.txt 						# SI CONTENIDA ES DENTRO DE ULTIMA Y PRIMERA
		#grep "^$letraInicial.*$letraFinal$" | 
		#grep "$letraContenida" > resultados.txt 				# SI CONTENIDA ES EN TODA LA PALABRA
	fi



	# CABEZAL
	cantPalabrasValidas=$(wc -l "$archivoSalida" | awk '{print $1}')	# Cuenta lineas de resultados.txt
	cantPalabrasTotales=$(grep -c '.' "diccionario.txt") 	# Evita contar las lineas en blanco que son 4.
	
	porcentaje=$(echo "scale=2 ; (($cantPalabrasValidas*100)/$cantPalabrasTotales)" | bc)
	cabezal="Usuario registrado : $usuario\n$(date +"Generado el: %F a las %T")\nTotal de palabras analizadas: $cantPalabrasTotales\nTotal de palabras validas: $cantPalabrasValidas\n0$porcentaje% de las palabras coinciden.\n"
	
	
	if [ "$cantPalabrasValidas" = 0 ]; 
	then 
		echo "No se encontraron palabras validas para la combinacion:
			\n 
			Letra Inicial: $(echo "$letraInicial" | cut -c2)
			Letra Contenida: $(echo "$letraContenida" | cut -c2)
			Letra Final: $(echo "$letraFinal" | cut -c2)
			\n
			Pruebe con otra combinacion."	
		echo " " > $archivoSalida 

	else 
		echo "Resultados guardados en archivo "$archivoSalida""
	fi
		sed -i "1i\\$cabezal" $archivoSalida
}


