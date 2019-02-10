#!/bin/bash

NAME="$1"
TYPE="$2"

mkdir $NAME
mkdir $NAME/gen
touch $NAME/README.md

echo "PREFIX=${NAME}-" > $NAME/Makefile


case $TYPE in

    text)
        cat >>$NAME/Makefile <<EOF
FILES_TO_LIST=lyrics.txt

gen/\${PREFIX}lyrics.txt: lyrics.txt
	cp lyrics.txt gen/\${PREFIX}lyrics.txt
EOF
        touch $NAME/lyrics.txt
        ;;
    
    ugc)
        cat >>$NAME/Makefile <<EOF
FILES_TO_LIST=lyrics.txt chord-sheet.cho chord-sheet.pdf 

gen/\${PREFIX}lyrics.txt: chord-sheet.ugc
	../scripts/parse_ugc.py chord-sheet.ugc --lyrics > gen/\${PREFIX}lyrics.txt
EOF
        touch $NAME/chord-sheet.ugc
        ;;
    
    cho)
        cat >>$NAME/Makefile <<EOF
FILES_TO_LIST=chord-sheet.pdf chord-sheet-2col.pdf lyrics.txt

gen/\${PREFIX}lyrics.txt: chord-sheet.cho
	../scripts/chordpro-to-lyrics.sh chord-sheet.cho > gen/\${PREFIX}lyrics.txt
EOF
        touch $NAME/chord-sheet.cho
        ;;


    ly)
        cat >>$NAME/Makefile <<EOF
FILES_TO_LIST=lyrics.txt sheet-music.pdf voice-part.pdf cello-part.pdf sheet-music-compact.pdf from-midi.mp3

gen/\${PREFIX}lyrics.txt: sheet-music.ly
	../scripts/ly-to-lyrics.py sheet-music.ly gen/\${PREFIX}lyrics.txt
EOF
        touch $NAME/sheet-music.ly
        ;;

    *)
        echo "Unrecognized format '$TYPE', can be text, ugc, cho or ly"
        ;;

esac

echo 'include ../scripts/Makefile.common' >>$NAME/Makefile

cd $NAME
make all
git add * gen/*
cd ..