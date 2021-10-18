#!/bin/bash
if [ ! $# -eq 2 ]
then
	echo "Uso $0 <diretorio origem> <diretorio destino>"
elif [ ! -d $1 ]
then
	echo diretorio de origem nao encontrado: "$1"
	echo "Encerrando execução"
else
	echo "Sincronização iniciada"
	if  [ ! -e "$2" ] || [ ! -d "$2" ]; then
		mkdir $2 &
		while ! test -d $2; do
			echo "*"
			sleep 1
		done
	fi
	ls $1 >> sync.txt
	FILES="$1/*"
	for F in $FILES; do
		OTHER="$2/${F##*/}"
		TIPO=$([ -d "$F" ] && echo "diretorio" || echo "arquivo")
		if [ -e "$OTHER" ]; then
			if [ "$F" -ot "$OTHER" ]; then
				echo "Ignorando $TIPO $F"
			elif [ "$F" -nt "$OTHER" ]; then
				echo "Atualizando $TIPO $F"
				[ -d "$F" ] && cp -Rf "$F" "$OTHER"  || cp -f "$F" "$OTHER"
			fi
		else
			echo "Criando $TIPO $OTHER"
			[ -d "$F" ] && cp -Rf "$F" "$OTHER" || cp -f "$F" "$OTHER"
		fi
	done
	rm sync.txt
	echo "Sincronizacao encerrada"
	exit 0
fi
