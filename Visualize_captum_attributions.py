#!/usr/bin/env python3

import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler

def main():
    # Check if the user provided the filename
    if len(sys.argv) < 2:
        print("Usage: python viz-attr.py <datafile>")
        sys.exit(1)

    # Get the filename from command-line arguments
    filename = sys.argv[1]

    # Read the data with a regex separator
    try:
        df = pd.read_csv(
            filename,
            sep=r',|\t',    # Regex to match either comma or tab
            engine='python' # Use the Python engine to parse the regex separator
        )
    except Exception as e:
        print(f"Error reading the file: {e}")
        sys.exit(1)

    # Extract attribution columns
    attrib_cols = [col for col in df.columns if col.startswith('Attribution_')]
    if not attrib_cols:
        print("No attribution columns found in the data.")
        sys.exit(1)

    attrib_matrix = df[attrib_cols]

    # Handle missing values
    attrib_matrix = attrib_matrix.fillna(0)

    # Ensure all data is numeric
    attrib_matrix = attrib_matrix.apply(pd.to_numeric, errors='coerce')
    attrib_matrix = attrib_matrix.fillna(0)

    # Scale the data
    scaler = StandardScaler()
    attrib_matrix_scaled = scaler.fit_transform(attrib_matrix)

    # Add the 'Source' column back to the DataFrame
    attrib_df = pd.DataFrame(attrib_matrix_scaled, columns=attrib_cols)
    attrib_df['Source'] = df['Source'].values

    # Sort the DataFrame by 'Source' to group 'Algal' and 'Bacterial' sequences
    attrib_df_sorted = attrib_df.sort_values('Source').reset_index(drop=True)

    # Extract the sorted attribution matrix and source labels
    attrib_matrix_sorted = attrib_df_sorted[attrib_cols].values
    source_labels = attrib_df_sorted['Source'].values

    # Create a color palette to differentiate the groups
    group_lut = {'Bact': 'blue', 'Algal': 'green'}
    # Convert row_colors to a NumPy array or list
    row_colors = [group_lut[label] for label in source_labels]

    # Create a custom distance matrix to enforce separation between groups
    from scipy.cluster.hierarchy import linkage
    from scipy.spatial.distance import pdist, squareform

    # Compute the pairwise distance matrix
    pairwise_dists = pdist(attrib_matrix_sorted, metric='euclidean')
    distance_matrix = squareform(pairwise_dists)

    # Increase distances between different groups to create a gap
    for i in range(len(distance_matrix)):
        for j in range(len(distance_matrix)):
            if source_labels[i] != source_labels[j]:
                distance_matrix[i, j] += 1e6  # Add a large value to distances between groups

    # Recompute the linkage with the modified distance matrix
    row_linkage = linkage(squareform(distance_matrix), method='average')

    # Create the clustermap with custom row linkage
    g = sns.clustermap(
        attrib_matrix_sorted,
        cmap='vlag',
        center=0,
        row_colors=row_colors,
        figsize=(20, 10),
        yticklabels=False,
        xticklabels=False,
        row_linkage=row_linkage,
        col_cluster=False  # Disable column clustering if not needed
    )

    # Save the figure to an SVG file
    output_file = 'attribution_heatmap.svg'
    g.savefig(output_file, format='svg', bbox_inches='tight')

    print(f"Heatmap saved to '{output_file}'")

if __name__ == "__main__":
    main()
