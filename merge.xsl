<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/*/reports">
        <xsl:copy>
            <xsl:apply-templates select="report"/>
			<xsl:apply-templates select="document('Mar2008-Apr2008.xml')/*/report"/>
			<xsl:apply-templates select="document('May2008-Jun2008.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2008-Aug2008.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2008-Oct2008.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2008-Dec2008.xml')/*/report"/>
			<xsl:apply-templates select="document('Jan2009-Feb2009.xml')/*/report"/>
			<xsl:apply-templates select="document('Mar2009-Apr2009.xml')/*/report"/>
			<xsl:apply-templates select="document('May2009-Jun2009.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2009-Aug2009.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2009-Oct2009.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2009-Dec2009.xml')/*/report"/>
			<xsl:apply-templates select="document('Jan2010-Feb2010.xml')/*/report"/>
			<xsl:apply-templates select="document('Mar2010-Apr2010.xml')/*/report"/>
			<xsl:apply-templates select="document('May2010-Jun2010.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2010-Aug2010.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2010-Oct2010.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2010-Dec2010.xml')/*/report"/>
			<xsl:apply-templates select="document('Jan2011-Feb2011.xml')/*/report"/>
			<xsl:apply-templates select="document('Mar2011-Apr2011.xml')/*/report"/>
			<xsl:apply-templates select="document('May2011-Jun2011.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2011-Aug2011.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2011-Oct2011.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2011-Dec2011.xml')/*/report"/>
			<xsl:apply-templates select="document('Jan2012-Feb2012.xml')/*/report"/>
			<xsl:apply-templates select="document('Mar2012-Apr2012.xml')/*/report"/>
			<xsl:apply-templates select="document('May2012-Jun2012.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2012-Aug2012.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2012-Oct2012.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2012-Dec2012.xml')/*/report"/>
			<xsl:apply-templates select="document('Jan2013-Feb2013.xml')/*/report"/>
			<xsl:apply-templates select="document('Mar2013-Apr2013.xml')/*/report"/>
			<xsl:apply-templates select="document('May2013-Jun2013.xml')/*/report"/>
			<xsl:apply-templates select="document('Jul2013-Aug2013.xml')/*/report"/>
			<xsl:apply-templates select="document('Sep2013-Oct2013.xml')/*/report"/>
            <xsl:apply-templates select="document('Nov2013-Dec2013.xml')/*/report"/>
            <xsl:apply-templates select="document('Jan2014-now.xml')/*/report"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>