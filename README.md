# smFISH Nascent Transcription Analysis Pipeline

## Overview

This repository contains an image analysis pipeline for quantifying nascent transcription using single-molecule fluorescence in situ hybridisation (smFISH) microscopy images.

The workflow combines manual identification and annotation of transcription sites in Fiji/ImageJ with computational processing of the resulting measurements.

The analysis includes:

1. Conversion of microscopy images into TIFF format.
2. Randomisation of image filenames to facilitate blinded analysis.
3. Manual annotation of nascent transcription sites and corresponding nuclear and extracellular control regions.
5. Export of annotation coordinates and cell counts for downstream analysis.

## Software requirements

- Fiji/ImageJ, including the Cell Counter plugin
- Bash-compatible terminal for image filename randomisation
- Python 3.9
- Jupyter 

## Repository contents

- `batchExport_split.ijm` — Converts microscopy files into TIFF format.
- `shuffleImageNames.sh` — Randomises image filenames while retaining a record for subsequent identification.
- `cellCounterAnalysisPrep.ijm` — Prepares images for manual annotation using Fiji.
- `ANNOTATION_PROTOCOL.md` — Detailed manual annotation procedure.
- `1_spot_intensity_measurement.ipynb` – De-randomises annotated images, quantifies spot intensities, plots data.
- `settings.yaml` – Config file for notebooks

## Workflow

### 1. Image acquisition and preparation

Acquire sufficient microscopy images to analyse approximately 150–200 eligible cells per experimental condition.

Where necessary, convert Zeiss `.czi` files into TIFF format using `batchExport_split.ijm`.

### 2. Image randomisation

Randomise image filenames using `shuffleImageNames.sh` before manual annotation.

Retain the filename mapping to allow experimental conditions to be recovered after analysis.

### 3. Manual annotation

Open the processed images in Fiji and use the Cell Counter plugin to identify eligible cells, nascent transcription sites, and appropriate control positions. Export data for downstream analysis.

Detailed instructions and annotation criteria are provided in [ANNOTATION_PROTOCOL.md](ANNOTATION_PROTOCOL.md).

### 4. De-randomisation of counts and spot quantification

De-randomise data after manual annotation. Calculate burst fraction (proportion of cell population actively transcribing) and the spot intensity of  transcription foci as basic descriptors of nascent transcriptional activity. Generate plots.

Experiment-specific file paths and confidential data have been excluded from the publicly distributed code.

## Citation

[Add manuscript reference and Zenodo DOI.]
