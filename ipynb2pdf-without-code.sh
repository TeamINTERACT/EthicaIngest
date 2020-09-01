#!/bin/bash

infile=$1

# This will export the notebook and suppress all input code from
# the PDF

# This works, but it's all or nothing
#jupyter nbconvert EthicaTelemetryInvestigationPart2.ipynb --to=pdf --TemplateExporter.exclude_input=True

# This works for removing entire cells
# jupyter nbconvert EthicaTelemetryInvestigationPart2.ipynb --to=pdf --TagRemovePreprocessor.remove_cell_tags='{"hide_cell",}'

# This works, hides cell inputs but still shows the outputs
# jupyter nbconvert EthicaTelemetryInvestigationPart2.ipynb --to=pdf --TagRemovePreprocessor.remove_input_tags='{"hide_input"}'

# This works too, hides all outputs but leaves the code visible
# jupyter nbconvert EthicaTelemetryInvestigationPart2.ipynb --to=pdf --TagRemovePreprocessor.remove_all_outputs_tags='{"hide_input"}'

# Putting it all together, this should do all three
jupyter nbconvert $infile --to=pdf --TagRemovePreprocessor.remove_all_outputs_tags='{"hide_output"}' --TagRemovePreprocessor.remove_input_tags='{"hide_input"}' --TagRemovePreprocessor.remove_cell_tags='{"hide_cell",}'
