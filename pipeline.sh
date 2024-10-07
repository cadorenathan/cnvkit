# Install cnvkit using Conda
# Configure the sources where conda will find packages
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Install CNVkit in a new environment named "cnvkit" conda create -n cnvkit cnvkit # Activate the environment with CNVkit installed: source activate cnvkit
conda install cnvkit

# Run batches
cnvkit.py batch tumor/*_tumor.bam --normal normal/*.bam \
--fasta Homo_sapiens_assembly38_noALT_noHLA_noDecoy_v0_Homo_sapiens_assembly38_noALT_noHLA_noDecoy.fasta \
--targets hg38_exome_2.0.editednames.bed  \
--access access-5kb-mappable.hg38.bed \
--output-reference my_reference.cnn \
--output-dir results_drop-low  \
--drop-low-coverage \
--diagram \
--scatter \
-p 8

cnvkit.py scatter -s 4484-1F77_TM_4PLEX_020623__4484-1F77_SG_12PLEX_290523_tumor.cn{s,r} -c 25000000-55000000 -g ERBB2


################################################################################################################################
# LOH
cnvkit.py call ../results_drop-low/4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.cns \
-v 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.hard-filtered.vcf.gz \
-o 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.call.vcf.cns

cnvkit.py scatter ../results_drop-low/4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.cnr \
-s ../results_drop-low/4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.cns \
-v 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.hard-filtered.vcf.gz \
--output 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.baf.scatter.png

#call
    cnvkit.py segmetrics -s ../results_drop-low/4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.cn{s,r} --ci ---output-dir ./
    cnvkit.py call 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.segmetrics.cns -x male -v 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.hard-filtered.vcf.gz -o 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523_tumor.segmetrics.call.cns
    cnvkit.py export vcf 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.hard-filtered.vcf.gz -x male  -i 4269-9M60 -o 4269-9M60_TM_4PLEX_020623__4269-9M60_SG_12PLEX_290523.cnv.vcf
