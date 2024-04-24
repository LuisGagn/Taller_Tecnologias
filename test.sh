#!/bin/bash
line=a
inicial=${line:0:1}
final=${line:0-1}	# Si usamos "-1" solo o :0:-1 devuelve toda la linea. es importante usar " -1" o "0-1" 

echo $final $inicial