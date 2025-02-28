include {NCBI_DATASET} from './modules/ncbi_dataset'
include {PROKKA} from './modules/prokka'
include {SAMTOOLS_FAIDX} from './modules/samtools'
include {EXTRACT_REGION} from './modules/extract_region'
include {SAMTOOLS_FAIDX_SUBSET} from './modules/samtools_faidx_subset'
include {JELLYFISH} from './modules/jellyfish'
include {GENOME_STATS} from './modules/genome_stats'

workflow {
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.assembly, file(row.path)) }
    | set{ fa_ch }
    
    NCBI_DATASET(fa_ch)

    PROKKA(NCBI_DATASET.out)
    SAMTOOLS_FAIDX(NCBI_DATASET.out)
    EXTRACT_REGION(PROKKA.out.gff)

    EXTRACT_REGION.out.join(SAMTOOLS_FAIDX.out)
    | set{ subset_ch }

    SAMTOOLS_FAIDX_SUBSET(subset_ch)

    kmer_range = Channel.from(1..21)
    NCBI_DATASET.out.fna.combine(kmer_range)
    | set{ kmer_ch }

    JELLYFISH(kmer_ch)

    GENOME_STATS(NCBI_DATASET.out)
}