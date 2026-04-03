
<!-- badges: start -->
[![DOI biorxiv](https://img.shields.io/badge/BioRxiv-10.1101/2025.09.11.675584-blue.svg)](https://doi.org/10.1101/2025.09.11.675584)
[![DOI seanoe](https://img.shields.io/badge/SEANOE-10.17882/111869-blue.svg)](https://www.seanoe.org)
[![DOI SRA](https://img.shields.io/badge/SRA-PRJNA1293818-orange.svg)](https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA1293818)


<!-- badges: stop -->

# Unexpected diversity of _Isidoides_ (Anthozoa: Octocorallia: Isidoidae) revealed by morphology and phylogenomic analysis with descriptions of three new species
 
Yu Xu<sup>1,†</sup>, Jaret P. Bilewitch<sup>2,†</sup>, Eric Pante<sup>3,4,†,$</sup>, Zifeng Zhan<sup>1</sup>, Sadie Mills<sup>2</sup>, Malcolm R. Clark<sup>2</sup> and Kuidong Xu<sup>1,5,$</sup>
 
<sup>1</sup> Laboratory of Marine Organism Taxonomy and Phylogeny, Shandong Province Key Laboratory of Marine Biodiversity and Bio-resource Sustainable Utilization, Institute of Oceanology, Chinese Academy of Sciences, Qingdao 266071, China
<sup>2</sup> New Zealand Institute of Earth Science Ltd (NZIES), 301 Evans Bay Parade, Wellington 6021, New Zealand
<sup>3</sup> Univ Brest, CNRS, IRD, Ifremer, UMR 6539, LEMAR, Plouzané, France
<sup>4</sup> Institut Systématique Evolution Biodiversité (ISYEB), Muséum national d’Histoire naturelle, CNRS, Sorbonne Université, EPHE, Université des Antilles, 43 rue Cuvier, CP 26, 75005 Paris, France
<sup>5</sup> University of Chinese Academy of Sciences, Beijing 100049, China
 
<sup>$</sup> Corresponding authors: Eric Pante (eric.pante@cnrs.fr), Kuidong Xu (kxu@qdio.ac.cn)
<sup>†</sup> These authors contributed equally to this work

---

This repository contains code and references to the rawdata necessary to replicate the analyses in Xu et al 2026. To assemble UCEs from raw `fastq.gz`, start with the `snp_pipeline` folder, and perform steps 0 to 6 (derived form [Erickson et al 2021](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.13241) and [github.com/Lavarchus](https://github.com/Lavarchus/SNP-calling-GATK4)); fork to `phylogenetic/Workflow_UCE.html`for the next steps of the assembly; this part is based on the [phyluce tutorial 1](https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html)). For detecting SNPs, perform steps 7-18 from `snp_pipeline`. `snp_config_files`contains the files necessary to run the `snp_pipeline`scripts. The pipeline is optimised for HPC with `slurm`.
