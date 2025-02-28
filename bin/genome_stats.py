#!/usr/bin/env python

# You can refer to the help manual by `python genome_stats.py -h`

# argparse is a library that allows you to make user-friendly command line interfaces
import argparse
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction
import pandas as pd

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help='a FASTA file containing a genomic sequence', dest="input", required=True)
parser.add_argument("-o", "--output", help='The output file where we will write our statistics', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()
fasta_file = args.input
output_file = args.output

seq_records = list(SeqIO.parse(fasta_file, "fasta"))

genome_seq = "".join(str(record.seq) for record in seq_records)

gc_percent = gc_fraction(genome_seq)
gc_num = gc_percent * len(genome_seq)

gc_df = pd.DataFrame({"GC percent": [round(gc_percent * 100, 2)], "Number G+C": [int(gc_num)], "Total Sequence Length": [len(genome_seq)]})

gc_df.to_csv(output_file, sep=' ', index=False)