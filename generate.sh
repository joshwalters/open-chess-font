rm -rf output_svg_tiles
mkdir output_svg_tiles

# Setup black square
inkscape input_svg_tiles/b.svg --export-png=output_svg_tiles/b.png -w2000 -h2000
convert -background white -alpha remove -alpha off output_svg_tiles/b.png output_svg_tiles/b.bmp
potrace -s output_svg_tiles/b.bmp

# Setup white square
cp input_svg_tiles/w.svg output_svg_tiles/w.svg

# Process
for VAR in "bp" "br" "bn" "bb" "bq" "bk" "wp" "wr" "wn" "wb" "wq" "wk"
do
	# Piece SVG to PNG
	inkscape input_svg_tiles/${VAR}.svg --export-png=output_svg_tiles/${VAR}w.png -w2000 -h2000
	convert output_svg_tiles/${VAR}w.png output_svg_tiles/${VAR}w.bmp

	# Create black square pieces
	convert output_svg_tiles/b.bmp output_svg_tiles/${VAR}w.png -gravity center -compose over -composite output_svg_tiles/${VAR}b.bmp

	# Remove alpha from white square pieces
	convert -background white -alpha remove -alpha off output_svg_tiles/${VAR}w.png output_svg_tiles/${VAR}w.bmp

	# Trace the image
	potrace -s output_svg_tiles/${VAR}w.bmp
	potrace -s output_svg_tiles/${VAR}b.bmp
done

# Minify the SVG
svgo output_svg_tiles/*.svg

# Remove the temp files
rm output_svg_tiles/*.bmp output_svg_tiles/*.png
