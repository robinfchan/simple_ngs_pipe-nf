#!/usr/bin/env nextflow
/*
========================================================================================
                                      simple_ngs_pipe-nf
========================================================================================
  Version 0.0.1
---------------------------------------------------------
*/

nextflow.enable.dsl = 2

// Show help message
if (params.help){
    helpMessage()
    exit 0
}

check_required_parameters_defined()

printParameterSummary()

/*
========================================================================================
    IMPORT WORKFLOWS
========================================================================================
*/

include { align_to_genome } from './workflows/align_to_genome.nf'

/*
========================================================================================
    RUN NAMED WORKFLOWS
========================================================================================
*/

// run default workflow
align_to_genome()


/*
========================================================================================
    SET HELP
========================================================================================
*/

def helpMessage() {
  log.info"""

  Arguments:
    --fastq_path [path]          Glob path to FASTQ files to process
    --genome_fa [path]           Path to genome to align against
    --base_results_path [path]   The output directory where the results will be saved; default = './results'
    --experiment_name [str]      Name for subdir under outdir (above) to write results; REQUIRED
    --help                       Print this help message
  """.stripIndent()
}

/*
========================================================================================
    SET PRINT PARAMETER SUMMARY
========================================================================================
*/

def printParameterSummary() {
  // Header log info
  def summary = [:]
  summary['Exp. Name'] = params.experiment_name
  summary['Run ID'] = params.run_id
  summary['Run Name'] = workflow.runName
  summary['Reads'] = params.fastq_path
  summary['Genome'] = params.genome_fa
  summary['Max Resources'] = "$params.max_memory memory, $params.max_cpus cpus, $params.max_time time per job"
  summary['Output dir'] = params.base_results_path
  summary['Launch dir'] = workflow.launchDir
  summary['Working dir'] = workflow.workDir
  summary['Script dir'] = workflow.projectDir
  summary['User'] = workflow.userName
  summary['Config Profile'] = workflow.profile

  log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
}

/*
========================================================================================
    SET MANDATORY PARAMETERS CHECK
========================================================================================
*/

def check_required_parameters_defined() {
    if (params.experiment_name == null || params.base_results_path == null || params.fastq_path == null || params.genome_fa == null) {
        exit 1, "All mandatory parameters should be set to run the pipeline."
    }
}

/*
========================================================================================
    THE END
========================================================================================
*/
