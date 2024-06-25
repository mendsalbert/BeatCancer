#!/bin/bash

generate_ts_file() {
    local input_file=$1
    local output_file=$2
    local variable_name=$3

    echo "Generating ${output_file} from ${input_file}"
    echo "export const ${variable_name} = " > "${output_file}"
    sed 's/`/\\`/g' "${input_file}" >> "${output_file}"
    echo ";" >> "${output_file}"
    echo "Generated ${output_file} successfully."
}

# Run scarb build
echo "Running scarb build..."
scarb build

# Check if scarb build was successful
if [ $? -ne 0 ]; then
    echo "scarb build failed. Exiting."
    exit 1
fi

# Paths to the JSON files
TARGET_FILE_SIERRA="./target/dev/zkpage_ZkPage.contract_class.json"
TARGET_FILE_CASM="./target/dev/zkpage_ZkPage.compiled_contract_class.json"

# Paths to the output TypeScript files
OUTPUT_FILE_SIERRA="../lib/contract/sierra.ts"
OUTPUT_FILE_CASM="../lib/contract/casm.ts"

# Variable names
VARIABLE_NAME_SIERRA="PAGE_CONTRACT_SIERRA"
VARIABLE_NAME_CASM="PAGE_CONTRACT_CASM"

# Generate the sierra.ts file
generate_ts_file "${TARGET_FILE_SIERRA}" "${OUTPUT_FILE_SIERRA}" "${VARIABLE_NAME_SIERRA}"

# Generate the casm.ts file
generate_ts_file "${TARGET_FILE_CASM}" "${OUTPUT_FILE_CASM}" "${VARIABLE_NAME_CASM}"
