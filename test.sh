#!/bin/bash
function tildes {
	palabra=$1
	sinTildes=${palabra/á/a}	
	sinTildes=${sinTildes/é/e};
	sinTildes=${sinTildes/í/i};
	sinTildes=${sinTildes/ó/o};
	sinTildes=${sinTildes/ú/u};	
	echo $sinTildes
}


function letra {
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
test=$(letra q)
echo $test


function consultar_diccionario () {
	letraInicial=aá
	letraFinal=aá
	letraContenida=oó
	
	letraContenidaT=${letraContenida:1:1}
	letraContenidaST=${letraContenida:0:1}
	
	## Chequear letras != 0
	
	##Contadores
	cantidadPalabras=0
	palabrasTotales=0
	
	## Write an remove
	rm test2.txt
	output=test2.txt
	echo "" >> test2.txt
	echo "" >> test2.txt
	
	

	## Lee linea a linea
	while IFS= read line; 
		do
			if [ ${#line} -ge 3 ]; 
			then
			
			
			largo=$((${#line})) ## $(()) deja operar $(#a) largo de a 
			

			# subStrings -> Palabra
				inicial=${line:0:1}
				final=${line:largo-1:largo}	
				contenida=${line:1:-1} 
				


			# Validaciones necesarias
			if [[ $letraInicial =~ $inicial ]] && [[ $letraFinal =~ $final ]] && ([[ $contenida =~ $letraContenidaST ]] || [[ $contenida =~ $letraContenidaT ]]) ; 
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
	sed -i '1s/^/'"$porcentaje% de las palabras coinciden."'\n/' test2.txt
	sed -i '1s/^/'"Total de palabras analizadas: $palabrasTotales"'\n/' test2.txt
	sed -i '1s/^/'"$(date +%F)"'\n/' test2.txt
	sed -i '1s/^/'"$usuario"'\n/' test2.txt
	
	
}


 


