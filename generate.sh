#!/bin/sh


# add padding to text file: two spaces to the beginning and to the end of every line
pad() {
  sed -i -e 's/$/  /; s/^/  /;' $1
}

# generate 3 text logo versions from a 1008x1008 png file
generate() {
  outputdir=textlogos/${1}
  mkdir -p ${outputdir}
  originalpng=pngs/${1}.png

  bm2uns -c28x56 -p232 $originalpng > $outputdir/${1}_high.txt
  pad $outputdir/${1}_high.txt

  # make a 72x72 pixelated version with bm2uns
  convert $originalpng -resize 72x72 ${1}_72x72.png
  bm2uns -c2x4 -p232 ${1}_72x72.png > $outputdir/${1}_72x72.txt
  pad $outputdir/${1}_72x72.txt
  rm ${1}_72x72.png

  # make a 36x36 pixelated version with gotermimg
  convert $originalpng -resize 36x36 ${1}_36x36.png
  gotermimg -u ${1}_36x36.png > $outputdir/${1}_36x36.txt
  pad $outputdir/${1}_36x36.txt
  rm ${1}_36x36.png
}

if [[ -d $1 ]]; then
  files=${1%/}/*
  for file in $files
  do
    echo "Processing $file file..."
    filename=$(basename "$file")
    filenamebase="${filename%.*}"
    echo $filenamebase
    generate $filenamebase
  done
elif [[ -f $1 ]]; then
    echo "$1 is a file"
else
    echo "$1 is not valid"
    exit 1
fi

