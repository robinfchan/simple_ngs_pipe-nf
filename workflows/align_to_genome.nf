/*
========================================================================================
    IMPORT MODULES
========================================================================================
*/

include { trimming }            from '../modules/trimming/main.nf'
include { alignment }           from '../modules/alignment/main.nf'

/*
========================================================================================
    DEFINE WORKFLOW
========================================================================================
*/

workflow align_to_genome {

    // set input channels
    ch_fastqs = Channel
        .fromFilePairs( "${params.fastq_path}/*R{1,2}*.f*q.gz", size:2 )
        .ifEmpty {
            throw new RuntimeException("Cannot find any files matching '${params.fastq_path}/*R{1,2}*.f*q.gz'.")
            }

    ch_genome_fa = Channel
        .fromPath( "${params.genome_fa}" )
        .ifEmpty {
            throw new RuntimeException("Cannot find any files matching '${params.genome_fa}'")
            }
    
    // execute modules

    trimming( ch_fastqs ) -> [ (sample1_R1.fq.gz, sample1_R2.fq.gz), (sample2_R1.fq.gz, sample2_R2.fq.gz) ]

    alignment( trimming.out.trim_fastq, ch_genome_fa.collect() ) // where we use .collect() to allow the FASTA genome to be re-used for each process

}