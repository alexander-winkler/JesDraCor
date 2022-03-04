#Convert and enrich dramas from the Camena-Collection

Use source files in folder `sources/CAMENA`
Copy the file you want to edit to folder `tei` (only this folder will be moved to DraCor)
Please commit after this step so that the changes made to the original camena file are tracked
Get the DraCor framework and un transformation scenarios "CAMENA TEI 2 DraCor" and "generate ParticDesc from who-attributes" (the second transformation scenario will only work, it there are already `<sp>` tags with `@who` attributes; this is not the case in all the camena source files)
If the speaker labels are present in the spoken text `<l>` and follow the pattern `([A-Z]{3}[A-Z]?\.)\s` you can use the Find & replace function of Oxygen to automatically tag them: Tick the box Regex in the search box, add the Regular Expression `([A-Z]{3}[A-Z]?\.)\s` in the search field and restrict the search to the Element `l` (the 3rd input field). Test with  find all. If the results are satisfactory, you can now replace all with `<speaker>\1</speaker>`.
After you have tagged the speaker labels, you can run the xslt "camena_move_tagged_speaker_labels.xsl" which will move the label from the line to the `<sp>` element
Connect the characters `<person>` in the `<particDesc>` to the `<sp>` elements (a manual step..) 
cleanup the metadata in the `<teiHeader>` -... should actually be one of the first steps

