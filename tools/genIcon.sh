#!/bin/sh

filename="$1"
echo $filename

dirname="image"

filename_array=(
    "Icon-1024.png" "1024"
    "Icon-20.png" "20"
    "Icon-20@2x.png" "40"
    "Icon-20@3x.png" "60"
    "Icon-29.png" "29"
    "Icon-29@2x.png" "58"
    "Icon-29@3x.png" "87"
    "Icon-40.png" "40"
    "Icon-40@2x.png" "80"
    "Icon-40@3x.png" "120"
    "Icon-60@2x.png" "120"
    "Icon-60@3x.png" "180"
    "Icon-72.png" "72"
    "Icon-72@2x.png" "144"
    "Icon-76.png" "76"
    "Icon-76@2x.png" "152"
    "Icon-83_5.png" "83.5"
    "Icon-83_5@2x.png" "167"
    "Icon-ad32.png" "32"
    "Icon-ad48.png" "48"
    "Icon-ad72.png" "72"
    "Icon-ad96.png" "96"
    "Icon-ad144.png" "144"
    "Icon-Small@2x.png" "58"
    "Icon-Small@3x.png" "87"
    "Icon-Small20.png" "20"
    "Icon-Small20@2x.png" "40"
    "Icon-Small20@3x.png" "60"
    "Icon-Spotlight-iOS7@2x.png" "80"
    "Icon-Spotlight-iOS7@3x.png" "120"
    "Icon-Spotlight.png" "50"
    "Icon-Spotlight@2x.png" "100"
    "Icon.png" "57"
    "Icon@2x.png" "114"
)

mkdir $dirname

for ((i=0;i<${#filename_array[@]};i+=2)); do
    mkdir $dirname
    m_dir=$dirname/${filename_array[i]}

    cp $filename $m_dir
    sips -Z ${filename_array[i+1]} $m_dir

done
