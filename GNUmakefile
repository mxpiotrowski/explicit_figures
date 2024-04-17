.PHONY: clean

%-latex.pdf: %.md filters/*.lua
	pandoc -s -f markdown-implicit_figures -t pdf -o $@ \
	-L filters/explicit_figures.lua \
	--pdf-engine=xelatex $<

%-ms.pdf: %.md filters/*.lua
	pandoc -s -f markdown-implicit_figures -t pdf -o $@ \
	-L filters/explicit_figures.lua -L filters/groff_images.lua \
	--pdf-engine=pdfroff --pdf-engine-opt=-dpaper=a4 \
	--pdf-engine-opt=-U --pdf-engine-opt=-P-pa4 $<

%.tex: %.md filters/*.lua
	pandoc -s -f markdown-implicit_figures -t latex -o $@ \
	-L filters/explicit_figures.lua \
	--pdf-engine=xelatex $<

%.ms: %.md filters/*.lua
	pandoc -s -f markdown-implicit_figures -t ms -o $@ \
	-L filters/explicit_figures.lua -L filters/groff_images.lua \
	--pdf-engine=pdfroff --pdf-engine-opt=-dpaper=a4 \
	--pdf-engine-opt=-U --pdf-engine-opt=-P-pa4 $<

%.html: %.md filters/*.lua
	pandoc -s -f markdown-implicit_figures -t html -o $@ \
	-L filters/explicit_figures.lua $<

clean:
	rm -f *~ test*.pdf test.{tex,ms,html}
