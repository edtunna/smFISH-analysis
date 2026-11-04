# smFISH Nascent Transcription Analysis Pipeline

## Overview

This repository contains an image analysis pipeline for quantifying nascent transcription using single-molecule fluorescence in situ hybridisation (smFISH) microscopy images.

The workflow combines manual identification and annotation of transcription sites in Fiji/ImageJ with computational processing of the resulting measurements using Python.

Basic steps include:

1. Conversion of microscopy images into TIFF format.
2. Randomisation of image filenames to facilitate blinded analysis.
3. Manual annotation of nascent transcription sites and corresponding nuclear and extracellular control regions.
4. Export of annotation coordinates and cell counts for downstream analysis.
5. De-randomisation of annotated images and associated measurements.
6. Quantification of transcription spot intensities, calculation of burst fraction and collation of summary statistics.
7. Generation of plots for data visualisation.

The pipeline is designed to be adaptable to different experimental conditions, cell types and microscopy datasets.

## Software requirements

- Fiji/ImageJ, including the Cell Counter plugin
- Bash-compatible terminal for image filename randomisation
- Python 3.9
- Jupyter Notebook or JupyterLab

## Repository contents

- `batchExportTIFF_split.ijm` — Converts microscopy files into TIFF format, with options for channel splitting, binning and maximum projection.
- `shuffleImageNames.sh` — Randomises image filenames while retaining a record for subsequent identification.
- `cellCounterAnalysisPrep.ijm` — Prepares images for manual annotation using Fiji.
- `ANNOTATION_PROTOCOL.md` — Detailed manual annotation procedure.
- `1_spot_intensity_measurement.ipynb` — De-randomises annotated images, quantifies transcription spot intensities, calculates summary statistics and generates plots.
- `settings.yaml` — Configuration file containing experiment-specific microscopy settings, analysis parameters and file paths.

## Workflow

### 1. Image acquisition and preparation

Acquire sufficient microscopy images to analyse approximately 150–200 eligible cells per experimental condition.

Where necessary, convert Zeiss `.czi` files into TIFF format using `batchExportTIFF_split.ijm`.

### 2. Image randomisation

Randomise image filenames using `shuffleImageNames.sh` before manual annotation to facilitate blinded analysis.

Place the TIFF images to be analysed in a dedicated directory and run:

```bash
bash shuffleImageNames.sh
```

The script creates randomly numbered images (e.g. `image001.tif`, `image002.tif`) in a `randomisedFiles` directory, while moving the original files into an `originalFiles` directory.

Files recording the relationship between original and randomised image names are also generated.

Retain these files to allow experimental conditions and image metadata to be recovered after analysis.

**Note:** Run the script in a fresh directory containing only the intended TIFF images. Repeated execution without clearing previously generated mapping files may interfere with randomisation.

The script uses GNU `sort -R`, which may require GNU coreutils on macOS.

### 3. Manual annotation

Open the processed images in Fiji and use the Cell Counter plugin to identify eligible cells, nascent transcription sites and appropriate control positions.

Cells unsuitable for analysis are excluded according to predefined criteria, including evidence of cell death, multinucleation, incomplete capture at image boundaries or incomplete representation within the acquired Z-stack.

For eligible cells, transcription sites are identified manually throughout the Z-stack.

For each transcription site, a corresponding nuclear control position is selected within the same Z-slice. An extracellular control position is also annotated outside the cell, with one external control position per cell containing transcription sites.

Cells without detectable transcription spots are recorded separately.

Export annotation coordinates and cell counts as CSV files for downstream analysis.

Detailed instructions and annotation criteria are provided in [ANNOTATION_PROTOCOL.md](ANNOTATION_PROTOCOL.md).

### 4. De-randomisation of counts and spot quantification

Quantitative analysis is performed using the Jupyter notebook:

`1_spot_intensity_measurement.ipynb`

The notebook de-randomises the annotated image data using the filename mapping generated during image randomisation.

The analysis calculates:

- **Burst fraction:** The proportion of the analysed cell population containing detectable nascent transcription sites, representing the fraction of cells actively transcribing the target gene.
- **Transcription spot intensity:** Fluorescence intensity measurements of manually annotated nascent transcription foci, using corresponding control positions for background measurements.
- **Additional summary statistics:** Including the number of transcription spots per cell and intensity-related measurements.

The notebook also generates plots for visualisation and comparison of measurements between experimental groups.

### 5. Analysis configuration

The `settings.yaml` file contains the parameters required to configure the notebook for individual datasets.

**Users must configure these settings for their own datasets before running the analysis.**

Spot measurement dimensions are calculated from the microscopy calibration within the notebook. These parameters should be reviewed when applying the pipeline to different imaging conditions.

## Citation

If using this pipeline, please cite the corresponding archived software release.

**Zenodo DOI:** [To be added]

**Associated publication:** [To be added, if applicable]
