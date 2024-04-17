# explicit_figures

A Pandoc filter to explicitly create figures.

Pandoc's `implicit_figures` extension is problematic, because it massively overloads the image syntax and can easily produce unexpected results.  The documentation notes:

> If you just want a regular inline image, just make sure it is not the only thing in the paragraph.  One way to do this is to insert a nonbreaking space after the image:
>
> `![This image won't be a figure](/url/of/image.png)\`

A trailing backslash is far from obvious.  In my opinion, it’s preferable to _explicitly_ create figures when you want them.

This filter turns Divs with the class `figure` into Figure AST elements.

Paragraphs following the image are treated as the caption.  For example:

``` markdown
::: figure
![](graphics/regex-03.pdf)

An example of a finite automaton.
:::
```

If the metadata value `use_short_captions` is set to `true`, and if there are several paragraphs, the content of the first paragraph will be used as “short” caption (which is used, e.g., by \LaTeX{} in the list of figures).

© 2024 by Michael Piotrowski <mxp@dynalabs.de>
