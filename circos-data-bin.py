import sys
from collections import defaultdict

def bin_data(input_file, output_file, bin_factor=10, operation='sum'):
    binned_data = defaultdict(list)
    
    with open(input_file, 'r') as f:
        for line in f:
            chrom, start, end, value = line.strip().split()
            start = int(start)
            end = int(end)
            value = float(value)
            
            # Calculate the new bin
            new_bin_start = (start // (bin_factor * (end - start))) * (bin_factor * (end - start))
            binned_data[(chrom, new_bin_start)].append(value)

    # Process binned data
    with open(output_file, 'w') as f:
        for (chrom, bin_start), values in sorted(binned_data.items()):
            bin_end = bin_start + bin_factor * (end - start)
            if operation == 'sum':
                result = sum(values)
            elif operation == 'average':
                result = sum(values) / len(values)
            else:
                raise ValueError("Operation must be 'sum' or 'average'")
            f.write(f"{chrom}\t{bin_start}\t{bin_end}\t{result:.1f}\n")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python bin_data.py <input_file> <output_file> <bin_factor> <operation>")
        print("operation should be 'sum' or 'average'")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    bin_factor = int(sys.argv[3])
    operation = sys.argv[4]
    
    bin_data(input_file, output_file, bin_factor, operation)
    print(f"Binned data written to {output_file}")
