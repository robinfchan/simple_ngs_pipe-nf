process alignment {
  tag "${sample_name}"
  errorStrategy 'retry'
  maxRetries 1
  publishDir "${params.results_path}/trimming/", mode: params.publish_dir_mode
  container "${params.docker_image_uri}:${params.docker_image_version}"
  cpus 2
  memory "16 GB"


  input:
  tuple val(sample_name), path(fastqs)

  output:
  path("combined/*.fq*")

  script:
  def read_cmd = params.gz_in ? "zcat ${reads}" : "cat ${reads}"
  def write_cmd = params.gz_out ? "| gzip -c > combined/${params.prefix}.fq.gz" : "> combined/${params.prefix}.fq"

  """
  mkdir -p combined
  ${read_cmd} ${write_cmd}
  """
}
