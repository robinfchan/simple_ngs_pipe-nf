process trimming {
  tag "${sample_name}"
  errorStrategy 'retry'
  maxRetries 1
  publishDir "${params.results_path}/trimming/", mode: params.publish_dir_mode
  container "${params.docker_image_uri}:${params.docker_image_version}"
  cpus 8
  memory "32 GB"


  input:
  tuple val(sample_name), path(fastqs)

  output:
  val(prefix)
  path("trimmed/*.fq.gz")


  script:
  def read_1 = fastqs[0]
  def read_2 = fastqs[1]
  def prefix = sample_name

  """
  mkdir -p trimmed
  my_trimming_tool --threads ${task.cpus} --fq1 ${read_1} --fq2 ${read_2} --out1 trimmed/${prefix}_R1.fq.gz --out2 trimmed/${prefix}_R2.fq.gz
  """
}
