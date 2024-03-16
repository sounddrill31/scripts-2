#!/bin/bash


#gh auth login
#copying file in scripts folder
find out/target/product/*/ -type f -name "*.zip" ! -name "*ota*" ! -name "*eng*" -exec mv {} scripts/ \;

filename=$(ls *.zip)

# Create a tag and release using the filename (without .zip extension)
version=${filename%.zip}

git tag -a "$version" -m "Release $version"

#git push origin "$version"

gh release create "$version" "$filename" -t "Release $version" -n "Release notes"

