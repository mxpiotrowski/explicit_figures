# explicit_figures

A Pandoc filter to explicitly create figures.

I find Pandoc's `implicit_figures` extension, because it massively overloads the image syntax and can easily produce unexpected results.  The documentation notes:

> If you just want a regular inline image, just make sure it is not the only thing in the paragraph.  One way to do this is to insert a nonbreaking space after the image:
>
> `![This image won't be a figure](/url/of/image.png)\`

A trailing backslash is far from obvious, but its presence or absence will make a huge difference.  In my opinion, it’s preferable to _explicitly_ create figures when you want them.

This filter turns Divs with the class `figure` into Figure AST elements.

The filter assumes that the first element in the Div is an Image.  Paragraphs following the Image are treated as the caption.  For example:

``` markdown
::: figure
![](graphics/regex-03.pdf)

An example of a finite automaton.
:::
```

You’ll typically want to assign IDs to figures and use [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref) to refererence them.  Since figures are simply Divs, you can do this in the usual way (see the [Pandoc User’s Guide](https://pandoc.org/MANUAL.html#divs-and-spans) for more information).  For example:

``` markdown
::: {.figure #fig:automaton}
![](graphics/regex-03.pdf)

An example of a finite automaton.
:::
```

With pandoc-crossref you’d then refer to this figure like:

``` markdown
… just a finite automaton (see [@fig:automaton]) …
```

See the [pandoc-crossref documentation](https://lierdakil.github.io/pandoc-crossref/) for details.

⚠ Make sure you turn off the `implicit_figures` extension (see the [Pandoc User’s Guide](https://pandoc.org/MANUAL.html#extensions)).

The filter currently has one configuration setting:

If the metadata field `explicit_figures.short_captions` is set to `true`, and if there are several paragraphs following the image, the content of the first paragraph will be used as “short” caption (which is used, e.g., by LaTeX in the list of figures).

You can set this option in the YAML header or a separate metadata file like this:

``` yaml
explicit_figures:
    short_captions: true
```

or like this

``` yaml
explicit_figures: {short_captions: true}
```

-------------------------------------------------------------------------------



© 2024 by Michael Piotrowski <mxp@dynalabs.de>
