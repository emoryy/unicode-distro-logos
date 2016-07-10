#!/bin/sh


# add padding to text file: two spaces to the beginning and to the end of every line
pad() {
  sed -i -e 's/^/  /; s/$/  /;' $1
}

# generate 3 text logo versions from a 1008x1008 png file
generate() {
  echo "Processing $1 file..."
  filename=$(basename "$1")
  filenamebase="${filename%.*}"
  outputdir="textlogos/${filenamebase}"
  mkdir -p ${outputdir}
  originalpng="pngs/${filenamebase}.png"

  bm2uns -c28x56 -p232 $originalpng > $outputdir/${filenamebase}_high.txt
  pad $outputdir/${filenamebase}_high.txt

  # make a 72x72 pixelated version with bm2uns
  convert $originalpng -resize 72x72 ${filenamebase}_72x72.png
  bm2uns -c2x4 -p232 ${filenamebase}_72x72.png > $outputdir/${filenamebase}_72x72.txt
  pad $outputdir/${filenamebase}_72x72.txt
  rm ${filenamebase}_72x72.png

  # make a 36x36 pixelated version with gotermimg
  convert $originalpng -resize 36x36 ${filenamebase}_36x36.png
  gotermimg -u ${filenamebase}_36x36.png > $outputdir/${filenamebase}_36x36.txt
  pad $outputdir/${filenamebase}_36x36.txt
  rm ${filenamebase}_36x36.png
}

if [[ -d $1 ]]; then
  files=${1%/}/*
  for file in $files
  do
    generate $file
  done
elif [[ -f $1 ]]; then
    generate $1
else
    echo "$1 is not valid"
    exit 1
fi

