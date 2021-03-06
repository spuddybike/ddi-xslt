<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g="ddi:group:3_1" xmlns:d="ddi:datacollection:3_1" xmlns:dce="ddi:dcelements:3_1"
    xmlns:c="ddi:conceptualcomponent:3_1" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:a="ddi:archive:3_1" xmlns:m1="ddi:physicaldataproduct/ncube/normal:3_1"
    xmlns:ddi="ddi:instance:3_1" xmlns:m2="ddi:physicaldataproduct/ncube/tabular:3_1"
    xmlns:l="ddi:logicalproduct:3_1" xmlns:m3="ddi:physicaldataproduct/ncube/inline:3_1"
    xmlns:pd="ddi:physicaldataproduct:3_1" xmlns:cm="ddi:comparative:3_1"
    xmlns:s="ddi:studyunit:3_1" xmlns:r="ddi:reusable:3_1" xmlns:pi="ddi:physicalinstance:3_1"
    xmlns:ds="ddi:dataset:3_1" xmlns:pr="ddi:profile:3_1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/sites/default/files/schema/ddi3.1/instance.xsd">

    <xsl:output method="text"/>

    <xsl:template match="/ddi:DDIInstance">
        <xsl:text>{"group": "","collection": "",</xsl:text>
        <xsl:apply-templates select="s:StudyUnit"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="s:StudyUnit">
        
        <!-- Country value. Set default 'Denmark' for DDA. If not available leave as empty value. -->
        <xsl:param name="country">
            <xsl:choose>
                <xsl:when test="//r:GeographicLocation/r:Values/r:GeographyValue[r:GeographyCode/r:Value[@codeListID='ISO3166-1']]/r:GeographyName[@xml:lang='en']">
                    <xsl:value-of select="//r:GeographicLocation/r:Values/r:GeographyValue[r:GeographyCode/r:Value[@codeListID='ISO3166-1']]/r:GeographyName[@xml:lang='en']"/>
                </xsl:when>
                <xsl:when test="@agency = 'dk.dda'">Denmark</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        
        <!-- study id -->
        <xsl:text>"id": "</xsl:text>
        <xsl:choose>
            <xsl:when test="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber">
                <xsl:value-of select="a:Archive/a:ArchiveSpecific/a:Collection/a:CallNumber"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@id"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="@version"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>",</xsl:text>
        
        <!-- repository -->
        <xsl:text>"repository": "</xsl:text><xsl:value-of select="@agency"/><xsl:text>",</xsl:text>
        
        <!-- analysis unit -->
        <xsl:text>"analysisunit": [ </xsl:text>
        <xsl:for-each select="r:AnalysisUnit">
            <xsl:text>{"en": "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- mode of collection  -->
        <xsl:text>"modeofcollection": [</xsl:text>
        <xsl:for-each select="//d:ModeOfCollection/r:Content">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- time method -->
        <xsl:text>"timemethod": [</xsl:text>
        <xsl:for-each select="//d:TimeMethod/r:Content">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- kind of data -->
        <xsl:text>"kindofdata": [</xsl:text>
        <xsl:for-each select="s:KindOfData">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- sampling procedure -->
        <xsl:text>"samplingprocedure": [</xsl:text>
        <xsl:for-each select="//d:SamplingProcedure/r:Content">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- country -->
        <xsl:text>"country": "</xsl:text>
        <xsl:value-of select="$country"/>
        <xsl:text>",</xsl:text>
        
        <!-- title -->
        <xsl:text>"title": [</xsl:text>
        <xsl:for-each select="r:Citation/r:Title">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            
            <!-- Get scope value and get rid of double quotation marks.  -->
            <xsl:call-template name="escapeQuote"/>
            
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        
        <!-- original (main) repository's landing page -->
        <xsl:if test="//a:Archive/a:ArchiveSpecific/a:Collection/a:URI">
            <xsl:text>"landingpage": "</xsl:text>
            <xsl:value-of select="normalize-space(//a:Archive/a:ArchiveSpecific/a:Collection/a:URI)"/>
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- creator -->
        <xsl:text>"creator": [</xsl:text>
        <xsl:for-each select="r:Citation/r:Creator">
            <xsl:text>{"</xsl:text>
            
            <!-- Differentiate between cases where xml:lang attr is given or not.  -->
            <xsl:choose>
                <xsl:when test="@xml:lang">
                    <xsl:value-of select="@xml:lang"/>
                    <xsl:text>": "</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>undefLang": "</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="@affiliation">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="@affiliation"/>
            </xsl:if>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>

        <!-- temporal coverage -->
        
        <!-- temporal coverage: start date -->
        <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate">
            <xsl:text>"startdate": "</xsl:text>
            
            <xsl:choose>
                <xsl:when test="contains(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate, 'T')">
                    <xsl:value-of
                    select="substring-before(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate, 'T')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:StartDate"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text>",</xsl:text>
        </xsl:if>
        <!-- temporal coverage: end date -->
        <xsl:if test="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate">
            <xsl:text>"enddate": "</xsl:text>
            
            <xsl:choose>
                <xsl:when test="contains(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate, 'T')">
                    <xsl:value-of
                        select="substring-before(r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate, 'T')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="r:Coverage/r:TemporalCoverage/r:ReferenceDate/r:EndDate"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text>",</xsl:text>
        </xsl:if>

        <!-- subject -->
        <xsl:if test="r:Coverage/r:TopicalCoverage/r:Subject">
            <xsl:text>"subject": [</xsl:text>
            <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Subject">
                <xsl:text>{"</xsl:text>
                <xsl:value-of select="@xml:lang"/>
                <xsl:text>": "</xsl:text>
                
                <!-- Get scope value and get rid of double quotation marks.  -->
                <xsl:call-template name="escapeQuote"/>
                
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>

        <!-- keywords -->
        <xsl:if test="r:Coverage/r:TopicalCoverage/r:Keyword">
            <xsl:text>"keyword": [</xsl:text>
            <xsl:for-each select="r:Coverage/r:TopicalCoverage/r:Keyword">
                <xsl:text>{"</xsl:text>
                <xsl:value-of select="@xml:lang"/>
                <xsl:text>": "</xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>

        <!-- abstract -->
        <xsl:text>"abstract": [</xsl:text>
        <xsl:for-each select="s:Abstract/r:Content">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            
            <!-- Get scope value and get rid of double quotation marks.  -->
            <xsl:call-template name="escapeQuote"/>
            
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>

        <!-- purpose -->
        <xsl:text>"purpose": [</xsl:text>
        <xsl:for-each select="s:Purpose/r:Content">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            
            <!-- Get scope value and get rid of double quotation marks.  -->
            <xsl:call-template name="escapeQuote"/>
            
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>

        <!-- variable concept universe question categories -->
        <xsl:if test="l:LogicalProduct/l:VariableScheme/l:Variable">
            <xsl:text>,</xsl:text>
            <xsl:apply-templates select="l:LogicalProduct/l:VariableScheme"/>
        </xsl:if>
    </xsl:template>

    <!-- variable concept universe question categories -->
    <xsl:template match="l:LogicalProduct/l:VariableScheme">
        <xsl:text>"variable": [</xsl:text>
        <xsl:for-each select="l:Variable">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
        <xsl:apply-templates select="l:VariableSchemeReference"/>
    </xsl:template>

    <xsl:template match="l:VariableSchemeReference">
        <xsl:variable name="vsID" select="r:ID"/>
        <xsl:apply-templates select="//l:VariableScheme[@id = $vsID]"/>
    </xsl:template>

    <xsl:template match="l:Variable">
        <!-- variable -->
        <xsl:text>{</xsl:text>
        <xsl:text>"id":"</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@version"/>
        <xsl:text>",</xsl:text>

        <xsl:text>"label":[</xsl:text>
        <xsl:for-each select="r:Label">
            <xsl:text>{"</xsl:text>
            <xsl:choose>
                <xsl:when test="@xml:lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>da</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>": "</xsl:text>
            <xsl:value-of select="replace(normalize-space(.), '&quot;', '')"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>

        <!-- concept -->
        <xsl:if test="l:ConceptReference">
            <xsl:text>, "concept":{</xsl:text>
            <xsl:for-each select="l:ConceptReference">
                <xsl:variable name="cID" select="r:ID"/>
                <xsl:text>"id":"</xsl:text>
                <xsl:for-each
                    select="//c:Concept[@id = $cID]">
                    <xsl:value-of select="$cID"/>:<xsl:value-of select="@version"/>
                    <xsl:text>","label":[</xsl:text>
                    <xsl:for-each select="r:Label">
                        <xsl:text>{"</xsl:text>
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>": "</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>"}</xsl:text>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                    <xsl:text>],"description":[</xsl:text>
                    <xsl:for-each select="r:Description">
                        <xsl:text>{"</xsl:text>
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>": "</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>"}</xsl:text>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                </xsl:for-each>
                <xsl:text>}</xsl:text>
            </xsl:for-each>
        </xsl:if>

        <!-- universe -->
        <xsl:if test="l:UniverseReference">
            <xsl:text>, "universe":[</xsl:text>
            <xsl:for-each select="l:UniverseReference">
                <xsl:variable name="uID" select="r:ID"/>
                <xsl:text>{"id":"</xsl:text>
                <xsl:for-each
                    select="//c:Universe[@id = $uID]">
                    <xsl:value-of select="$uID"/>:<xsl:value-of select="@version"/>
                    <xsl:text>","label":[</xsl:text>
                    <xsl:for-each select="r:Label">
                        <xsl:text>{"</xsl:text>
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>": "</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>"}</xsl:text>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                    <xsl:text>],"description":[</xsl:text>
                    <xsl:for-each select="c:HumanReadable">
                        <xsl:text>{"</xsl:text>
                        <xsl:value-of select="@xml:lang"/>
                        <xsl:text>": "</xsl:text>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>"}</xsl:text>
                        <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                </xsl:for-each>
                <xsl:text>}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xsl:if>

        <!-- question -->
        <xsl:if test="l:QuestionReference">
            <xsl:text>, "question":</xsl:text>
            <xsl:variable name="qiID" select="l:QuestionReference/r:ID"/>
            <xsl:choose>
                <xsl:when
                    test="//d:QuestionItem[@id = $qiID]">
                    <xsl:apply-templates
                        select="//d:QuestionItem[@id = $qiID]"
                    />
                </xsl:when>
                <xsl:when
                    test="//d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]">
                    <xsl:apply-templates
                        select="//d:MultipleQuestionItem/d:SubQuestions/d:QuestionItem[@id = $qiID]"
                    />
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <!-- categories -->
        <xsl:apply-templates select="l:Representation/l:TextRepresentation"/>
        <xsl:apply-templates select="l:Representation/l:NumericRepresentation"/>
        <xsl:apply-templates select="l:Representation/l:CodeRepresentation"/>

        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="d:QuestionItem">
        <xsl:text>{"id":"</xsl:text>
        <xsl:value-of select="@id"/>:<xsl:value-of select="@version"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"label":[</xsl:text>
        <xsl:for-each select="d:QuestionText">
            <xsl:text>{"</xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text>": "</xsl:text>
            <xsl:variable name="text">
                <xsl:value-of select="d:LiteralText/d:Text"/>
            </xsl:variable>
            <xsl:value-of select="normalize-space($text)"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>]}</xsl:text>
    </xsl:template>

    <xsl:template match="l:Representation/l:TextRepresentation">
        <xsl:text>, "representation": "TEXT"</xsl:text>
    </xsl:template>

    <xsl:template match="l:Representation/l:NumericRepresentation">
        <xsl:text>, "representation": "NUMERIC"</xsl:text>
    </xsl:template>

    <xsl:template match="l:Representation/l:CodeRepresentation">
        <xsl:text>, "representation": "CODE", "categories":[</xsl:text>
        <xsl:variable name="csID" select="r:CodeSchemeReference/r:ID"/>
        <xsl:for-each select="//l:CodeScheme[@id = $csID]/l:Code/l:CategoryReference/r:ID">
            <xsl:variable name="crID" select="."/>
            <xsl:for-each select="//l:Category[@id = $crID]/r:Label">
                <xsl:text>{"</xsl:text>
                <xsl:value-of select="@xml:lang"/>
                <xsl:text>": "</xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template name="escapeQuote">
        <xsl:param name="pText" select="normalize-space(.)"/>
        
        <xsl:if test="string-length($pText) >0">
            <xsl:value-of select=
                "substring-before(concat($pText, '&quot;'), '&quot;')"/>
            
            <xsl:if test="contains($pText, '&quot;')">
                <xsl:text>\"</xsl:text>
                
                <xsl:call-template name="escapeQuote">
                    <xsl:with-param name="pText" select=
                        "substring-after($pText, '&quot;')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
