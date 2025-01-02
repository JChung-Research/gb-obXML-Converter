<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gb="http://www.gbxml.org/schema" version="1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="gb:gbXML">
        <OccupantBehavior xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ID="OS001" xsi:noNamespaceSchemaLocation="obXML_v1.4.xsd" Version="1.4">
            <xsl:call-template name="add-OccupantBehavior">
                <xsl:with-param name="GUID" select="gb:DocumentHistory/gb:ProgramInfo/gb:ProjectEntity/gb:GUID"/>
                <xsl:with-param name="URI" select="gb:DocumentHistory/gb:ProgramInfo/gb:ProjectEntity/gb:URI"/>
                <xsl:with-param name="ProductName" select="gb:DocumentHistory/gb:ProgramInfo/gb:ProductName"/>
                <xsl:with-param name="date" select="gb:DocumentHistory/gb:CreatedBy/@date"/>
                <xsl:with-param name="id" select="gb:DocumentHistory/gb:PersonInfo/@id"/>
            </xsl:call-template>
            <Buildings>
                <xsl:apply-templates select="gb:Campus/gb:Building"/>
            </Buildings>

            <Behaviors/>
            
            <Zones>
                <xsl:apply-templates select="gb:Zone"/>
            </Zones>
            <Schedules>
                <xsl:apply-templates select="gb:Schedule"/>
                <xsl:apply-templates select="gb:WeekSchedule"/>
                <xsl:apply-templates select="gb:DaySchedule"/>
            </Schedules>
        </OccupantBehavior>
    </xsl:template>

    <xsl:template name="add-OccupantBehavior">
        <xsl:param name="GUID"/>
        <xsl:param name="URI"/>
        <xsl:param name="ProductName"/>
        <xsl:param name="date"/>
        <xsl:param name="id"/>

        <xsl:if test="$GUID != ''">
            <xsl:attribute name="IfcProjectGuid">
                <xsl:value-of select="$GUID"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$URI != ''">
            <xsl:attribute name="IfcFilename">
                <xsl:value-of select="$URI"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$ProductName != ''">
            <xsl:attribute name="IfcOriginatingSystem">
                <xsl:value-of select="$ProductName"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$date != ''">
            <xsl:attribute name="IfcCreationDate">
                <xsl:value-of select="$date"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$id != ''">
            <xsl:attribute name="IfcAuthor">
                <xsl:value-of select="$id"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="gb:Building">
        <Building ID="{@id}" Name="{gb:Name}">                    
            <xsl:call-template name="add-IfcGuid">
                <xsl:with-param name="ifcGUID" select="@ifcGUID"/>
            </xsl:call-template>            
            <xsl:apply-templates select="gb:Description"/>   
            <BuildingType>
                <xsl:value-of select="@buildingType"/>
            </BuildingType>
            <Address>
                <xsl:value-of select="gb:StreetAddress"/>
            </Address>

            <xsl:call-template name="add-Area">
                <xsl:with-param name="Area" select="gb:Area"/>
                <xsl:with-param name="unit" select="gb:Area/@unit"/>
            </xsl:call-template>
            <Spaces ID="All_Spaces">
                <xsl:apply-templates select="gb:Space"/>
            </Spaces>
            <xsl:apply-templates select="gb:BuildingStorey"/>
        </Building>
    </xsl:template>

    <xsl:template name="add-IfcGuid">
        <xsl:param name="ifcGUID"/>
        <xsl:if test="$ifcGUID != ''">
            <xsl:attribute name="IfcGuid">
                <xsl:value-of select="$ifcGUID"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-Area">
        <xsl:param name="Area"/>
        <xsl:param name="unit"/>
        <xsl:if test="($Area != '') and ($unit != '')">
            <Area AreaUnit="{$unit}">
                <xsl:value-of select="$Area"/>
            </Area>
        </xsl:if>
        <xsl:if test="($Area != '') and not($unit != '')">
            <Area>
                <xsl:value-of select="$Area"/>
            </Area>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-Level">
        <xsl:param name="Level"/>
        <xsl:param name="unit"/>
        <xsl:if test="($Level != '') and ($unit != '')">
            <StoreyLevel LengthUnit="{$unit}">
                <xsl:value-of select="$Level"/>
            </StoreyLevel>
        </xsl:if>
        <xsl:if test="($Level != '') and not($unit != '')">
            <StoreyLevel>
                <xsl:value-of select="$Level"/>
            </StoreyLevel>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-ZoneAttributes">
        <xsl:param name="heatSchedIdRef"/>
        <xsl:param name="coolSchedIdRef"/>
        <xsl:param name="fanSchedIdRef"/>
        <xsl:param name="fanTempSchedIdRef"/>
        <xsl:if test="$heatSchedIdRef != ''">
            <xsl:attribute name="HeatScheduleIdRef">
                <xsl:value-of select="$heatSchedIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$coolSchedIdRef != ''">
            <xsl:attribute name="CoolScheduleIdRef">
                <xsl:value-of select="$coolSchedIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$fanSchedIdRef != ''">
            <xsl:attribute name="FanScheduleIdRef">
                <xsl:value-of select="$fanSchedIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$fanTempSchedIdRef != ''">
            <xsl:attribute name="FanTempScheduleIdRef">
                <xsl:value-of select="$fanTempSchedIdRef"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="gb:Zone">
        <Zone ID="{@id}" Name="{gb:Name}">
            <xsl:call-template name="add-IfcGuid">
                <xsl:with-param name="ifcGUID" select="@ifcGUID"/>
            </xsl:call-template>
            <xsl:call-template name="add-ZoneAttributes">
                <xsl:with-param name="heatSchedIdRef" select="@heatSchedIdRef"/>
                <xsl:with-param name="coolSchedIdRef" select="@coolSchedIdRef"/>
                <xsl:with-param name="fanSchedIdRef" select="@fanSchedIdRef"/>
                <xsl:with-param name="fanTempSchedIdRef" select="@fanTempSchedIdRef"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>         
            <DesignHeatT TempUnit="{gb:DesignHeatT/@unit}">
                <xsl:value-of select="gb:DesignHeatT"/>
            </DesignHeatT>
            <DesignCoolT TempUnit="{gb:DesignCoolT/@unit}">
                <xsl:value-of select="gb:DesignCoolT"/>
            </DesignCoolT>
            <DesignHeatRH>
                <xsl:value-of select="gb:DesignHeatRH"/>
            </DesignHeatRH>
            <DesignCoolRH>
                <xsl:value-of select="gb:DesignCoolRH"/>
            </DesignCoolRH>
        </Zone>
    </xsl:template>

    <xsl:template name="add-Schedule">
        <xsl:param name="Name"/>
        <xsl:param name="scheduleTypeLimitsId"/>
        <xsl:if test="$Name != ''">
            <xsl:attribute name="Name">
                <xsl:value-of select="$Name"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$scheduleTypeLimitsId != ''">
            <xsl:attribute name="ScheduleTypeLimitsId">
                <xsl:value-of select="$scheduleTypeLimitsId"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-ScheduleValue">
        <xsl:param name="OutsideHighReset"/>
        <xsl:param name="OutsideLowReset"/>
        <xsl:param name="SupplyHighReset"/>
        <xsl:param name="SupplyLowReset"/>
        <xsl:if test="$OutsideHighReset != ''">
            <xsl:attribute name="OutsideHighReset">
                <xsl:value-of select="$OutsideHighReset"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$OutsideLowReset != ''">
            <xsl:attribute name="OutsideLowReset">
                <xsl:value-of select="$OutsideLowReset"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$SupplyHighReset != ''">
            <xsl:attribute name="SupplyHighReset">
                <xsl:value-of select="$SupplyHighReset"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$SupplyLowReset != ''">
            <xsl:attribute name="SupplyLowReset">
                <xsl:value-of select="$SupplyLowReset"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="gb:Schedule">
        <Schedule ID="{@id}" ScheduleType="{@type}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="@Name"/> 
                <xsl:with-param name="scheduleTypeLimitsId" select="@scheduleTypeLimitsId"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>   
            <xsl:apply-templates select="gb:YearSchedule"/>
        </Schedule>
    </xsl:template>

    <xsl:template match="gb:YearSchedule">
        <YearSchedule ID="{@id}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
                <xsl:with-param name="scheduleTypeLimitsId" select="@scheduleTypeLimitsId"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>           
            <BeginDate>
                <xsl:value-of select="gb:BeginDate"/>
            </BeginDate>
            <EndDate>
                <xsl:value-of select="gb:EndDate"/>
            </EndDate>
            <WeekScheduleId WeekScheduleIdRef="{gb:WeekScheduleId/@weekScheduleIdRef}">
                <xsl:value-of select="gb:WeekScheduleId"/>
            </WeekScheduleId>
        </YearSchedule>
    </xsl:template>

    <xsl:template match="gb:WeekSchedule">
        <WeekSchedule ID="{@id}" ScheduleType="{@scheduleType}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
                <xsl:with-param name="scheduleTypeLimitsId" select="@scheduleTypeLimitsId"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>        
            <DayScheduleId DayScheduleIdRef="{gb:Day/@dayScheduleIdRef}" DayofWeek="{gb:Day/@dayType}">
                <xsl:value-of select="gb:Day"/>
            </DayScheduleId>
        </WeekSchedule>
    </xsl:template>

    <xsl:template match="gb:DaySchedule">
        <DaySchedule ID="{@id}" ScheduleType="{@scheduleType}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
                <xsl:with-param name="scheduleTypeLimitsId" select="@scheduleTypeLimitsId"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>         
            <xsl:apply-templates select="gb:ScheduleValue"/>
        </DaySchedule>
    </xsl:template>

    <!-- Transform Space element -->
    <xsl:template match="gb:Space">
        <Space ID="{@id}" Name="{gb:Name}" ZoneIdRef ="{@zoneIdRef}" LightScheduleIdRef="{@lightScheduleIdRef}" PlugLoadScheduleIdRef="{@equipmentScheduleIdRef}" BuildingStoreyIdRef ="{@buildingStoreyIdRef}">
            <xsl:call-template name="add-IfcGuid">
                <xsl:with-param name="ifcGUID" select="@ifcGUID"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>  
            <SpaceType>
                <xsl:apply-templates select="@spaceType"/>
            </SpaceType>
            <HVACConditionType>
                <xsl:value-of select="@conditionType"/>
            </HVACConditionType>
            <xsl:call-template name="add-Area">
                <xsl:with-param name="Area" select="gb:Area"/>
                <xsl:with-param name="unit" select="gb:Area/@unit"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:BuildingSystems"/>
            <xsl:apply-templates select="gb:OccupantID"/>
            <xsl:apply-templates select="gb:MeetingEvent"/>
            <xsl:apply-templates select="gb:GroupPriority"/>
        </Space>
    </xsl:template>

    <xsl:template match="gb:BuildingStorey">
        <BuildingStorey ID="{@id}" Name="{gb:Name}">
            <xsl:call-template name="add-Level">
                <xsl:with-param name="Level" select="gb:Level"/>
                <xsl:with-param name="unit" select="gb:Level/@unit"/>
            </xsl:call-template>
        </BuildingStorey>
    </xsl:template>

    <!-- Template for Name element -->
    <xsl:template match="gb:Description">
        <Description>
            <xsl:value-of select="."/>
        </Description>
    </xsl:template>

   <xsl:template match="gb:ScheduleValue">
        <ScheduleValue>
            <xsl:call-template name="add-ScheduleValue">
                <xsl:with-param name="OutsideHighReset" select="@OutsideHighReset"/> 
                <xsl:with-param name="OutsideLowReset" select="@OutsideLowReset"/> 
                <xsl:with-param name="SupplyHighReset" select="@SupplyHighReset"/> 
                <xsl:with-param name="SupplyLowReset" select="@SupplyLowReset"/> 
            </xsl:call-template>
            <xsl:value-of select="."/>
        </ScheduleValue>
    </xsl:template>

    <xsl:template match="@spaceType">
        <xsl:choose>
            <xsl:when test=". = 'OfficeEnclosed' or . = 'OfficeOpenPlan'">
                <xsl:text>Office</xsl:text>
            </xsl:when>
            <xsl:when test=". = 'CorridorOrTransition' or . = 'CorridorOrTransitionManufacturingFacility' or . = 'CorridorsWithPatientWaitingExamHospitalOrHealthcare'">
                <xsl:text>Corridor</xsl:text>
            </xsl:when>
            <xsl:when test=". = 'ConferenceMeetingOrMultipurpose'">
                <xsl:text>MeetingRoom</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Other</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="gb:BuildingSystems">
        <Systems>
            <xsl:apply-templates select="gb:HVAC"/>
            <xsl:apply-templates select="gb:Lights"/>
            <xsl:apply-templates select="gb:Windows"/>
            <xsl:apply-templates select="gb:PlugLoad"/>
            <xsl:apply-templates select="gb:Thermostats"/>
            <xsl:apply-templates select="gb:ShadesAndBlinds"/>
        </Systems>
    </xsl:template>

    <xsl:template match="gb:HVAC">
        <HVAC>
            <xsl:if test="ancestor::gb:Space/gb:AirLoopEquipmentId/@airLoopEquipIdRef != ''">
                <xsl:attribute name="gbXMLAirLoopEquipmentIdRef">
                    <xsl:value-of select="ancestor::gb:Space/gb:AirLoopEquipmentId/@airLoopEquipIdRef"/>
                </xsl:attribute>
            </xsl:if>

            <HVACType>
                <xsl:value-of select="."/>
            </HVACType>
        </HVAC>
    </xsl:template>
    <xsl:template match="gb:Lights">
        <Lights>
            <xsl:if test="ancestor::gb:Space/gb:Lighting/@lightingSystemIdRef != ''">
                <xsl:attribute name="gbXMLLightingSystemIdRef">
                    <xsl:value-of select="ancestor::gb:Space/gb:Lighting/@lightingSystemIdRef"/>
                </xsl:attribute>
            </xsl:if>
            
            <LightType>
                <xsl:value-of select="."/>
            </LightType>
        </Lights>
    </xsl:template>
    <xsl:template match="gb:Windows">
        <Windows>
            <WindowType>
                <xsl:value-of select="."/>
            </WindowType>
        </Windows>
    </xsl:template>
    <xsl:template match="gb:PlugLoad">
        <PlugLoad>
            <xsl:if test="ancestor::gb:Space/gb:IntEquipId/@intEquipIdRef != ''">
                <xsl:attribute name="gbXMLInteriorEquipmentIdRef">
                    <xsl:value-of select="ancestor::gb:Space/gb:IntEquipId/@intEquipIdRef"/>
                </xsl:attribute>
            </xsl:if>
            
            <PlugLoadType>
                <xsl:value-of select="."/>
            </PlugLoadType>
        </PlugLoad>
    </xsl:template>
    <xsl:template match="gb:Thermostats">
        <Thermostats>
            <xsl:if test="ancestor::gb:Space/gb:AirLoopEquipmentId/@airLoopEquipIdRef != ''">
                <xsl:attribute name="gbXMLAirLoopEquipmentIdRef">
                    <xsl:value-of select="ancestor::gb:Space/gb:AirLoopEquipmentId/@airLoopEquipIdRef"/>
                </xsl:attribute>
            </xsl:if>

            <ThermostatType>
                <xsl:value-of select="."/>
            </ThermostatType>
        </Thermostats>
    </xsl:template>
    <xsl:template match="gb:ShadesAndBlinds">
        <ShadesAndBlinds>
            <ShadeAndBlindType>
                <xsl:value-of select="."/>
            </ShadeAndBlindType>
        </ShadesAndBlinds>
    </xsl:template>


    <!-- Match the OccupantID element and remove the namespace -->
    <xsl:template match="gb:OccupantID">
        <OccupantID>
            <xsl:value-of select="."/>
        </OccupantID>
    </xsl:template>

    <!-- Transform MeetingEvent elements -->
    <xsl:template match="gb:MeetingEvent">
        <!-- Explicitly create the MeetingEvent element without the namespace -->
        <MeetingEvent>
            <!-- Copy all child elements of MeetingEvent -->
            <xsl:apply-templates select="*"/>
        </MeetingEvent>
    </xsl:template>

    <!-- Transform MeetingEvent elements -->
    <xsl:template match="gb:GroupPriority">
        <!-- Explicitly create the MeetingEvent element without the namespace -->
        <MeetingEvent>
            <!-- Copy all child elements of MeetingEvent -->
            <xsl:apply-templates select="*"/>
        </MeetingEvent>
    </xsl:template>

    <!-- Generic template for child elements -->
    <xsl:template match="gb:*">
        <!-- Create the same element without namespace -->
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node() | @*"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
