# Manual Annotation Protocol for smFISH Nascent Transcription Analysis

#### N.B. This analysis pipeline was primarily written for the analysis of suspension cells, and therefore adjustments to positioning of external controls for example may be required for adherent cells or those in tissue.

## 1. Image acquisition

Acquire sufficient images to analyse approximately 150–200 live, non-multinucleated cells per experimental condition.

Depending on cell density and microscope configuration, approximately 8–12 images may be required.

## 2. Image conversion and preparation

Use the Fiji/ImageJ macro `batchExport_split.ijm` to convert `.czi` files into `.tif` files.

1. Create a folder named `TIFFs` within the directory containing the original microscopy images.
2. Open `batchExport_split.ijm` in Fiji and select **Run**.
3. Select the directory containing the microscopy files to process.
4. Select the `TIFFs` folder as the output destination.
5. Select 'No' to all options, unless binning is required, then select 'Yes' for this option.


## 3. Image filename randomisation

To facilitate blinded analysis:

1. Copy the image randomisation Bash script into the `TIFFs` directory.
2. Ensure that this directory contains only the TIFF images intended for randomisation.
3. Open a terminal and navigate to the directory.
4. Run the randomisation script.

```bash
bash shuffleImageNames.sh
```

The script generates images with randomised filenames while preserving the original files and a record linking the randomised and original filenames.

## 4. Initialise Cell Counter

1. Open Fiji.
2. Open the Cell Counter plugin using **Plugins → Analyze → Cell Counter → Cell Counter**, or locate it using Fiji's search function.
3. Close all currently open images using **File → Close All**.
4. Open the first randomised image, for example `image001.tif`.
5. Open the `cellCounterAnalysisPrep.ijm` macro in Fiji and select **Run**.
6. Select the processed image corresponding to the transcription signal, for example `C2-...tif`.
7. In the Cell Counter window, click **Initialize**.

Rename the marker categories as follows:

| Marker | Category | Purpose |
|---|---|---|
| Type 1 | Transcription spot | Nascent transcription site |
| Type 2 | Nuclear control | Nuclear background measurement |
| Type 3 | External control | Extracellular background measurement |
| Type 4 | No spots | Cell without a detected transcription site |
| Type 5 | Ignore cell | Cell excluded from analysis |

Remove unused marker categories and select **Show All**.

Open **Image → Adjust → Brightness/Contrast** to allow adjustment of image display contrast during annotation.

## 5. Identify cells to exclude

Before identifying transcription sites, inspect the nuclear channel and identify cells unsuitable for analysis.

### 5.1 Dead cells

Inspect the nuclear staining pattern.

- Cells with very bright, relatively uniform nuclear staining are considered potentially dead.
- Live cells typically show a more heterogeneous, mottled nuclear staining pattern associated with euchromatin and heterochromatin organisation.

Mark cells identified as dead using the **Ignore cell** category.

### 5.2 Cells intersecting image boundaries

Exclude cells that overlap the image boundary and cannot be assessed completely.

### 5.3 Multinucleated cells

Exclude cells containing two or more nuclei within the same cell boundary.

### 5.4 Incomplete nuclear Z-stacks

Inspect nuclei throughout the Z-stack.

An adequately captured nucleus should become out of focus towards both ends of the stack.

Exclude cells whose nuclei are not sufficiently captured within the acquired Z-range.

Mark all excluded cells using **Ignore cell**, placing a marker near the centre of each excluded cell.

## 6. Identify nascent transcription sites

After identifying cells to exclude, examine each remaining cell for nascent transcription sites.

1. Navigate through the Z-stack in the Cell Counter image window.
2. Inspect the nuclear region for bright transcription-associated fluorescent spots.
3. If no transcription spot is identified, select **No spots** and place a marker within the cell boundary.
4. If a transcription spot is identified, determine its approximate centroid in the XY plane and along the Z-axis.

The centroid is typically identified using the brightest pixel associated with the spot across the relevant XY and Z planes.

Select **Transcription spot** and place the marker precisely at the identified centroid.

In the Cell Counter interface, the marker may appear aligned with the upper-left corner of the selected pixel.

## 7. Annotate nuclear control positions

For each identified transcription spot:

1. Select the **Nuclear control** category.
2. Remain in the same Z-slice as the transcription spot.
3. Select a position within the nucleus but away from the transcription spot.
4. Place one nuclear control marker for each transcription spot.

## 8. Annotate external control positions

For each cell containing at least one transcription spot:

1. Select **External control**.
2. Identify a position immediately outside the cell boundary.
3. Ensure that the selected position is closer to the target transcription spot than to any transcription spot in a neighbouring cell.
4. Place one external control marker per cell.

## 9. Complete annotation

Repeat the annotation procedure until every cell in the image has been classified.

Each cell should be identified as either:

- An eligible cell with one or more transcription spots;
- An eligible cell without detectable transcription spots; or
- An excluded cell.

For cells containing transcription spots, ensure that the appropriate nuclear and external control markers have been added.

## 10. Save annotations and measurements

After completing annotation:

1. Select **Save Markers** in Cell Counter.
2. Save the marker file using the suggested filename.
3. Select **Results**.
4. Save the results as a CSV file using the naming convention `Counts[image_name].csv`, removing the Cell Counter prefix from the filename.
5. Select **Measure**.
6. Save the corresponding output as `XY[image_name].csv`.
7. Close all image and results windows before opening the next image.

Repeat for each randomised image.


These details should be added where relevant to the analysis performed in the associated publication.
