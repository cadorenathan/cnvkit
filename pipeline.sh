# Install cnvkit using Conda
# Configure the sources where conda will find packages
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Install CNVkit in a new environment named "cnvkit" conda create -n cnvkit cnvkit # Activate the environment with CNVkit installed: source activate cnvkit
conda install cnvkit

# Run batches
cnvkit.py batch *_tumor.bam --normal *_normal.bam \
--fasta Homo_sapiens_assembly38_noALT_noHLA_noDecoy_v0_Homo_sapiens_assembly38_noALT_noHLA_noDecoy.fasta \
--targets hg38_exome_2.0.editednames.bed  \
--access access-5kb-mappable.hg38.bed \
--output-reference my_reference.cnn \
--output-dir results_drop-low  \
--drop-low-coverage \
--diagram \
--scatter
