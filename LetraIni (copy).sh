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

	reescribir
	##Contadores
	cantidadPalabras=0
	palabrasTotales=0


	# Archivo auxiliar | Ver si puede cambiarse por una variable.
	auxiliar=auxiliar.txt
	if [ -e "$auxiliar" ];
	then
		rm "$auxiliar"	
	fi

	
	if [ -e "$output" ];
	then
		echo Sobreescribiendo $output
		rm "$output"
	else
		echo "Generando archivo $output"
	fi
	
	start=$(date +%s.%N) #IGNORAR benchmarking

	## Lee linea a linea
	while IFS= read line; 
		do
			# Si hay palabras de 1 o 2 caracteres
			# o strings en blanco los ignora.
			## $(()) permite realizar operaciones 
			# ${#a} devuelve largo de a 
			largo=$((${#line})) 				

			if [ $largo -ge 3 ]; 
			then
				# Al existir palabras como "autentica verbo"
				# en el diccionario es necesario borrar "verbo" 
				# ya que nos dara resultados erroneos.
				if [[ $line =~ ' ' ]]; 
				then
					line=$(echo $line | cut -d' ' -f1)
				fi
			
			# subStrings -> Palabra
				inicial=${line:0:1}
				contenida=${line:1:-1} 
				final=${line:0-1}	# Si usamos "-1" solo o :0:-1 devuelve toda la linea. es importante usar " -1" o "0-1" 

			# Realiza varios checks
			# la funcion [[ $a =~ $b ]] 
			# revisa si en $a existe el string $b
			if [[ $letraInicial =~ $inicial ]] && 
			[[ $letraFinal =~ $final ]] && 
			[[ $contenida =~ $letraContenida ]] 
			then
				#Escribe palabra y suma
				cantidadPalabras=$((cantidadPalabras+1))
				echo $line >> $auxiliar
				fi
			fi
		
			palabrasTotales=$((palabrasTotales+1))
		done < diccionario.txt
	
	# Header del documento
	porcentaje=$(bc <<< "scale=2;($cantidadPalabras*100)/$palabrasTotales")
	header="Usuario : $usuario\n$(date +%F)\nTotal de palabras analizadas: $palabrasTotales\nTotal de palabras validas: $cantidadPalabras\n0$porcentaje% de las palabras coinciden.\n"
	
	if [ $cantidadPalabras != 0 ]; 
	then 
#	sed -i "1i\\$header" $auxiliar
	# Por algun motivo algunas palabras al realizar echo $line >> $auxiliar las ingresa en el mismo renglon
	# Esta funcion awk busca rapidamente todos los campos que tengan exactamente 2 palabras (Maximo ocurrente) 
	# y reingresa en ese orden dentro del documento a la segunda palabra en una fila nueva
	awk 'NF==2 {print $1"\n"$2} NF!=2' $auxiliar > $output
	rm $auxiliar
	
	else 
	echo "" >> $output	

	echo "No existen palabras para la combinacion:		
		Letra Inicial: ${letraInicial:1:1}
		Letra Contenida: ${letraContenida:1:1}
		Letra Final: ${letraFinal:1:1}
		Pruebe con otra combinacion"
	fi
	sed -i "1i\\$header" $output

# runtime IGNORAR benchmarking.
end=$(date +%s.%N)
runtime=$(echo "$end - $start" | bc)

echo "Finalizado en $runtime segundos"
	
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


