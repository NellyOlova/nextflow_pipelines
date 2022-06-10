nextflow.enable.dsl=2
params.nogroup = false

process FASTQC {
	container "/exports/igmm/eddie/BioinformaticsResources/nf-core/singularity-images/depot.galaxyproject.org-singularity-fastqc-0.11.9--0.img"
	tag "$name" // Adds name to job submission instead of (1), (2) etc.

	input:
	    tuple val(name), path(reads)
		val (outputdir)
		val (fastqc_args)
		val (verbose)

	output:
	    tuple val(name), path ("*fastqc*"), emit: all
		path "*.zip",  emit: report
	
	publishDir "$outputdir",
		mode: "link", overwrite: true

	script:

		if (params.nogroup){
			// println ("ADDING --nogroup: " + fastqc_args)
			fastqc_args += " --nogroup "
		}
		
		if (verbose){
			println ("[MODULE] FASTQC ARGS: "+ fastqc_args)
		}

		"""
		#module load fastqc
		fastqc $fastqc_args -q -t 2 ${reads}
		"""
}
