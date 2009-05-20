if exists("b:__XSLT_XPT_VIM__")
    finish
endif
let b:__XSLT_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ html/html
      \ xml/xml
      \ xml/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT sort hint=<xsl:sort\ ...
<xsl:sort select="`what^" />


XPT valueof hint=<xsl:value-of\ ...
<xsl:value-of select="`what^" />


XPT apply hint=<xsl:apply-templates\ ...
<xsl:apply-templates select="`what^" />


XPT param hint=<xsl:param\ ...
<xsl:param name="`name^" `select...^select="\`expr\^"^^ />


XPT import hint=<xsl:import\ ...
<xsl:import href="`URI^" />


XPT include hint=<xsl:include\ ...
<xsl:include href="`URI^" />


XPT stylesheet hint=<xsl:stylesheet\ ...
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="`cursor^/^">
    </xsl:template>
</xsl:stylesheet>


XPT template hint=<xsl:template\ match=\ ...
<xsl:template match="`match^">
    `cursor^
</xsl:template>


XPT foreach hint=<xsl:for-each\ select=\ ...
<xsl:for-each select="`match^">
    `cursor^
</xsl:for-each>


XPT if hint=<xsl:if\ test=\ ...
<xsl:if test="`test^">
    `cursor^
</xsl:if>


XPT choose hint=<xsl:choose\ ...
<xsl:choose>
  <xsl:when test="`expr^">
    `_^^
  </xsl:when>`...^
  <xsl:when test="`ex^">
    `what^
  </xsl:when>`...^
  `otherwise...^<xsl:otherwise>
    \`cursor\^
  </xsl:otherwise>^^
</xsl:choose>


XPT when hint=<xsl:when\ test=\ ...
<xsl:when test="`ex^">
  `what^
</xsl:when>


