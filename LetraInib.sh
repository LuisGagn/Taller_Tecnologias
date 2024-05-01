#!/bin/bash

# Valores Iniciales
letraInicial=0
letraFinal=0
letraContenida=0
usuario=Luis #Motivos de test.
	
function tildes {
	# Declara un array asociativo ([a]=aá) (Por eso -A)
	# Al usar [xy] el programa lo evalua como un x OR y 
	declare -A letras
	letras=([a]=[aá] [e]=[eé] [i]=[ií] [o]=[oó] [u]=[uú])
	vocales=aeiou
	if [[ $vocales =~ $1 ]];
	then 
		echo ${letras[$1]} 
	else 
		echo "[$1$1]"
	fi
}

function letra_inicial { 
	echo "Ingrese la letra inicial"
	echo "Si desea salir presione 0"
	read -p "Ingrese letra: " letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
			letraInicial=${letra,,}
			echo "La letra inicial sera $letraInicial"
			letraInicial=$(tildes $letra) 
		else 
			echo "Ingrese una sola letra"
			letra_inicial
		fi
	fi
}

function letra_contenida { 
	echo "Ingrese la letra contenida"
	echo "Si desea salir presione 0"
	read letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
			letraContenida=${letra,,}
			echo "La letra contenida sera $letraContenida"
			letraContenida=$(tildes $letra) 
		else 
			echo "Ingrese una sola letra"
			letra_contenida
		fi
	fi
}

function letra_final { 
	echo "Ingrese la letra final"
	echo "Si desea salir presione 0"
	read letra 
	# Verifica si se ingresa 1 o mas letras. 
	# En caso de ingresar +1 realiza la recursion correspondiente.
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
			letraFinal=${letra,,}
			echo "La letra final sera $letraFinal"
			letraFinal=$(tildes $letra) 
		else 
			echo "Ingrese una sola letra"
			letra_final
		fi
	fi
}
# quitar
function reescribir () {
	echo "Desea crear un nuevo archivo o sobreescribir el original"
	echo "Archivo por defecto: resultados.txt"
	echo "1 - Crear archivo"
	echo "2 - Sobreescribir original"
	echo 

	read -p "Elija opcion correspondiente :" eleccion

	if [ $eleccion == 1 ]; 
	then 
	echo "Ingrese nombre de archivo sin extension"
	read archivo
	output="$archivo.txt"
	else
	output=resultados.txt
	fi
}
letraInicial=[á]
letraFinal=[aá]
letraContenida=[aá]
function consultar_diccionario () {

	## Valida que se hayan ingresado las 3 letras.
	if [ $letraInicial == 0 ] || 
	[ $letraFinal == 0 ] ||
	[ $letraContenida == 0 ]; 
	then
	echo "Verifique que todas las letras hayan sido escogidas.
		 Letra Inicial: ${letraInicial:1:1} 
		 Letra Contenida: ${letraContenida:1:1}
		 Letra Final: ${letraFinal:1:1}"
	return
	fi

	##Contadores
	cantidadPalabras=0
	palabrasTotales=0

# Archivo de salida de resultados
	output=resultados333.txt
	if [ -e "$output" ];
	then
		echo Sobreescribiendo $output
		rm "$output"
		echo "" >> $output # Inicializa el archivo output.
	else
		echo "Generando archivo $output"
		echo "" >> $output # Inicializa el archivo output.

	fi

	## Lee linea a linea del documento diccionario.txt
	while IFS= read linea; 
		do
			# Si hay strings en blanco los ignora.
			# ${#a} devuelve largo de a 
			largo=${#linea}			

			if [ $largo -ge 1 ]; 	#-ge (Greater or Equal than / Mayor o igual que) 
			then
				# Al existir palabras como "autentica verbo"
				# en el diccionario es necesario borrar "verbo" 
				# ya que nos dara resultados erroneos.
				if [[ $linea =~ ' ' ]]; 
				then
					linea=$(echo $linea | cut -d' ' -f1)		# De las lineas con mas de un campo(field) toma el f1 (field 1)
				fi
			
			# subStrings -> Palabra
				inicial=${linea:0:1} 	# Toma primer valor
				final=${linea:0-1}		# Si usamos "-1" solo o :0:-1 devuelve toda la linea. es importante usar " -1" o "0-1"
										# En casos de palabras con un solo caracter (a) toma solamente este caracter.

			# Realiza varios checks
			# la funcion [[ $a =~ $b ]] 
			# revisa si en $a existe el string $b
			if [[ $letraInicial =~ $inicial ]] && 
			[[ $letraFinal =~ $final ]] && 
			[[ $linea =~ $letraContenida ]] 
			then
				#Escribe palabra y suma al contador
				cantidadPalabras=$((cantidadPalabras+1))
				echo "$linea" >> $output 	# Agregar $linea entre "" realiza que se guarden los espacios y caracteres especiales
				fi							# Por algun motivo si la palabra terminaba en tilde, la siguiente no era separada.
			fi
		
			palabrasTotales=$((palabrasTotales+1))
		done < newfile2.txt
	
	# Cabezal del documento
	# Como bash no utiliza valores flotantes si no enteros, utilizamos bc <<< 
	# scale = 2 seria la cantidad de decimales y nos devuelve un valor tal que .99
	# Para mostrarlo bien se muestra 0$porcentaje% --> 0.99%
	porcentaje=$(bc <<< "scale=2;($cantidadPalabras*100)/$palabrasTotales")
	header="Usuario : $usuario\n$(date +%F)\nTotal de palabras analizadas: $palabrasTotales\nTotal de palabras validas: $cantidadPalabras\n0$porcentaje% de las palabras coinciden.\n"
	
	if [ $cantidadPalabras == 0 ]; 
	then 
	echo "No existen palabras para la combinacion:		
		Letra Inicial: ${letraInicial:1:1}
		Letra Contenida: ${letraContenida:1:1}
		Letra Final: ${letraFinal:1:1}
		Pruebe con otra combinacion"	
	fi
	# sed modifica textos, ahora el usar -i(insert) hace que modifique el texto que se le entrega y lo guarde e nves de mostrarlo.
	# \\ evita que el $ se tome como caracter y no se conjunte a header para ser variable (Que escriba lo que contiene header enves de "$header")
	# 1i significa que ingresara todas las lineas (i) en la primer posicion (1). 
	sed -i "1i\\$header" $output # Agrega cabezal.

	echo "Resultados salvados en documento : $output"
}















PS3='Seleccionar opcion> '
options=("Letra Inicial" "Letra Medio" "Letra Final" "Consultar diccionario" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Letra Inicial")
            letra_inicial 
            ;;
        "Letra Medio")
            letra_contenida
            ;;
        "Letra Final")
            letra_final
            ;;
        "Consultar diccionario")
		consultar_diccionario
        	;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


