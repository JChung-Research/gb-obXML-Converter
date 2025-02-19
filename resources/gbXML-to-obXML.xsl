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

    <xsl:template match="gb:BuildingStorey">
        <BuildingStorey ID="{@id}" Name="{gb:Name}">
            <xsl:call-template name="add-Level">
                <xsl:with-param name="Level" select="gb:Level"/>
                <xsl:with-param name="unit" select="gb:Level/@unit"/>
            </xsl:call-template>
        </BuildingStorey>
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

    <xsl:template name="add-SpaceAttributes">
        <xsl:param name="zoneIdRef"/>
        <xsl:param name="lightScheduleIdRef"/>
        <xsl:param name="equipmentScheduleIdRef"/>
        <xsl:param name="buildingStoreyIdRef"/>
        <xsl:if test="$zoneIdRef != ''">
            <xsl:attribute name="ZoneIdRef">
                <xsl:value-of select="$zoneIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$lightScheduleIdRef != ''">
            <xsl:attribute name="LightScheduleIdRef">
                <xsl:value-of select="$lightScheduleIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$equipmentScheduleIdRef != ''">
            <xsl:attribute name="PlugLoadScheduleIdRef">
                <xsl:value-of select="$equipmentScheduleIdRef"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$buildingStoreyIdRef != ''">
            <xsl:attribute name="BuildingStoreyIdRef">
                <xsl:value-of select="$buildingStoreyIdRef"/>
            </xsl:attribute>
        </xsl:if>
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

    <xsl:template match="gb:Space">
        <Space ID="{@id}" Name="{gb:Name}">
            <xsl:call-template name="add-SpaceAttributes">
                <xsl:with-param name="zoneIdRef" select="@zoneIdRef"/>
                <xsl:with-param name="lightScheduleIdRef" select="@lightScheduleIdRef"/>
                <xsl:with-param name="equipmentScheduleIdRef" select="@equipmentScheduleIdRef"/>
                <xsl:with-param name="buildingStoreyIdRef" select="@buildingStoreyIdRef"/>
            </xsl:call-template>
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
            <xsl:apply-templates select="gb:BuildingSystems"/>
            <xsl:if test="not(gb:BuildingSystems)">
                <xsl:call-template name="add-Systems">
                    <xsl:with-param name="spaceId" select="@id"/>
                    <xsl:with-param name="zoneIdRef" select="@zoneIdRef"/>
                    <xsl:with-param name="Lighting" select="gb:Lighting"/>
                    <xsl:with-param name="IntEquipId" select="gb:IntEquipId"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="add-Area">
                <xsl:with-param name="Area" select="gb:Area"/>
                <xsl:with-param name="unit" select="gb:Area/@unit"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:OccupantID"/>
            <xsl:apply-templates select="gb:MeetingEvent"/>
            <xsl:apply-templates select="gb:GroupPriority"/>
        </Space>
    </xsl:template>

    <xsl:template match="gb:OccupantID">
        <OccupantID>
            <xsl:value-of select="."/>
        </OccupantID>
    </xsl:template>

    <xsl:template match="gb:MeetingEvent">
        <MeetingEvent>
            <xsl:apply-templates select="*"/>
        </MeetingEvent>
    </xsl:template>

    <xsl:template match="gb:GroupPriority">
        <MeetingEvent>
            <xsl:apply-templates select="*"/>
        </MeetingEvent>
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

    <xsl:template name="add-ZoneAttributes">
        <xsl:param name="heatSchedIdRef"/>
        <xsl:param name="coolSchedIdRef"/>
        <xsl:param name="fanSchedIdRef"/>
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
    </xsl:template>

    <xsl:template name="add-Systems">
        <xsl:param name="spaceId"/>
        <xsl:param name="zoneIdRef"/>
        <xsl:param name="Lighting"/>
        <xsl:param name="IntEquipId"/>
        <xsl:variable name="zoneHVACEquipmentId" 
    select="/gb:gbXML/gb:Zone[@id = $zoneIdRef]/gb:ZoneHVACEquipmentId/@zoneHVACEquipmentIdRef" />
    
        <Systems>
            <xsl:if test="($zoneIdRef != '') and ($zoneHVACEquipmentId != '')">
                <HVAC>
                    <xsl:attribute name="gbXMLZoneHVACEquipmentIdRef">
                        <xsl:value-of select="$zoneHVACEquipmentId"/>
                    </xsl:attribute>
                    <HVACType>
                        <xsl:text>ZoneOnOff</xsl:text>
                    </HVACType>
                </HVAC>                
            </xsl:if>
            <xsl:if test="($zoneIdRef != '') and (/gb:gbXML/gb:Zone[@id = $zoneIdRef]/gb:AirLoopId/@airLoopIdRef != '')">
                <Thermostats>
                    <xsl:attribute name="gbXMLAirLoopIdRef">
                        <xsl:value-of select="/gb:gbXML/gb:Zone[@id = $zoneIdRef]/gb:AirLoopId/@airLoopIdRef"/>
                    </xsl:attribute>
                    <ThermostatType>
                        <xsl:text>Adjustable</xsl:text>
                    </ThermostatType>
                </Thermostats>
            </xsl:if>
            <xsl:if test="($zoneIdRef != '') and ($zoneHVACEquipmentId != '')">
                <xsl:variable name="airSystemIdRef" 
    select="/gb:gbXML/gb:ZoneHVACEquipment[@id = $zoneHVACEquipmentId]/gb:AirSystemId/@airSystemIdRef" />
                <Fans>
                    <xsl:attribute name="gbXMLFanIdRef">
                        <xsl:value-of select="$airSystemIdRef"/>
                    </xsl:attribute>                    
                    <FanType>
                        <xsl:if test="/gb:gbXML/gb:AirSystem[@id = $airSystemIdRef]/gb:Fan[@fanType = 'ConstantVolume']">
                            <xsl:text>HVACConstantVolume</xsl:text>
                        </xsl:if>
                        <xsl:if test="/gb:gbXML/gb:AirSystem[@id = $airSystemIdRef]/gb:Fan[@fanType = 'VariableVolume']">
                            <xsl:text>HVACVariableVolume</xsl:text>
                        </xsl:if>                        
                    </FanType>
                </Fans>
            </xsl:if>
            <xsl:if test="$Lighting/@lightingSystemIdRef != ''">
                <Lights>
                    <xsl:attribute name="gbXMLLightingSystemIdRef">
                        <xsl:value-of select="$Lighting/@lightingSystemIdRef"/>
                    </xsl:attribute>
                    <LightType>
                        <xsl:text>OnOff</xsl:text>
                    </LightType>
                </Lights>
            </xsl:if>            
            <xsl:if test="$IntEquipId/@intEquipIdRef != ''">
                <PlugLoad>
                    <xsl:attribute name="gbXMLInteriorEquipmentIdRef">
                        <xsl:value-of select="$IntEquipId/@intEquipIdRef"/>
                    </xsl:attribute>
                    <PlugLoadType>
                        <xsl:text>ContinuousControl</xsl:text>
                    </PlugLoadType>
                </PlugLoad>
            </xsl:if>
            <xsl:if test="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[@openingType = 'OperableWindow']/@id">
                <Windows>
                    <xsl:attribute name="gbXMLWindowIdRef">
                        <xsl:for-each select="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[@openingType = 'OperableWindow']">
                            <xsl:value-of select="@id"/>
                            <xsl:if test="position() != last()">,</xsl:if>
                        </xsl:for-each>
                    </xsl:attribute>
                    <WindowType>
                        <xsl:text>Operable</xsl:text>
                    </WindowType>
                </Windows>
            </xsl:if>
            <xsl:if test="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[@openingType = 'OperableWindow']/@windowTypeIdRef">
                <ShadesAndBlinds>
                    <xsl:attribute name="gbXMLBlindIdRef">
                        <xsl:variable name="windowTypeIdRef" select="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[@openingType = 'OperableWindow']/@windowTypeIdRef" />                       

                        <xsl:value-of select="/gb:gbXML/gb:WindowType[@id = $windowTypeIdRef]/gb:Blind/@id"/>
                    </xsl:attribute>
                    <ShadeAndBlindType>
                        <xsl:text>Operable</xsl:text>
                    </ShadeAndBlindType>
                </ShadesAndBlinds>
            </xsl:if>
            <xsl:if test="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[@openingType = 'NonSlidingDoor']/@id">
                <Doors>
                    <xsl:attribute name="gbXMLDoorIdRef">
                        <xsl:for-each select="//gb:Surface[gb:AdjacentSpaceId[@spaceIdRef = $spaceId]]/gb:Opening[(@openingType = 'NonSlidingDoor') or (@openingType = 'SlidingDoor')]">
                            <xsl:value-of select="@id"/>
                            <xsl:if test="position() != last()">,</xsl:if>
                        </xsl:for-each>
                    </xsl:attribute>
                    <DoorType>
                        <xsl:text>Operable</xsl:text>
                    </DoorType>
                </Doors>
            </xsl:if>
        </Systems>
    </xsl:template>

    <xsl:template name="add-Schedule">
        <xsl:param name="Name"/>
        <xsl:param name="scheduleType"/>        
        <xsl:if test="$Name != ''">
            <xsl:attribute name="Name">
                <xsl:value-of select="$Name"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$scheduleType != ''">
            <xsl:attribute name="ScheduleType">
                <xsl:value-of select="$scheduleType"/>
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
        <Schedule ID="{@id}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="@Name"/>
                <xsl:with-param name="scheduleType" select="@type"/>
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>   
            <xsl:apply-templates select="gb:YearSchedule"/>
        </Schedule>
    </xsl:template>

    <xsl:template match="gb:YearSchedule">
        <YearSchedule ID="{@id}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
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
        <WeekSchedule ID="{@id}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
                <xsl:with-param name="scheduleType" select="@scheduleType"/> 
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>        
            <DayScheduleId DayScheduleIdRef="{gb:Day/@dayScheduleIdRef}">                
                <xsl:value-of select="gb:Day"/>
                <xsl:apply-templates select="gb:Day/@dayType"/>
            </DayScheduleId>
        </WeekSchedule>
    </xsl:template>

    <xsl:template match="gb:DaySchedule">
        <DaySchedule ID="{@id}">
            <xsl:call-template name="add-Schedule">
                <xsl:with-param name="Name" select="gb:Name"/> 
                <xsl:with-param name="scheduleType" select="@scheduleType"/> 
            </xsl:call-template>
            <xsl:apply-templates select="gb:Description"/>         
            <xsl:apply-templates select="gb:ScheduleValue"/>
        </DaySchedule>
    </xsl:template>

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

    <xsl:template match="gb:Day/@dayType">
        <xsl:attribute name="DayofWeek">
            <xsl:choose>
                <xsl:when test=". = 'Weekday'">
                    <xsl:text>Weekdays</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Weekend' or . = 'WeekendOrHoliday'">
                    <xsl:text>Weekends</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Sun'">
                    <xsl:text>Sunday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Mon'">
                    <xsl:text>Monday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Tue'">
                    <xsl:text>Tuesday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Wed'">
                    <xsl:text>Wednesday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Thu'">
                    <xsl:text>Thursday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Fri'">
                    <xsl:text>Friday</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Custom'">
                    <xsl:text>PersonalHoliday</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
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
            <HVACType>
                <xsl:value-of select="."/>
            </HVACType>
        </HVAC>
    </xsl:template>
    <xsl:template match="gb:Lights">
        <Lights>            
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
            <PlugLoadType>
                <xsl:value-of select="."/>
            </PlugLoadType>
        </PlugLoad>
    </xsl:template>
    <xsl:template match="gb:Thermostats">
        <Thermostats>
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

    <xsl:template match="gb:*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node() | @*"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
