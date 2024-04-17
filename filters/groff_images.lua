-- A small filter for changing the file extension of images.

function Image (elem)
   -- groff can only include EPS (see groff_tmac(5) for details on
   -- .PSPIC).  So this is a bit sketchy, but something along these
   -- lines could work.  Ideally, images would be automatically
   -- converted to EPS if possible.

   if elem.src:find('%.jpg$') then
      return pandoc.RawInline('ms', '.PSPIC ' ..
                              elem.src:gsub('%.jpg$', '.eps') .. '\n')
   elseif elem.src:find('%.png$') then
      return pandoc.RawInline('ms', '.PSPIC ' ..
                              elem.src:gsub('%.png$', '.eps') .. '\n')
   -- PDF can be included in groff using .PDFPIC, but this requires
   -- passing the -U option to groff—maybe use an option to enable
   -- this?  There is a register \n[.U] to check for unsafe mode at
   -- compile time, but I don't manage to write a working macro.
   -- Anyway, if a PDF image is specified, we try to include it
   -- directly.
   elseif elem.src:find('%.pdf$') then
      return pandoc.RawInline('ms', '.PDFPIC ' .. elem.src .. '\n')
   else
      return nil
   end
end

