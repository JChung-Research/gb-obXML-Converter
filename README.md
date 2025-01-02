# XSLT-based gb-to-obXML Schema Converter

## Project Objective
- Convert gbXML schema into obXML schema using XSLT approach
- Devlier building information in the gbXML file to the obXML file for inteoperability between Building Informatino Modeling (BIM) and Building Energy Modeling (BEM)
- Develop an API prototype for Architecture, Engineering, Construction, and Operaiton (AECO) experts to adopt this approach in their industrial projects

## Installation libraries using Conda
1. Download the Conda installer for your OS setup. https://docs.conda.io/en/latest/miniconda.html
2. After installing Conda, create a virtual environment for the IFCLDtoBrick converter with:
```
conda create --name gbXMLtoobXML
```
3. Then activate the new virtual environment:
```
conda activate gbXMLtoobXML
```
4. Install lxml and xmlschema package:
```
pip install lxml xmlschema
```


## Usage
- Install lxml and xmlschema library on your environment
- Download the Github repository and unzip the Zip file
- Run the 'gb-to-obXML_converter.py' Python file, as follows:
```
python gb-to-obXML_converter.py -i example_files/OfficeBuilding_gbXML.xml -o example_files/OfficeBuilding_obXML.xml
```
```
optional arguments:
  -h, --help  show this help message and exit
  -i I        gbXML input file path
  -o O        obXML output file path
  -xsl XSL    XSL file path
  -gb GB      gbXML XSD file path
  -ob OB      obXML XSD file path
```

## Contact
If you have any question on this code, feel free to reach out to Jihoon Chung (jihoonchung.research@gmail.com)

## References
- Green Building XML (gbXML) Schema, available at https://www.gbxml.org/