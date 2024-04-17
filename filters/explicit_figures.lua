-- Time-stamp: <2024-04-17T18:49:24+0200 mpiotrow>

-- The implicit_figures option is dumb. This filter turns Divs with
-- the class "figure" into Figure AST elements.
-- 
-- Paragraphs following the image are treated as the caption.
-- 
-- If the metadata value "use_short_captions" is set to true, and if
-- there are several paragraphs, the content of the first paragraph
-- will be used as "short" caption (which is used by LaTeX output).

local use_short_captions = false
local figcount = 0

function get_options (meta)
   if meta.use_short_captions == true then
      use_short_captions = true
   end
end

function handle_divs (elem)
   if elem.classes:includes('figure') then

      local paras   = pandoc.List()
      local caption = pandoc.List()

      -- We assume that the Image is the first element in the Div
      for i, el in pairs(elem.content) do
         if (el.t == "Para" and #el.c >= 1 and el.c[1].t ~= "Image") then
            table.insert(paras, el)
         end
      end

      if use_short_captions == true and #paras > 1 then
         local n = 1

         caption['short'] = paras[1].c
         caption['long'] = paras:filter(
            function (item)
               if n > 1 then
                  return true
               end
               n = n + 1
         end)
      else
         caption = paras
      end
      
      if FORMAT:match 'ms' then
         -- Apparently the ms writer currently doesn't support
         -- captions on Figure elements. We therefore put the Figure
         -- element inside a floating keep (.KF/.KE), together with a
         -- rough approximation of a caption.

         -- [FIXME] The figure counter is a hack. We assume that there
         -- are no Figures in the AST (which is true as long as the
         -- only way to create them is with the implicit_figures
         -- option, and no other filters insert figures before us), so
         -- we can simply count the Divs with class "figure" as we
         -- process them.

         figcount = figcount + 1

         table.insert(paras[1].c, 1, 'Fig. ' .. figcount .. ': ')
         
         table.insert(paras, 1, pandoc.RawBlock('ms', '.KF'))
         table.insert(paras, 2, pandoc.Figure(elem.content[1], { }, { id = elem.identifier }))
         table.insert(paras, 3, pandoc.RawBlock('ms', '.QS'))
         table.insert(paras, pandoc.RawBlock('ms', '.QE'))
         table.insert(paras, pandoc.RawBlock('ms', '.KE'))
         return pandoc.Div(paras)
      else
         -- Replace the Div with a Figure element.
         
         -- Copy the attributes from the Div. We currently don't make
         -- any changes, but we could (we should probably remove the
         -- figure class).
         local new_attributes = pandoc.Attr()
         new_attributes.identifier = elem.identifier
         new_attributes.classes = elem.classes
         for k, v in pairs(elem.attr.attributes) do
            new_attributes.attributes[k] = v
         end
                  
         return pandoc.Figure(elem.content[1], caption, new_attributes)
      end
   else
      return nil -- leave the Div untouched
   end
end

return {{Meta = get_options}, {Div = handle_divs}}
