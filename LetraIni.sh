#!/bin/bash


letraInicial=0
letraFinal=0
letraContenida=0
usuario=Luis
	
function tildes {
	# Declara un array asociativo ([a]=aá) (Por eso -A)
	declare -A letras
	letras=([a]=aá [e]=eé [i]=ií [o]=oó [u]=uú)
	vocales=aeiouAEIOU
	if [[ $vocales =~ $1 ]];
	then 
		echo ${letras[$1]} 
	else 
		echo $1$1
	fi
}
	
function letra_inicial { 
	echo "Ingrese la letra inicial"
	echo "Si desea salir presione 0"
	read letra 
	
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
	
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
			letraContenida=${letra,,}
			echo "La letra Final sera $letraContenida"
			letraContenida=$(tildes $letra) 
		else 
			echo "Ingrese una sola letra"
			letra_inicial
		fi
	fi
}

function letra_final { 
	echo "Ingrese la letra final"
	echo "Si desea salir presione 0"
	read letra 
	
	if [ $letra != 0 ]; then 
		if [ ${#letra} -le 1 ]; then
			letraFinal=${letra,,}
			echo "La letra inicial sera $letraFinal"
			letraFinal=$(tildes $letra) 
		else 
			echo "Ingrese una sola letra"
			letra_inicial
		fi
	fi
}

function consultar_diccionario () {
	# Como para tomar los tildes guardamos aá 
	# y no hay un string aá en las palabras
	# como queremos ver si tiene a o á 
	# la dividimos en 2 letras.
	letraContenidaT=${letraContenida:1:1}
	letraContenidaST=${letraContenida:0:1}
	
	## Chequear letras != 0
	
	##Contadores
	cantidadPalabras=0
	palabrasTotales=0
	
	## Write an remove
	output=resultados.txt
	
	if [ -e "$output" ];
	then
		rm "$output"
		echo "Generando nuevo archivo"
	else
		echo "Generando archivo $output"
	fi
	
	echo "" >> $output
	echo "Lista de palabras encontradas" >> $output
	echo "_____________________________" >> $output
	echo "" >> $output
	

	## Lee linea a linea
	while IFS= read line; 
		do
			# Al existir palabras como "autentica verbo"
			# en el diccionario es necesario borrar "verbo" 
			# ya que nos dara resultados erroneos.
			if [[ $line =~ ' ' ]]; 
			then
				line=$(echo $line | cut -d' ' -f1)
			fi
			
			# Si hay palabras de 1 o 2 caracteres
			# o reonglones en blanco los ignora.
			if [ ${#line} -ge 3 ]; 
			then

			## $(()) deja operar $(#a) largo de a 
			largo=$((${#line})) 
			
			# subStrings -> Palabra
				inicial=${line:0:1}
				final=${line:largo-1:largo}	
				contenida=${line:1:-1} 

			# Realiza varios checks
			# la funcion [[ $a =~ $b ]] 
			# revisa si en $a existe el string $b
			if [[ $letraInicial =~ $inicial ]] && 
			[[ $letraFinal =~ $final ]] && 
			([[ $contenida =~ $letraContenidaST ]] || 
			[[ $contenida =~ $letraContenidaT ]]) ; 
			then
				#Escribe palabra y suma
				cantidadPalabras=$((cantidadPalabras+1))
				echo $line >> $output
				fi
			fi
		
			palabrasTotales=$((palabrasTotales+1))
		done < diccionario.txt
	
	
	
	# Header del documento
	porcentaje=$(bc <<< "scale=2;($cantidadPalabras*100)/$palabrasTotales")
	sed -i '1s/^/'"0$porcentaje% de las palabras coinciden."'\n/' $output
	sed -i '1s/^/'"Total de palabras analizadas: $palabrasTotales"'\n/' $output
	sed -i '1s/^/'"$(date +%F)"'\n/' $output
	sed -i '1s/^/'"Usuario: $usuario"'\n/' $output
	
	
	echo "Archivo guardado con nombre $output"
	
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


