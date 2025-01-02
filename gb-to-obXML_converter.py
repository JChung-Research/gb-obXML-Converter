# pip install lxml and xmlschema
from time import perf_counter
import os
import argparse
import sys

from lxml import etree
import xmlschema

def XML_validator(xml_file, xsd_file):
    try:
        print(f"Loading the XML file... {xml_file}")
        # Load the XSD schema
        schema = xmlschema.XMLSchema(xsd_file)

        # Validate the XML file
        if schema.is_valid(xml_file):
            print(f"The XML document is valid!: {xml_file}")
        else:
            # If not valid, you can also get detailed validation errors
            errors = schema.validate(xml_file)
            print("The XML document is not valid. Errors:")
            for error in errors:
                print(error)
            sys.exit(1)
    except xmlschema.XMLSchemaException as e:
        print(f"An error occurred while loading the XSD schema: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

def gbobXML_translator(input_xml, output_xml, xsl_file):
    try:
        print(f"Translating the gbXML file... {input_xml}")
        # Parse the XML and XSL files
        xml_tree = etree.parse(input_xml)
        xsl_tree = etree.parse(xsl_file)

        # Apply the XSL transformation
        transform = etree.XSLT(xsl_tree)
        result_tree = transform(xml_tree)

        # Save the transformed XML to a file
        with open(output_xml, "wb") as output_file:
            output_file.write(etree.tostring(result_tree, pretty_print=True, xml_declaration=True, encoding="UTF-8"))

        print(f"Transformation successful! Output saved to {output_xml}")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

t1_start = perf_counter()
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Convert gbXML to obXML schema')
    parser.add_argument('-i', type=str, help='gbXML input file path')
    parser.add_argument('-o', type=str, help='obXML output file path')
    parser.add_argument('-xsl', type=str, help='XSL file path', default='resources/gbXML-to-obXML.xsl')
    parser.add_argument('-gb', type=str, help='gbXML XSD file path', default='resources/GreenBuildingXML_Ver7.04.xsd')
    parser.add_argument('-ob', type=str, help='obXML XSD file path', default='resources/obXML_v1.4.xsd')

    args = parser.parse_args()

    if args.i:
        gbXMLFilePath = args.i
    if args.xsl:
        XSLFilePath = args.xsl
    if args.gb:
        gbXML_XSD_FilePath = args.gb
    if args.ob:
        obXML_XSD_FilePath = args.ob

    if os.path.isfile(gbXML_XSD_FilePath):        
        XML_validator(gbXMLFilePath, gbXML_XSD_FilePath)
    else:
        print(str(args.gb) + ' is not a valid file')

    if os.path.isfile(gbXMLFilePath) and os.path.isfile(XSLFilePath):
        if args.o:
            obXMLFilePath = args.o
        else:
            obXMLFilePath = os.path.splitext(gbXMLFilePath)[0] + '_obXML.xml'
        
        gbobXML_translator(gbXMLFilePath, obXMLFilePath, XSLFilePath)
    else:
        print(str(args.i) + ' is not a valid file')

    if os.path.isfile(obXML_XSD_FilePath):        
        XML_validator(obXMLFilePath, obXML_XSD_FilePath)
    else:
        print(str(args.ob) + ' is not a valid file')


    t1_stop = perf_counter()
    print("The translation took ", t1_stop-t1_start, " seconds")

