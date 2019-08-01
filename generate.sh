rm -rf output_svg_tiles
mkdir output_svg_tiles

SQUARE_SIZE=2000

# Setup black square
inkscape input_svg_tiles/x.svg --export-png=output_svg_tiles/x.png -w${SQUARE_SIZE} -h${SQUARE_SIZE}
convert -background white -alpha remove -alpha off output_svg_tiles/x.png output_svg_tiles/x.bmp
potrace -s output_svg_tiles/x.bmp

# Setup white square
cp input_svg_tiles/z.svg output_svg_tiles/z.svg

# Process
for PIECE in "p" "r" "n" "b" "q" "k" "o" "t" "m" "v" "w" "l"
do
	white_square_piece=$(echo "${PIECE}" | tr '[:lower:]' '[:upper:]')
	black_square_piece=$(echo "${PIECE}" | tr '[:upper:]' '[:lower:]')

	# Piece SVG to PNG
	inkscape input_svg_tiles/${PIECE}.svg --export-png=output_svg_tiles/${white_square_piece}.png -w${SQUARE_SIZE} -h${SQUARE_SIZE}
	convert output_svg_tiles/${white_square_piece}.png output_svg_tiles/${white_square_piece}.bmp

	# Create black square pieces
	convert output_svg_tiles/x.bmp output_svg_tiles/${white_square_piece}.png -gravity center -compose over -composite output_svg_tiles/${black_square_piece}.bmp

	# Remove alpha from white square pieces
	convert -background white -alpha remove -alpha off output_svg_tiles/${white_square_piece}.png output_svg_tiles/${white_square_piece}.bmp

	# Trace the image
	potrace -s output_svg_tiles/${white_square_piece}.bmp
	potrace -s output_svg_tiles/${black_square_piece}.bmp
done

# Minify the SVG
svgo output_svg_tiles/*.svg

# Remove the temp files
rm output_svg_tiles/*.bmp output_svg_tiles/*.png
