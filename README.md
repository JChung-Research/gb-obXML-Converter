# gbXML-to-obXML Schema Converter

## Project Objective
- Transform building information from gbXML (Green Building XML) schema to obXML (Occupant Behavior XML) schema, ensuring data integrity through comprehensive schema validation against both specifications
- Enable seamless integration of BIM data into occupant behavior simulation by automating the conversion of spatial, system, and schedule information between schemas while supporting the latest versions of both schemas (gbXML v7.04 and obXML v1.4)
- Provide a robust, command-line tool for Architecture, Engineering, Construction, and Operation (AECO) professionals to incorporate occupant behavior modeling into their BIM-to-BEM workflows, facilitating practical implementation of human-centric building performance simulation

## Installation libraries using Conda
1. Download and install Miniconda from https://docs.conda.io/en/latest/miniconda.html
2. Create a new conda environment:
```
conda create --name gbXMLtoobXML
```
3. Activate the environment:
```
conda activate gbXMLtoobXML
```
4. Install required packages:
```
pip install lxml xmlschema
```

## Usage
1. Clone or download this repository:
```
git clone https://github.com/username/gb-obXML-converter.git
cd gb-obXML-converter
```
2. Run the converter:
```
python gb-to-obXML_converter.py -i input.xml -o output.xml
```

## Command Line Arguments
```
optional arguments:
  -h, --help  show this help message and exit
  -i I        Input gbXML file path (required)
  -o O        Output obXML file path (optional, defaults to input_obXML.xml)
  -xsl XSL    XSL file path (optional, defaults to resources/gbXML-to-obXML.xsl)
  -gb GB      gbXML schema file path (optional, defaults to resources/GreenBuildingXML_Ver7.04.xsd)
  -ob OB      obXML schema file path (optional, defaults to resources/obXML_v1.4.xsd)
```

## Example
```
python gb-to-obXML_converter.py -i example_files/OfficeBuilding_gbXML_v.7.04.xml -o example_files/OfficeBuilding_obXML_v.1.4.xml
```

## File Structure
```
gb-obXML-converter/
├── resources/
│   ├── gbXML-to-obXML.xsl            # XSLT transformation rules
│   ├── GreenBuildingXML_Ver7.04.xsd  # gbXML schema
│   └── obXML_v1.4.xsd                # obXML schema
├── example_files/                    # Example input/output files
└── gb-to-obXML_converter.py          # Main converter script
```

## Citation
This code was developed as part of the research published in the journal paper:

Author names. (2025). Enhancing Occupant Behavior Representation for Interoperability between Building Information Modeling and Building Energy Modeling. *Building Simulation*.

If you use this code in your work, please cite the above publication.

## References
- Green Building XML (gbXML) Schema, available at https://www.gbxml.org/
- Occupant Behavior XML (obXML) Schema, available at https://behavior.lbl.gov/
