#!/bin/bash


letraInicial=0
letraFinal=0
letraContenida=0

	
	
function letra_inicial { 
	echo "Ingrese la letra inicial"
	echo "Si desea salir presione 0"
	read letra 
	if [ $letra != 0 ]; then 
		letraInicial=${letra,,}
		echo "La letra inicial sera $letraInicial"
		echo $letraInicial
	fi
}

function letra_contenida { 
	echo "Ingrese la letra contenida"
	echo "Si desea salir presione 0"
	
	read letra 
	if [ $letra != 0 ]; then 
		letraContenida=${letra,,}
		echo "La letra contenida sera $letraContenida"
	fi
}

function letra_final { 
	echo "Ingrese la letra final"
	echo "Si desea salir presione 0"
	
	read letra 
	if [ $letra != 0 ]; then 
		letraFinal=${letra,,}
		echo "La letra final sera $letraFinal"
		echo $letraFinal
	fi
}

function tildes {
	palabra=$1
	sinTildes=${palabra/á/a}	
	sinTildes=${sinTildes/á/a};
	sinTildes=${sinTildes/é/e};
	sinTildes=${sinTildes/í/i};
	sinTildes=${sinTildes/ó/o};
	sinTildes=${sinTildes/ú/u};	
	echo $sinTildes
}




function consultar_diccionario () {
	letraInicial=a
	letraFinal=o
	letraContenida=a
	## Chequear letras != 0
	
	##Contadores
	cantidadPalabras=0
	palabrasTotales=0
	
	
	## Write an remove
	rm test2.txt
	output=test2.txt
	fecha=$(date +%F)
	
	
	echo " " >> $output
	echo " " >> $output
	echo $fecha >> $output
	
	## Lee linea a linea
	while IFS= read -r line
		do
		
		
		palabra=$(tildes $line) 
			
		largo=$((${#palabra})) ## $(()) deja restar $(#a) largo de a 

		inicial=${palabra:0:1}
		final=${palabra:largo-1:largo}	
		contenida=${palabra:1:largo-2}
		
		if [ $inicial == $letraInicial ] && [ $final == $letraFinal ]; 
		then

			if [[ $contenida =~ $letraContenida ]]; 
			then 
				cantidadPalabras=$((cantidadPalabras+1))
				echo $line >> $output
			fi
		fi
		palabrasTotales=$((palabrasTotales+1))
	done < test.txt
	
	
	porcentaje=$((cantidadPalabras*100/palabrasTotales))

	
	echo "Un $porcentaje % de las palabras $(cat test2.txt)" > test2.txt
	echo "Total de palabras: $palabrasTotales $(cat test2.txt)" > test2.txt
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


