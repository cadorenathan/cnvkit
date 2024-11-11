
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


#adjusting by tumor purity
#using a tab file with sample in the second column and purity in the third
while IFS=$'\t' read -r col1 col2 col3; do
cnvkit.py call results_drop-low/${col2}_tumor.cns -y -m clonal --purity ${col3} -o call_purity/${col2}_tumor.call.cns
done < ../cnvkit_results/celularidade_mama.txt
cp call_purity/* ../cnvkit_results/purity_breast

while IFS=$'\t' read -r col1 col2 col3; do
cnvkit.py call results_drop-low/${col2}_tumor.cns -y -m clonal --purity ${col3} -o purity_prostate/${col2}_tumor.call.cns
done < ../cnvkit_results/celularidade_prostata.txt

cp call_purity/* ../cnvkit_results/purity_prostate

#GISTIC 2.0

cnvkit.py export seg purity_breast/*.cns -o purity_breast.gistic.segments
cnvkit.py export seg purity_prostate/*.cns -o purity_prostate.gistic.segments

conda create -n gistic2
conda install -c hcc gistic2

#confidence 95%, Threshold for copy number amplifications/deletions 0.3, q-value 0.01 
#gistic2 -b dir -seg seg.file -refgene ref -conf 0.95 -ta 0.3 -td 0.3 -qvt 0.01 
#-maxspace -genegistic 1 -armpeel 1 -savegene 1 -rx 1
gistic2 -b gistic2/prostate_conclusive_purity1st -seg cnvkit_results/purity_prostate.gistic.segments -refgene gistic2/hg38.UCSC.add_miR.160920.refgene.mat -conf 0.95 -ta 0.3 -td 0.3 -qvt 0.01 
gistic2 -b gistic2/prostate_conclusive_purity2nd -seg cnvkit_results/purity_prostate.gistic.segments -refgene gistic2/hg38.UCSC.add_miR.160920.refgene.mat -conf 0.95 -ta 0.3 -td 0.3 -qvt 0.01 -maxspace -genegistic 1 -armpeel 1 -savegene 1 -rx 1

gistic2 -b gistic2/breast_conclusive_purity1st -seg cnvkit_results/purity_breast.gistic.segments -refgene gistic2/hg38.UCSC.add_miR.160920.refgene.mat -conf 0.95 -ta 0.3 -td 0.3 -qvt 0.01 
gistic2 -b gistic2/breast_conclusive_purity2nd -seg cnvkit_results/purity_breast.gistic.segments -refgene gistic2/hg38.UCSC.add_miR.160920.refgene.mat -conf 0.95 -ta 0.3 -td 0.3 -qvt 0.01 -maxspace -genegistic 1 -armpeel 1 -savegene 1 -rx 1

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
