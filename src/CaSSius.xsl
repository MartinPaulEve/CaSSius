<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="xsi xs xlink mml">

    <xsl:output method="html" indent="yes" encoding="utf-8"/>

    <xsl:variable name="upperspecchars" select="'ÁÀÂÄÉÈÊËÍÌÎÏÓÒÔÖÚÙÛÜ'"/>
    <xsl:variable name="uppernormalchars" select="'AAAAEEEEIIIIOOOOUUUU'"/>
    <xsl:variable name="smallspecchars" select="'áàâäéèêëíìîïóòôöúùûü'"/>
    <xsl:variable name="smallnormalchars" select="'aaaaeeeeiiiioooouuuu'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="allcase" select="concat($smallcase, $uppercase)"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
                <meta http-equiv="Content-Style-Type" content="text/css" />

                <title><xsl:value-of select="//article-meta/title-group/article-title"/></title>

                <script src="https://unpkg.com/pagedjs/dist/paged.polyfill.js"></script>
                <script src="https://kit.fontawesome.com/1825af8a6a.js" crossorigin="anonymous"></script>


                <style>
                    :root{
                        font-size: 12px;
                    }

                    @page:first{
                        size: 6in 8in;
                        margin: 20mm 20mm 35mm 20mm;

                        @bottom-left {
                            content: "";
                            content: element(license);
                            width: 100%;
                        }
                        @bottom-center {

                        }
                        @bottom-right {
                            content: none;
                        }
                    }

                    @page{
                        size: 6in 8in;
                        margin: 20mm 20mm;
                        @bottom-left {
                            content: "Page " counter(page) "/" counter(pages);
                        }
                        @bottom-right {
                            content: '<xsl:value-of select="//surname" disable-output-escaping="no"/>, <xsl:value-of select="//year" disable-output-escaping="no"/>';
                        }
                    }

                    .license {
                        position: running(license);
                        font-size: smaller;
                        text-align: justify;
                    }

                    .fig {
                        break-inside: avoid;
                        text-align:center;
                    }

                </style>

                <link rel="stylesheet" type="text/css" href="CaSSius.css"/>

            </head>

            <body>
                <section>
                    <img src="logo.png" class="logo"/>
                    <br style="clear:both"/>
                    <h1><xsl:apply-templates select="//article-meta/title-group/article-title"/></h1>
                    <xsl:variable name="doi" select="//article-id[@pub-id-type='doi']"/>
                    <p><i><xsl:value-of select="//front/journal-meta//journal-title"/></i>, <xsl:value-of select="//front//volume"/>.<xsl:value-of select="//front//issue"/> (<xsl:value-of select="//pub-date//year"/>), <a><xsl:attribute
                            name="href"><xsl:if test="starts-with($doi, 'http')=false">https://doi.org/</xsl:if><xsl:value-of select="$doi"/></xsl:attribute><xsl:if test="starts-with($doi, 'http')=false">https://doi.org/</xsl:if><xsl:value-of select="$doi"/></a></p>
                    <hr/>
                    <p><xsl:call-template name="authors"/></p>
                    <p class="license"><xsl:value-of select="//article-meta/permissions/copyright-statement"/><xsl:text>. </xsl:text><xsl:value-of select="translate(//article-meta/permissions/license, '&#10;&#9;', '')"/></p>
                    <hr/>
                </section>
                <xsl:apply-templates select="//body/@* | //body/node()"/>
                <xsl:apply-templates select="//back/*"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="//body/@*">
        <xsl:copy>
            <xsl:apply-templates select="//body/@*"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template name="supplementary-material">
        <div id="supplementary-material">
            <xsl:if test="//supplementary-material[not(object-id)]">
                <ul class="supplementary-material">
                <xsl:for-each select="//supplementary-material[not(object-id)]/ext-link">
                    <li>
                        <a>
                            <xsl:attribute name="href"><xsl:value-of select="concat('[', @xlink:href, ']')"/></xsl:attribute>
                            <xsl:attribute name="download"/>
                            <xsl:apply-templates/>
                        </a>
                        <xsl:for-each select="../p">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </li>
                </xsl:for-each>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template name="authors">
        <xsl:for-each select="//article-meta/contrib-group/contrib">
                <xsl:choose>
                    <xsl:when test="name">
                        <p>
                        <xsl:choose>
                            <xsl:when test="contrib-id[@contrib-id-type='orcid']">
                                <xsl:variable name="orcid"><xsl:value-of select="contrib-id[@contrib-id-type='orcid']"/></xsl:variable>
                                <a><xsl:attribute name="href"><xsl:copy-of select="$orcid" /></xsl:attribute>
                                    <xsl:value-of select="concat(name/given-names, ' ', name/surname)"/>
                                    <xsl:if test="name/suffix">
                                        <xsl:value-of select="concat(' ', name/suffix)"/>
                                    </xsl:if>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(name/given-names, ' ', name/surname)"/>
                                <xsl:if test="name/suffix">
                                    <xsl:value-of select="concat(' ', name/suffix)"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="email"><xsl:text> </xsl:text><a><xsl:attribute name="href">mailto:<xsl:value-of select="email"/></xsl:attribute><i class="far fa-envelope"></i></a>
                        </xsl:if>
                        <xsl:if test="xref[@ref-type='aff']"><br/>
                            <xsl:variable name="affnumber"><xsl:value-of select="xref[@ref-type='aff']/@rid"/></xsl:variable>
                            <xsl:variable name="aff" select="//aff[@id=$affnumber]/child::text()"/>
                            <xsl:copy-of select="$aff"/>
                        </xsl:if>
                        </p>
                    </xsl:when>
                </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="metatags">
        <div id="metatags">
            <xsl:if test="//article-meta/permissions">
                <meta name="DC.Rights">
                    <xsl:attribute name="content">
                        <xsl:value-of select="//article-meta/permissions/copyright-statement"/><xsl:text>. </xsl:text><xsl:value-of select="translate(//article-meta/permissions/license, '&#10;&#9;', '')"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>
            <xsl:for-each select="//article-meta/contrib-group/contrib">
                <meta name="DC.Contributor">
                    <xsl:attribute name="content">
                        <xsl:choose>
                            <xsl:when test="name">
                                <xsl:value-of select="concat(name/given-names, ' ', name/surname)"/>
                                <xsl:if test="name/suffix">
                                    <xsl:value-of select="concat(' ', name/suffix)"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="collab">
                                <xsl:value-of select="collab"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </meta>
            </xsl:for-each>
            <xsl:for-each select="//funding-group/award-group">
                <meta name="citation_funding_source">
                    <xsl:attribute name="content">
                        <xsl:value-of select="concat('citation_funder=', .//institution, ';citation_grant_number=', award-id, ';citation_grant_recipient=')"/>
                        <xsl:value-of select="concat(principal-award-recipient/name/given-names, ' ', principal-award-recipient/name/surname)"/>
                        <xsl:for-each select="principal-award-recipient/name/suffix">
                            <xsl:value-of select="concat(' ', .)"/>
                        </xsl:for-each>
                    </xsl:attribute>
                </meta>
            </xsl:for-each>
            <xsl:for-each select="//article-meta/contrib-group/contrib[@contrib-type='author']">
                <xsl:variable name="type" select="@contrib-type"/>
                <meta name="citation_{$type}">
                    <xsl:attribute name="content">
                        <xsl:choose>
                            <xsl:when test="name">
                                <xsl:value-of select="concat(name/given-names, ' ', name/surname)"/>
                                <xsl:if test="name/suffix">
                                    <xsl:value-of select="concat(' ', name/suffix)"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="collab">
                                <xsl:value-of select="collab"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </meta>
                <xsl:for-each select="aff[not(@id)] | xref[@ref-type='aff'][@rid]">
                    <xsl:choose>
                        <xsl:when test="name() = 'aff'">
                            <xsl:for-each select="institution | email">
                                <meta name="citation_{$type}_{name()}">
                                    <xsl:attribute name="content">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>
                                </meta>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="name() = 'xref'">
                            <xsl:variable name="rid" select="@rid"/>
                            <xsl:for-each select="//aff[@id=$rid]/institution | //aff[@id=$rid]/email">
                                <meta name="citation_{$type}_{name()}">
                                    <xsl:attribute name="content">
                                        <xsl:value-of select="."/>
                                    </xsl:attribute>
                                </meta>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:if test="xref[@ref-type='corresp'][@rid]">
                    <xsl:variable name="rid" select="xref[@ref-type='corresp']/@rid"/>
                    <xsl:if test="//corresp[@id=$rid]/email">
                        <meta name="citation_{$type}_email">
                            <xsl:attribute name="content">
                                <xsl:value-of select="//corresp[@id=$rid]/email"/>
                            </xsl:attribute>
                        </meta>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="contrib-id[@contrib-id-type='orcid']">
                    <meta name="citation_{$type}_orcid">
                        <xsl:attribute name="content">
                            <xsl:value-of select="contrib-id[@contrib-id-type='orcid']"/>
                        </xsl:attribute>
                    </meta>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="//ref-list/ref">
                <xsl:variable name="citation_journal" select="element-citation[@publication-type='journal']/source"/>
                <xsl:variable name="citation_string">
                    <xsl:if test="$citation_journal">
                        <xsl:value-of select="concat(';citation_journal_title=', $citation_journal)"/>
                    </xsl:if>
                    <xsl:for-each select=".//person-group[@person-group-type='author']/name | .//person-group[@person-group-type='author']/collab">
                        <xsl:choose>
                            <xsl:when test="name() = 'name'">
                                <xsl:value-of select="concat(';citation_author=', given-names, '. ', surname)"/>
                                <xsl:if test="suffix">
                                    <xsl:value-of select="concat(' ', suffix)"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="name() = 'collab'">
                                <xsl:value-of select="concat(';citation_author=', .)"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select=".//article-title | element-citation[not(@publication-type='journal')]/source">
                        <xsl:value-of select="concat(';citation_title=', .)"/>
                    </xsl:for-each>
                    <xsl:if test=".//fpage">
                        <xsl:value-of select="concat(';citation_pages=', .//fpage)"/>
                        <xsl:if test=".//lpage">
                            <xsl:value-of select="concat('-', .//lpage)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test=".//volume">
                        <xsl:value-of select="concat(';citation_volume=', .//volume)"/>
                    </xsl:if>
                    <xsl:if test=".//year">
                        <xsl:value-of select="concat(';citation_year=', .//year)"/>
                    </xsl:if>
                    <xsl:if test=".//pub-id[@pub-id-type='doi']">
                        <xsl:value-of select="concat(';citation_doi=', .//pub-id[@pub-id-type='doi'])"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="string-length($citation_string)>1">
                    <meta name="citation_reference">
                        <xsl:attribute name="content">
                            <xsl:value-of select="substring-after($citation_string, ';')"/>
                        </xsl:attribute>
                    </meta>
                </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="article-meta/title-group/article-title">
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="custom-meta-group">
        <xsl:if test="custom-meta[@specific-use='meta-only']/meta-name[text()='Author impact statement']/following-sibling::meta-value">
            <div id="impact-statement">
                <xsl:apply-templates select="custom-meta[@specific-use='meta-only']/meta-name[text()='Author impact statement']/following-sibling::meta-value/node()"/>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Author list -->
    <xsl:template match="contrib-group[not(@content-type)]">
        <xsl:apply-templates/>
        <xsl:if test="contrib[@contrib-type='author'][not(@id)]">
            <div id="author-info-group-authors">
                <xsl:apply-templates select="contrib[@contrib-type='author'][not(@id)]"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="contrib[@contrib-type='author'][not(@id)]">
        <xsl:apply-templates select="collab"/>
    </xsl:template>

    <xsl:template match="contrib//collab">
        <h4 class="equal-contrib-label">
            <xsl:apply-templates/>
        </h4>
        <xsl:variable name="contrib-id">
            <xsl:apply-templates select="../contrib-id"/>
        </xsl:variable>
        <xsl:if test="../../..//contrib[@contrib-type='author non-byline']/contrib-id[text()=$contrib-id]">
            <ul>
                <xsl:for-each
                        select="../../..//contrib[@contrib-type='author non-byline']/contrib-id[text()=$contrib-id]">
                    <li>
                        <xsl:if test="position()=1">
                            <xsl:attribute name="class">
                                <xsl:value-of select="'first'"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="position()=last()">
                            <xsl:attribute name="class">
                                <xsl:value-of select="'last'"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="../name/given-names"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="../name/surname"/>
                        <xsl:text>, </xsl:text>
                        <xsl:for-each select="../aff">
                            <xsl:call-template name="collabaff"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template name="collabaff">
        <span class="aff">
            <xsl:for-each select="@* | node()">
                <xsl:choose>
                    <xsl:when test="name() = 'institution'">
                        <span class="institution">
                            <xsl:value-of select="."/>
                        </span>
                    </xsl:when>
                    <xsl:when test="name()='country'">
                        <span class="country">
                            <xsl:value-of select="."/>
                        </span>
                    </xsl:when>
                    <xsl:when test="name()='addr-line'">
                        <span class="addr-line">
                            <xsl:apply-templates mode="authorgroup"/>
                        </span>
                    </xsl:when>
                    <xsl:when test="name()=''">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="{name()}">
                            <xsl:value-of select="."/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

        </span>
    </xsl:template>

    <xsl:template match="addr-line/named-content" mode="authorgroup">
        <span class="named-content">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- ==== FRONT MATTER START ==== -->

    <xsl:template match="surname | given-names | name">
        <span class="nlm-given-names">
            <xsl:value-of select="given-names"/>
        </span>
        <xsl:text> </xsl:text>
        <span class="nlm-surname">
            <xsl:value-of select="surname"/>
        </span>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="name"/>
    </xsl:template>

    <!-- ==== Data set start ==== -->
    <xsl:template match="sec[@sec-type='datasets']">
        <div id="datasets">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="sec[@sec-type='datasets']/title"/>
    <xsl:template match="related-object">
        <span class="{name()}">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/collab">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/name">
        <span class="name">
            <xsl:value-of select="surname"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="given-names"/>
            <xsl:if test="suffix">
                <xsl:text> </xsl:text>
                <xsl:value-of select="suffix"/>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="related-object/year">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/source">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/x">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/etal">
        <span class="{name()}">
            <xsl:text>et al.</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="related-object/comment">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="related-object/object-id">
        <span class="{name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- author-notes -->
    <xsl:template match="author-notes">
        <xsl:apply-templates/>
        <xsl:if test="fn[@fn-type='present-address']">
            <div id="author-info-additional-address">
                <ul class="additional-address-items">
                    <xsl:apply-templates select="fn[@fn-type='present-address']"/>
                </ul>
            </div>
        </xsl:if>

        <xsl:if test="fn[@fn-type='con'] | fn[@fn-type='other'] | fn[@fn-type='deceased']">
            <div id="author-info-equal-contrib">
                <xsl:apply-templates select="fn[@fn-type='con']"/>
            </div>
            <div id="author-info-other-footnotes">
                <xsl:apply-templates select="fn[@fn-type='other']"/>
                <xsl:apply-templates select="fn[@fn-type='deceased']"/>
            </div>
        </xsl:if>
        <div id="author-info-contributions">
            <xsl:apply-templates select="ancestor::article/back//fn-group[@content-type='author-contribution']"/>
        </div>
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='con']">
        <section class="equal-contrib">
                <xsl:apply-templates/>:
            <xsl:variable name="contriputeid">
                <xsl:value-of select="@id"/>
            </xsl:variable>
            <ul class="equal-contrib-list">
                <xsl:for-each select="../../contrib-group/contrib/xref[@rid=$contriputeid]">
                    <li class="equal-contributor">
                        <xsl:value-of select="../name/given-names"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="../name/surname"/>
                    </li>
                </xsl:for-each>
            </ul>
        </section>
    </xsl:template>

    <xsl:template match="fn-group">
        <h2>Notes</h2>
        <ol class="footnotes">
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="fn-group/fn">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="fn-group/fn/p">
        <xsl:variable name="fn-number">
            <xsl:number level="any" count="fn[not(ancestor::front)]" from="article | sub-article | response"/>
        </xsl:variable>
        <xsl:apply-templates/> [<span class="footnotemarker" id="fn{$fn-number}"></span><span class="footnotemarker" id="n{$fn-number}"><a href="#nm{$fn-number}"><sup>^</sup></a></span>]
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='con']/p">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='other'] | author-notes/fn[@fn-type='deceased']">
        <xsl:variable name="fnid">
            <xsl:value-of select="@id"/>
        </xsl:variable>
        <div class="foot-note" id="{$fnid}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='other']/p | author-notes/fn[@fn-type='deceased']/p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="author-notes/corresp">
        <li>
            <xsl:apply-templates select="email" mode="corresp"/>
        </li>
    </xsl:template>

    <xsl:template match="email" mode="corresp">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('mailto:',.)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
        <xsl:variable name="contriputeid">
            <xsl:value-of select="../@id"/>
        </xsl:variable>
        <xsl:variable name="given-names">
            <xsl:choose>
                <xsl:when test="../../../contrib-group/contrib/xref[@rid=$contriputeid][1]/../name/given-names">
                    <xsl:value-of select="../../../contrib-group/contrib/xref[@rid=$contriputeid][1]/../name/given-names"/>
                </xsl:when>
                <xsl:when test="ancestor::contrib/name/given-names">
                    <xsl:value-of select="ancestor::contrib/name/given-names"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="surname">
            <xsl:choose>
                <xsl:when test="../../../contrib-group/contrib/xref[@rid=$contriputeid][1]/../name/surname">
                    <xsl:value-of select="../../../contrib-group/contrib/xref[@rid=$contriputeid][1]/../name/surname"/>
                </xsl:when>
                <xsl:when test="ancestor::contrib/name/surname">
                    <xsl:value-of select="ancestor::contrib/name/surname"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$given-names != '' and $surname != ''">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="translate($given-names, concat($smallcase, $smallspecchars, '. '), '')"/>
            <xsl:value-of select="translate($surname, concat($smallcase, $smallspecchars, '. '), '')"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='present-address']">
        <li>
            <span class="present-address-intials">
                <xsl:variable name="contriputeid">
                    <xsl:value-of select="@id"/>
                </xsl:variable>
                <xsl:for-each select="../../contrib-group/contrib/xref[@rid=$contriputeid]">
                    <xsl:text>--</xsl:text>
                    <xsl:value-of select="translate(../name/given-names, concat($smallcase, '. '), '')"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="translate(../name/surname, concat($smallcase, '. '), '')"/>
                    <xsl:text>:</xsl:text>
                </xsl:for-each>
            </span>
            <xsl:text> Present address:</xsl:text>
            <br/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="author-notes/fn[@fn-type='present-address']/p">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- funding-group -->
    <xsl:template match="funding-group">
        <div id="author-info-funding">
            <ul class="funding-group">
                <xsl:apply-templates/>
            </ul>
            <xsl:if test="funding-statement">
                <p class="funding-statement">
                    <xsl:value-of select="funding-statement"/>
                </p>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="funding-group/award-group">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="funding-source">
        <h4 class="funding-source">
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    <xsl:template match="funding-source/institution-wrap">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="institution">
        <span class="institution">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="award-id">
        <h5 class="award-id">
            <xsl:apply-templates/>
        </h5>
    </xsl:template>

    <xsl:template match="principal-award-recipient">
        <ul class="principal-award-recipient">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template
            match="principal-award-recipient/surname | principal-award-recipient/given-names | principal-award-recipient/name">
        <li class="name">
            <xsl:value-of select="given-names"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="surname"/>
        </li>
        <xsl:value-of select="name"/>
    </xsl:template>

    <xsl:template match="funding-statement" name="funding-statement">
        <p class="funding-statement">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="funding-statement"/>
    <!-- fn-group -->

    <xsl:template name="article-info-history">
        <div>
            <xsl:attribute name="id"><xsl:value-of select="'article-info-history'"/></xsl:attribute>
            <ul>
                <xsl:attribute name="class"><xsl:value-of select="'publication-history'"/></xsl:attribute>
                <xsl:for-each select="//history/date[@date-type]">
                    <xsl:apply-templates select="." mode="publication-history-item"/>
                </xsl:for-each>
                <xsl:apply-templates select="//article-meta/pub-date[@date-type]" mode="publication-history-item">
                    <xsl:with-param name="date-type" select="'published'"/>
                </xsl:apply-templates>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="date | pub-date" mode="publication-history-item">
        <xsl:param name="date-type" select="string(@date-type)"/>
        <li>
            <xsl:attribute name="class"><xsl:value-of select="$date-type"/></xsl:attribute>
            <span>
                <xsl:attribute name="class"><xsl:value-of select="concat($date-type, '-label')"/></xsl:attribute>
                <xsl:call-template name="camel-case-word"><xsl:with-param name="text" select="$date-type"/></xsl:call-template>
            </span>
            <xsl:variable name="month-long">
                <xsl:call-template name="month-long">
                    <xsl:with-param name="month"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat(' ', $month-long, ' ', day, ', ', year, '.')"/>
        </li>
    </xsl:template>
    <xsl:template match="fn-group[@content-type='ethics-information']">
        <div id="article-info-ethics">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="fn-group[@content-type='ethics-information']/fn">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="fn-group[@content-type='ethics-information']/title"/>
    <xsl:template match="contrib[@contrib-type='editor']" mode="article-info-reviewing-editor">
        <div id="article-info-reviewing-editor">
            <div>
                <xsl:attribute name="class"><xsl:value-of select="'acta-article-info-reviewingeditor-text'"/></xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="fn-group[@content-type='competing-interest']">
        <div id="author-info-competing-interest">
            <ul class="fn-conflict">
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="fn-group[@content-type='competing-interest']/fn">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!-- permissions -->
    <xsl:template match="permissions">
        <div>
            <xsl:choose>
                <xsl:when test="parent::article-meta">
                    <xsl:attribute name="id">
                        <xsl:value-of select="'article-info-license'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'copyright-and-license'"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
            <xsl:if test="parent::article-meta">
                <xsl:apply-templates select="//body//permissions"/>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="permissions/copyright-statement">
        <ul class="copyright-statement">
            <li>
                <xsl:apply-templates/>
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="license">
        <div class="license">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="license-p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- Affiliations -->
    <xsl:template match="aff[@id]">
        <div id="{@id}">
            <span class="aff">
                <xsl:apply-templates/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="aff" mode="affiliation-details">
        <span class="aff">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff/institution">
        <span class="institution">
            <xsl:if test="@content-type">
                <xsl:attribute name="data-content-type">
                    <xsl:value-of select="@content-type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff/addr-line">
        <span class="addr-line">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="addr-line/named-content">
        <span class="named-content">
            <xsl:if test="@content-type">
                <xsl:attribute name="data-content-type">
                    <xsl:value-of select="@content-type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff/country">
        <span class="country">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff/x">
        <span class="x">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff//bold">
        <span class="bold">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff//italic">
        <span class="italic">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="aff/email">
        <xsl:variable name="email">
            <xsl:apply-templates/>
        </xsl:variable>
        <!-- if parent contains more than just email then it should have a space before email -->
        <xsl:if test="string(..) != text() and not(contains(string(..), concat(' ', text())))">
            <xsl:text> </xsl:text>
        </xsl:if>
        <a href="mailto:{$email}" class="email">
            <xsl:copy-of select="$email"/>
        </a>
    </xsl:template>

    <!-- ==== FRONT MATTER END ==== -->

    <xsl:template match="abstract">
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <div data-doi="{$data-doi}">
            <xsl:choose>
                <xsl:when test="./title">
                    <xsl:attribute name="id">
                        <xsl:value-of select="translate(translate(./title, $uppercase, $smallcase), ' ', '-')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="id">
                        <xsl:value-of select="name(.)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Start transforming sections to heading levels -->
    <xsl:template match="supplementary-material">
        <xsl:variable name="id">
            <xsl:value-of select="@id"/>
        </xsl:variable>
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <div class="supplementary-material" data-doi="{$data-doi}">
            <div class="supplementary-material-expansion" id="{$id}">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <!-- No need to proceed sec-type="additional-information", sec-type="supplementary-material" and sec-type="datasets"-->
    <xsl:template match="sec[not(@sec-type='additional-information')][not(@sec-type='datasets')][not(@sec-type='supplementary-material')]">
        <div>
            <xsl:if test="@sec-type">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('section ', ./@sec-type)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*[name()!='sec-type'] | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="sec[not(@sec-type='datasets')]/title | boxed-text/caption/title">
        <xsl:if test="node() != ''">
            <xsl:element name="h{count(ancestor::sec) + 1}">
                <xsl:apply-templates select="@* | node()"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="app//sec/title">
        <xsl:element name="h{count(ancestor::sec) + 3}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    <!-- END transforming sections to heading levels -->

    <xsl:template match="p">
        <xsl:if test="not(supplementary-material)">
            <p>
                <xsl:if test="ancestor::caption and (count(preceding-sibling::p) = 0) and (ancestor::boxed-text or ancestor::media)">
                    <xsl:attribute name="class">
                        <xsl:value-of select="'first-child'"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </xsl:if>
        <xsl:if test="supplementary-material">
            <xsl:if test="ancestor::caption and (count(preceding-sibling::p) = 0) and (ancestor::boxed-text or ancestor::media)">
                <xsl:attribute name="class">
                    <xsl:value-of select="'first-child'"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ext-link">
        <xsl:if test="@ext-link-type = 'uri'">
            <a>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="starts-with(@xlink:href, 'www.')">
                            <xsl:value-of select="concat('http://', @xlink:href)"/>
                        </xsl:when>
                        <xsl:when test="starts-with(@xlink:href, 'doi:')">
                            <xsl:value-of select="concat('http://dx.doi.org/', substring-after(@xlink:href, 'doi:'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@xlink:href"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test="@ext-link-type = 'doi'">
            <a>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="starts-with(@xlink:href, '10.7554/')">
                            <xsl:value-of select="concat('/lookup/doi/', @xlink:href)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('http://dx.doi.org/', @xlink:href)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>

    <!-- START handling citation objects -->
    <xsl:template match="xref">
        <xsl:choose>
            <xsl:when test="ancestor::fn">
                <span class="xref-table">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="concat('xref-', ./@ref-type)"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <!-- If xref has multiple elements in rid, then the link should points to 1st -->
                        <xsl:choose>
                            <xsl:when test="contains(@rid, ' ')">
                                <xsl:value-of select="concat('#',substring-before(@rid, ' '))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#',@rid)"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:attribute>

                    <xsl:choose>
                    <xsl:when test="contains(@ref-type, 'fn')">
                        <xsl:attribute name="id">
                            <xsl:text>nm</xsl:text>
                            <xsl:number level="any" count="xref[@ref-type='fn']"/>
                        </xsl:attribute>
                        <sup><xsl:apply-templates/></sup>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- END handling citation objects -->

    <!-- START Table Handling -->
    <xsl:template match="table-wrap">
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <div class="table-wrap" data-doi="{$data-doi}">
            <xsl:apply-templates select="." mode="testing"/>
        </div>
    </xsl:template>

    <xsl:template match="table-wrap/label" mode="captionLabel">
        <span class="table-label">
            <xsl:apply-templates/>
        </span>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="caption">
        <xsl:choose>
            <!-- if article-title exists, make it as title.
                     Otherwise, make source -->
            <xsl:when test="parent::table-wrap">
                <xsl:if test="following-sibling::graphic">
                    <xsl:variable name="caption" select="parent::table-wrap/label/text()"/>
                    <xsl:variable name="graphics" select="following-sibling::graphic/@xlink:href"/>
                    <div class="fig-inline-img">
                            <img data-img="{$graphics}" src="{$graphics}" alt="{$caption}" class="responsive-img" />
                    </div>
                </xsl:if>
                <div class="table-caption">
                    <xsl:apply-templates select="parent::table-wrap/label" mode="captionLabel"/>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table-wrap/table">
        <table class="striped">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <!-- Handle other parts of table -->
    <xsl:template match="thead | tr">
        <xsl:copy>
            <xsl:if test="@style">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tbody">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="th | td">
        <xsl:copy>
            <xsl:if test="@rowspan">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="@rowspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@colspan">
                <xsl:attribute name="colspan">
                    <xsl:value-of select="@colspan"/>
                </xsl:attribute>
            </xsl:if>

            <!-- The author-callout-style-b family applies both background and foreground colour. -->
            <xsl:variable name="class">
                <xsl:if test="@align">
                    <xsl:value-of select="concat(' table-', @align)"/>
                </xsl:if>
                <xsl:if test="@style and starts-with(@style, 'author-callout-style-b')">
                    <xsl:value-of select="concat(' ', @style)"/>
                </xsl:if>
            </xsl:variable>

            <xsl:if test="$class != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="substring-after($class, ' ')"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="@style and not(starts-with(@style, 'author-callout-style-b'))">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- Handle Table FootNote -->
    <xsl:template match="table-wrap-foot">
        <div class="table-foot">
            <ul class="table-footnotes">
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="table-wrap-foot/fn">
        <li class="fn">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="named-content">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
                <xsl:if test="@content-type">
                    <xsl:value-of select="concat(' ', @content-type)"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="inline-formula">
        <span class="inline-formula">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- MathML Inline -->
  <xsl:template match="alternatives/mml:math">
    <span class="inline-formula mathml">
      <math xmlns:mml="http://www.w3.org/1998/Math/MathML">
      <xsl:copy-of select="text() | *"/>
    </math>
    </span>
  </xsl:template>

  <xsl:template match="alternatives/tex-math">
  </xsl:template>

  <xsl:template match="alternatives/graphic">
  </xsl:template>

    <xsl:template match="disp-formula">
        <p class="disp-formula">
            <xsl:if test="@id">
                <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="label">
                <span class="disp-formula-label">
                    <xsl:value-of select="label/text()"/>
                </span>
            </xsl:if>
        </p>
    </xsl:template>


      <xsl:template match="disp-formula/tex-math">
    <div class="formula tex-math hidden">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </div>
  </xsl:template>

  <xsl:template match="inline-formula/tex-math">
    <span class="inline-formula tex-math hidden">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </span>
  </xsl:template>

  <!-- MathML Inline -->
  <xsl:template match="inline-formula/mml:math">
    <span class="inline-formula mathml">
      <math xmlns:mml="http://www.w3.org/1998/Math/MathML">
      <xsl:copy-of select="text() | *"/>
    </math>
    </span>
  </xsl:template>

  <!-- MathML in Div -->
  <xsl:template match="disp-formula/mml:math">
    <div class="math-formulae mathml">
      <math xmlns:mml="http://www.w3.org/1998/Math/MathML">
      <xsl:copy-of select="text() | *"/>
    </math>
    </div>
  </xsl:template>

    <!-- END Table Handling -->

    <!-- Start Figure Handling -->
    <!-- fig with atrtribute specific-use are supplement figures -->

    <!-- NOTE: PATH/LINK to be replaced -->
    <xsl:template match="fig-group">
        <!-- set main figure's DOI -->
        <xsl:variable name="data-doi" select="child::fig[1]/object-id[@pub-id-type='doi']/text()"/>
        <div class="fig-group" id="{concat('fig-group-', count(preceding::fig-group)+1)}" data-doi="{$data-doi}">
            <xsl:apply-templates select="." mode="testing"/>
        </div>
    </xsl:template>


    <xsl:template match="fig | table-wrap | boxed-text | supplementary-material | media" mode="dc-description">
        <xsl:param name="doi"/>
        <xsl:variable name="data-dc-description">
            <xsl:if test="caption/title">
                <xsl:value-of select="concat(' ', caption/title)"/>
            </xsl:if>
            <xsl:for-each select="caption/p">
                <xsl:if test="not(ext-link[@ext-link-type='doi']) and not(.//object-id[@pub-id-type='doi'])">
                    <xsl:value-of select="concat(' ', .)"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <div data-dc-description="{$doi}">
            <xsl:value-of select="substring-after($data-dc-description, ' ')"/>
        </div>
    </xsl:template>

    <!-- individual fig in fig-group -->

    <xsl:template match="fig">
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <div class="fig" data-doi="{$data-doi}">
            <xsl:apply-templates select="." mode="testing"/>
        </div>
    </xsl:template>

    <!-- fig caption -->
    <xsl:template match="fig//caption">
        <xsl:variable name="graphic-type">
            <xsl:choose>
                <xsl:when test="substring-after(../graphic/@xlink:href, '.') = 'gif'">
                    <xsl:value-of select="'animation'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'graphic'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(parent::supplementary-material)">
                <div class="fig-caption">
                    <xsl:variable name="graphics" select="../graphic/@xlink:href"/>

                    <span class="fig-label">
                        <xsl:value-of select="../label/text()"/>
                    </span>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../label" mode="supplementary-material"/>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="supplementary-material/label">
        <xsl:apply-templates select="." mode="supplementary-material"/>
    </xsl:template>

    <xsl:template match="label" mode="supplementary-material">
        <span class="supplementary-material-label">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="fig//caption/title | supplementary-material/caption/title">
        <span class="caption-title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- END Figure Handling -->

    <!-- body content -->
    <xsl:template match="body">
        <div class="acta-article-decision-letter">
            <xsl:apply-templates/>
        </div>
        <div id='main-text'>
            <div class="article fulltext-view">
                <xsl:apply-templates mode="testing"/>
                <xsl:call-template name="appendices-main-text"/>
            </div>
        </div>
        <div id="main-figures">
            <xsl:for-each select=".//fig[not(@specific-use)][not(parent::fig-group)] | .//fig-group">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template
            match="sec[not(@sec-type='additional-information')][not(@sec-type='datasets')][not(@sec-type='supplementary-material')]"
            mode="testing">
        <div>
            <xsl:if test="@sec-type">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('section ', translate(./@sec-type, '|', '-'))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not(@sec-type)">
                <xsl:attribute name="class">
                    <xsl:value-of select="'subsection'"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="testing"/>
        </div>
    </xsl:template>

    <xsl:template match="xref" mode="testing">
        <xsl:choose>
            <xsl:when test="ancestor::fn">
                <span class="xref-table">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="concat('xref-', ./@ref-type)"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <!-- If xref has multiple elements in rid, then the link should points to 1st -->
                        <xsl:choose>
                            <xsl:when test="contains(@rid, ' ')">
                                <xsl:value-of select="concat('#',substring-before(@rid, ' '))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#',@rid)"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table-wrap" mode="testing">
        <div class="table-expansion">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="boxed-text" mode="testing">
        <!-- For the citation links, take the id from the boxed-text -->
        <xsl:choose>
            <xsl:when test="child::object-id[@pub-id-type='doi']/text()!=''">
                <div class="boxed-text">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'boxed-text'"/>
                        <xsl:if test="//article/@article-type != 'research-article' and .//inline-graphic">
                            <xsl:value-of select="' insight-image'"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//graphic[not(ancestor::fig) and not(ancestor::alternatives)]">
        <xsl:variable name="caption" select="child::caption/text()"/>
        <xsl:variable name="graphics" select="./@xlink:href"/>
        <div class="fig-inline-img-set">
            <div class="acta-fig-image-caption-wrapper">
                <div class="fig-expansion">
                    <div class="fig-inline-img">
                            <img data-img="{$graphics}" src="{$graphics}" alt="{$caption}"/>
                    </div>
                    <xsl:apply-templates/>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template match="fig" mode="testing">
        <xsl:variable name="caption" select="child::label/text()"/>
        <xsl:variable name="id">
            <xsl:value-of select="@id"/>
        </xsl:variable>
        <xsl:variable name="graphic-type">
            <xsl:choose>
                <xsl:when test="substring-after(child::graphic/@xlink:href, '.') = 'gif'">
                    <xsl:value-of select="'animation'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'graphic'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="graphics" select="graphic/@xlink:href"/>
        <div id="{$id}" class="fig-inline-img-set">
            <div class="acta-fig-image-caption-wrapper">
                <div class="fig-expansion">
                    <div class="fig-inline-img">
                        <img data-img="{$graphics}" src="{$graphics}" alt="{$caption}" class="responsive-img" />
                    </div>
                    <xsl:apply-templates/>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="fig-group" mode="testing">
        <!-- set main figure's DOI -->
        <div class="fig-inline-img-set-carousel">
            <div class="acta-fig-slider-wrapper">
                <div class="acta-fig-slider">
                    <div class="acta-fig-slider-img acta-fig-slider-primary">
                        <!-- use variables to set src and alt -->
                        <xsl:variable name="primaryid" select="concat('#', child::fig[not(@specific-use)]/@id)"/>
                        <xsl:variable name="primarycap" select="child::fig[not(@specific-use)]//label/text()"/>
                        <xsl:variable name="graphichref" select="substring-before(concat(child::fig[not(@specific-use)]/graphic/@xlink:href, '.'), '.')"/>
                        <a href="{$primaryid}">
                            <img src="{$graphichref}" alt="{$primarycap}" class="responsive-img"/>
                        </a>
                    </div>
                    <div class="figure-carousel-inner-wrapper">
                        <div class="figure-carousel">
                            <xsl:for-each select="child::fig[@specific-use]">
                                <!-- use variables to set src and alt -->
                                <xsl:variable name="secondarycap" select="child::label/text()"/>
                                <xsl:variable name="secgraphichref" select="substring-before(concat(child::graphic/@xlink:href, '.'), '.')"/>
                                <div class="acta-fig-slider-img acta-fig-slider-secondary">
                                    <a href="#{@id}">
                                        <img src="{$secgraphichref}" alt="{$secondarycap}" class="responsive-img"/>
                                    </a>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
            </div>
            <div class="acta-fig-image-caption-wrapper">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="media" mode="testing">
        <xsl:choose>
            <xsl:when test="@mimetype != 'video'">
                <xsl:variable name="media-download-href"><xsl:value-of select="concat(substring-before(@xlink:href, '.'), '-download.', substring-after(@xlink:href, '.'))"/></xsl:variable>
                <!-- if mimetype is application -->
                <span class="inline-linked-media-wrapper">
                    <a href="{$media-download-href}">
                        <xsl:attribute name="download"/>
                        <i class="icon-download-alt"></i>
                        Download source data<span class="inline-linked-media-filename">
                            [<xsl:value-of
                                select="translate(translate(preceding-sibling::label, $uppercase, $smallcase), ' ', '-')"/>media-<xsl:value-of
                                select="count(preceding::media[@mimetype = 'application']) + 1"/>.<xsl:value-of
                                select="substring-after(@xlink:href, '.')"/>]
                        </span>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <!-- otherwise -->
                <div class="media video-content">
                    <!-- set attribute -->
                    <xsl:attribute name="id">
                        <!-- <xsl:value-of select="concat('media-', @id)"/>-->
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <div class="media-inline video-inline">
                        <div class="acta-inline-video">
                            <xsl:text> [video-</xsl:text><xsl:value-of select="@id"/><xsl:text>-inline] </xsl:text>

                            <div class="acta-video-links">
                                <span class="acta-video-link acta-video-link-download">
                                    <a href="[video-{@id}-download]"><xsl:attribute name="download"/>Download Video</a>

                                </span>
                            </div>
                        </div>
                    </div>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Acknowledgement -->

    <xsl:template match="ack">
        <h2>Acknowledgements</h2>
        <div id="ack-1">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="ref-list">
        <h2>References</h2>
        <div id="reflist">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- START Reference Handling -->

   <!-- ============================================================= -->
  <!--  53. REF                                                      -->
  <!-- ============================================================= -->

  <!-- If ref/label, ref is a table row;
    If count(ref/citation) > 1, each citation is a table row -->
  <xsl:template match="ref">
    <xsl:choose>
      <xsl:when test="count(element-citation)=1">
          <p id="{@id}">
            <xsl:apply-templates select="element-citation | nlm-citation"/>
          </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="element-citation | nlm-citation">
            <p id="{@id}">
            <xsl:if test="parent::ref/label">
              <xsl:apply-templates select="parent::ref/label"/>
            </xsl:if>
            <xsl:apply-templates select="."/>
            </p>
        </xsl:for-each>
        <xsl:for-each select="mixed-citation">
          <xsl:variable name="pub-type" select="current()/@publication-type"/>
          <p id="{../@id}">
            <xsl:variable name="name-count" select="count(string-name)"/>
            <xsl:variable name="name-count-minus-one" select="$name-count - 1"/>

            <xsl:for-each select="string-name">
              <xsl:if test="surname">
                <xsl:value-of select="surname"/><xsl:text> </xsl:text><xsl:value-of select="given-names"/><xsl:choose><xsl:when test="position() = $name-count-minus-one"><xsl:text> and </xsl:text></xsl:when><xsl:when test="$name-count &gt; 2 and position() != $name-count"><xsl:text>, </xsl:text></xsl:when></xsl:choose>
              </xsl:if>
            </xsl:for-each>

              <!-- Handle web pages -->
              <xsl:if test="$pub-type = 'webpage'">
                  <xsl:if test="year">
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="year"/>
                      <xsl:text>) </xsl:text>
                  </xsl:if>
                  <xsl:if test="article-title">
                      <xsl:value-of select="article-title"></xsl:value-of>
                      <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:if test="ext-link">
                      <em>
                          <xsl:value-of select="ext-link"/>
                          <xsl:text>. </xsl:text>
                      </em>
                  </xsl:if>
                  <xsl:if test="uri">
                      <xsl:value-of select="uri"></xsl:value-of>
                      <xsl:text>.</xsl:text>
                  </xsl:if>
              </xsl:if>

              <xsl:if test="$pub-type = 'confproc'">
                  <xsl:if test="year">
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="year"/>
                      <xsl:text>) </xsl:text>
                  </xsl:if>
                  <xsl:if test="article-title">

                      <xsl:value-of select="article-title"></xsl:value-of>
                      <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:if test="conf-name">
                      <em>
                          <xsl:value-of select="conf-name"></xsl:value-of>
                          <xsl:text> </xsl:text>
                      </em>
                  </xsl:if>
                  <xsl:if test="conf-loc">
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="conf-loc"></xsl:value-of>
                  </xsl:if>
                  <xsl:if test="conf-date">
                      <xsl:text> on </xsl:text>
                      <xsl:value-of select="conf-date"></xsl:value-of>
                      <xsl:text>.</xsl:text>
                  </xsl:if>
              </xsl:if>

              <!-- Handle book stuff -->
            <xsl:if test="$pub-type = 'book'">
              <xsl:if test="year">
                <xsl:text> (</xsl:text><xsl:value-of select="year"/><xsl:text>) </xsl:text>
              </xsl:if>

                <xsl:if test="chapter-title">
                    <em>
                        <xsl:text></xsl:text>
                        <xsl:value-of select="chapter-title"/>
                    </em>
                    <xsl:text>. In: </xsl:text>
                </xsl:if>

              <xsl:if test="person-group and person-group/@person-group-type = 'editor'">
                <xsl:variable name="eds-name-count" select="count(person-group/string-name)"/>
                <xsl:variable name="eds-name-count-minus-one" select="$eds-name-count - 1"/>
                <xsl:for-each select="person-group/string-name">
                  <xsl:if test="surname">
                    <xsl:value-of select="surname"/><xsl:text> </xsl:text><xsl:value-of select="given-names"/><xsl:choose><xsl:when test="position() = $eds-name-count-minus-one"><xsl:text> and </xsl:text></xsl:when><xsl:when test="$eds-name-count &gt; 2 and position() != $eds-name-count"><xsl:text>, </xsl:text></xsl:when></xsl:choose>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text> </xsl:text>
                <xsl:choose><xsl:when test="$eds-name-count &gt; 1">(eds.)</xsl:when><xsl:otherwise>(ed.)</xsl:otherwise></xsl:choose><xsl:text>, </xsl:text>
              </xsl:if>

                <xsl:text> </xsl:text>
              <xsl:element name="i"><xsl:value-of select="source"/></xsl:element>
                <xsl:if test="edition">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="edition"></xsl:value-of>
                    <xsl:text> 6-</xsl:text>
                </xsl:if>
                <xsl:if test="not(edition)">
                    <xsl:text>, </xsl:text>
                </xsl:if>


              <xsl:if test="fpage"><xsl:value-of select="fpage"/></xsl:if>
              <xsl:if test="fpage and lpage">-</xsl:if>
              <xsl:if test="lpage"><xsl:value-of select="lpage"/></xsl:if>
              <xsl:if test="fpage or lpage">. </xsl:if>
              <xsl:if test="publisher-loc"><xsl:value-of select="publisher-loc"></xsl:value-of></xsl:if>
              <xsl:if test="publisher-loc and publisher-name">: </xsl:if>
              <xsl:if test="publisher-name"><xsl:value-of select="publisher-name"/></xsl:if>

            </xsl:if>

            <!-- Handled article -->

            <xsl:if test="$pub-type = 'journal' or $pub-type = 'newspaper'">
              <xsl:if test="year">
                <xsl:text> (</xsl:text><xsl:value-of select="year"/><xsl:text>) </xsl:text>
              </xsl:if>

                <xsl:variable name="title" select="article-title"/>
                <xsl:value-of select="title"></xsl:value-of>

                <xsl:if test="not(starts-with($title, '&#8220;')) and $title"><xsl:text>&#8220;</xsl:text></xsl:if><xsl:value-of select="article-title"/><xsl:if test="not(starts-with($title, '&#8220;')) and $title"><xsl:text>&#8221;</xsl:text></xsl:if><xsl:if test="$title"><xsl:text>, </xsl:text></xsl:if>
              <xsl:element name="i"><xsl:value-of select="source"/></xsl:element><xsl:text>. </xsl:text>
              <xsl:if test="volume">
                <xsl:text>(</xsl:text><xsl:value-of select="volume"/><xsl:text>)</xsl:text>
              </xsl:if>
              <xsl:if test="issue">
                <xsl:value-of select="issue"/>
              </xsl:if>
              <xsl:if test="fpage"><xsl:value-of select="fpage"/></xsl:if>
              <xsl:if test="fpage and lpage">-</xsl:if>
              <xsl:if test="lpage"><xsl:value-of select="lpage"/></xsl:if>
              <xsl:if test="fpage or lpage">. </xsl:if>
            </xsl:if>


          </p>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- becomes content of table cell, column 1-->
  <xsl:template match="ref/label | element-citation/label">
    <strong>
      <em>
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
      </em>
    </strong>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  54. CITATION (for NLM Archiving DTD)                         -->
  <!-- ============================================================= -->

  <!-- The citation model is mixed-context, so it is processed
     with an apply-templates (as for a paragraph)
       -except-
     if there is no PCDATA (only elements), spacing and punctuation
     also must be supplied = mode nscitation. -->

  <xsl:template match="ref/element-citation">

    <xsl:choose>
      <!-- if has no significant text content, presume that
           punctuation is not supplied in the source XML
           = transform will supply it. -->
      <xsl:when test="not(text()[normalize-space()])">
        <xsl:apply-templates mode="none"/>
      </xsl:when>

      <!-- mixed-content, processed as paragraph -->
      <xsl:otherwise>
        <xsl:apply-templates mode="nscitation"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- ============================================================= -->
  <!--  55. NLM-CITATION (for NLM Publishing DTD)                    -->
  <!-- ============================================================= -->

  <!-- The nlm-citation model allows only element content, so
     it takes a pull template and adds punctuation. -->

  <!-- Processing of nlm-citation uses several modes, including
     citation, book, edited-book, conf, inconf, and mode "none".   -->

  <!-- Each citation-type is handled in its own template. -->


  <!-- Book or thesis -->
  <xsl:template
    match="ref/nlm-citation[@citation-type='book']
                   | ref/nlm-citation[@citation-type='thesis']">

    <xsl:variable name="augroupcount" select="count(person-group) + count(collab)"/>

    <xsl:choose>

      <xsl:when
        test="$augroupcount>1 and
                    person-group[@person-group-type!='author'] and
                    article-title ">
        <xsl:apply-templates select="person-group[@person-group-type='author']" mode="book"/>
        <xsl:apply-templates select="collab" mode="book"/>
        <xsl:apply-templates select="article-title" mode="editedbook"/>
        <xsl:text>In: </xsl:text>
        <xsl:apply-templates
          select="person-group[@person-group-type='editor']
                                 | person-group[@person-group-type='allauthors']
                                 | person-group[@person-group-type='translator']
                                 | person-group[@person-group-type='transed'] "
          mode="book"/>
        <xsl:apply-templates select="source" mode="book"/>
        <xsl:apply-templates select="edition" mode="book"/>
        <xsl:apply-templates select="volume" mode="book"/>
        <xsl:apply-templates select="trans-source" mode="book"/>
        <xsl:apply-templates select="publisher-name | publisher-loc" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <xsl:apply-templates select="fpage | lpage" mode="book"/>
      </xsl:when>

      <xsl:when
        test="person-group[@person-group-type='author'] or
                    person-group[@person-group-type='compiler']">
        <xsl:apply-templates
          select="person-group[@person-group-type='author']
                                 | person-group[@person-group-type='compiler']"
          mode="book"/>
        <xsl:apply-templates select="collab" mode="book"/>
        <xsl:apply-templates select="source" mode="book"/>
        <xsl:apply-templates select="edition" mode="book"/>
        <xsl:apply-templates
          select="person-group[@person-group-type='editor']
                                 | person-group[@person-group-type='translator']
                                 | person-group[@person-group-type='transed'] "
          mode="book"/>
        <xsl:apply-templates select="volume" mode="book"/>
        <xsl:apply-templates select="trans-source" mode="book"/>
        <xsl:apply-templates select="publisher-name | publisher-loc" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <xsl:apply-templates select="article-title | fpage | lpage" mode="book"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates
          select="person-group[@person-group-type='editor']
                                 | person-group[@person-group-type='translator']
                                 | person-group[@person-group-type='transed']
                                 | person-group[@person-group-type='guest-editor']"
          mode="book"/>
        <xsl:apply-templates select="collab" mode="book"/>
        <xsl:apply-templates select="source" mode="book"/>
        <xsl:apply-templates select="edition" mode="book"/>
        <xsl:apply-templates select="volume" mode="book"/>
        <xsl:apply-templates select="trans-source" mode="book"/>
        <xsl:apply-templates select="publisher-name | publisher-loc" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <xsl:apply-templates select="article-title | fpage | lpage" mode="book"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="citation-tag-ends"/>
  </xsl:template>


  <!-- Conference proceedings -->
  <xsl:template match="ref/nlm-citation[@citation-type='confproc']">

    <xsl:variable name="augroupcount" select="count(person-group) + count(collab)"/>

    <xsl:choose>
      <xsl:when test="$augroupcount>1 and person-group[@person-group-type!='author']">
        <xsl:apply-templates select="person-group[@person-group-type='author']" mode="book"/>
        <xsl:apply-templates select="collab"/>
        <xsl:apply-templates select="article-title" mode="inconf"/>
        <xsl:text>In: </xsl:text>
        <xsl:apply-templates
          select="person-group[@person-group-type='editor']
                                 | person-group[@person-group-type='allauthors']
                                 | person-group[@person-group-type='translator']
                                 | person-group[@person-group-type='transed'] "
          mode="book"/>
        <xsl:apply-templates select="source" mode="conf"/>
        <xsl:apply-templates select="conf-name | conf-date | conf-loc" mode="conf"/>
        <xsl:apply-templates select="publisher-loc" mode="none"/>
        <xsl:apply-templates select="publisher-name" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <xsl:apply-templates select="fpage | lpage" mode="book"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates select="person-group" mode="book"/>
        <xsl:apply-templates select="collab" mode="book"/>
        <xsl:apply-templates select="article-title" mode="conf"/>
        <xsl:apply-templates select="source" mode="conf"/>
        <xsl:apply-templates select="conf-name | conf-date | conf-loc" mode="conf"/>
        <xsl:apply-templates select="publisher-loc" mode="none"/>
        <xsl:apply-templates select="publisher-name" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <xsl:apply-templates select="fpage | lpage" mode="book"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="citation-tag-ends"/>
  </xsl:template>


  <!-- Government and other reports, other, web, and commun -->
  <xsl:template
    match="ref/nlm-citation[@citation-type='gov']
                   | ref/nlm-citation[@citation-type='web']
                   | ref/nlm-citation[@citation-type='commun']
                   | ref/nlm-citation[@citation-type='other']">

    <xsl:apply-templates select="person-group" mode="book"/>

    <xsl:apply-templates select="collab"/>

    <xsl:choose>
      <xsl:when test="publisher-loc | publisher-name">
        <xsl:apply-templates select="source" mode="book"/>
        <xsl:choose>
          <xsl:when test="@citation-type='web'">
            <xsl:apply-templates select="edition" mode="none"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="edition"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="publisher-loc" mode="none"/>
        <xsl:apply-templates select="publisher-name" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
        <strong><xsl:apply-templates select="article-title|gov" mode="none"/></strong>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates select="article-title|gov" mode="book"/>
        <xsl:apply-templates select="source" mode="book"/>
        <xsl:apply-templates select="edition"/>
        <xsl:apply-templates select="publisher-loc" mode="none"/>
        <xsl:apply-templates select="publisher-name" mode="none"/>
        <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="fpage | lpage" mode="book"/>

    <xsl:call-template name="citation-tag-ends"/>

  </xsl:template>


  <!-- Patents  -->
  <xsl:template match="ref/nlm-citation[@citation-type='patent']">

    <xsl:apply-templates select="person-group" mode="book"/>
    <xsl:apply-templates select="collab" mode="book"/>
    <xsl:apply-templates select="article-title | trans-title" mode="none"/>
    <xsl:apply-templates select="source" mode="none"/>
    <xsl:apply-templates select="patent" mode="none"/>
    <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
    <xsl:apply-templates select="fpage | lpage" mode="book"/>

    <xsl:call-template name="citation-tag-ends"/>

  </xsl:template>


  <!-- Discussion  -->
  <xsl:template match="ref/nlm-citation[@citation-type='discussion']">

    <xsl:apply-templates select="person-group" mode="book"/>
    <xsl:apply-templates select="collab"/>
    <xsl:apply-templates select="article-title" mode="editedbook"/>
    <xsl:text>In: </xsl:text>
    <xsl:apply-templates select="source" mode="none"/>

    <xsl:if test="publisher-name | publisher-loc">
      <xsl:text> [</xsl:text>
      <xsl:apply-templates select="publisher-loc" mode="none"/>
      <xsl:value-of select="publisher-name"/>
      <xsl:text>]; </xsl:text>
    </xsl:if>

    <xsl:apply-templates select="year | month | time-stamp | season | access-date" mode="book"/>
    <xsl:apply-templates select="fpage | lpage" mode="book"/>

    <xsl:call-template name="citation-tag-ends"/>
  </xsl:template>


  <!-- If none of the above citation-types applies,
     use mode="none". This generates punctuation. -->
  <!-- (e.g., citation-type="journal"              -->
  <xsl:template match="nlm-citation">

    <xsl:apply-templates
      select="*[not(self::annotation) and
                                 not(self::edition) and
                                 not(self::lpage) and
                                 not(self::comment)]|text()"
      mode="none"/>

    <xsl:call-template name="citation-tag-ends"/>

  </xsl:template>


  <!-- ============================================================= -->
  <!-- person-group, mode=book                                       -->
  <!-- ============================================================= -->

  <xsl:template match="person-group" mode="book">

    <!-- XX needs fix, value is not a nodeset on the when -->
    <!--
  <xsl:choose>

    <xsl:when test="@person-group-type='editor'
                  | @person-group-type='assignee'
                  | @person-group-type='translator'
                  | @person-group-type='transed'
                  | @person-group-type='guest-editor'
                  | @person-group-type='compiler'
                  | @person-group-type='inventor'
                  | @person-group-type='allauthors'">

      <xsl:call-template name="make-persons-in-mode"/>
      <xsl:call-template name="choose-person-type-string"/>
      <xsl:call-template name="choose-person-group-end-punct"/>

    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates mode="book"/>
    </xsl:otherwise>

  </xsl:choose>
-->

    <xsl:call-template name="make-persons-in-mode"/>
    <xsl:call-template name="choose-person-group-end-punct"/>

  </xsl:template>



  <!-- if given names aren't all-caps, use book mode -->

  <xsl:template name="make-persons-in-mode">

    <xsl:variable name="gnms" select="string(descendant::given-names)"/>

    <xsl:variable name="GNMS"
      select="translate($gnms,
      'abcdefghjiklmnopqrstuvwxyz',
      'ABCDEFGHJIKLMNOPQRSTUVWXYZ')"/>

    <xsl:choose>
      <xsl:when test="$gnms=$GNMS">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="book"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="choose-person-group-end-punct">

    <xsl:choose>
      <!-- compiler is an exception to the usual choice pattern -->
      <xsl:when test="@person-group-type='compiler'">
        <xsl:text>. </xsl:text>
      </xsl:when>

      <!-- the usual choice pattern: semi-colon or period? -->
      <xsl:when test="following-sibling::person-group">
        <xsl:text>; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- ============================================================= -->
  <!--  56. Citation subparts (mode "none" separately at end)        -->
  <!-- ============================================================= -->

  <!-- names -->

  <xsl:template match="name" mode="nscitation">
    <xsl:value-of select="surname"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="given-names"/>
    <xsl:text></xsl:text>
  </xsl:template>


  <xsl:template match="name" mode="book">
    <xsl:variable name="nodetotal" select="count(../*)"/>
    <xsl:variable name="penult" select="count(../*)-1"/>
    <xsl:variable name="position" select="position()"/>

    <xsl:choose>

      <!-- if given-names -->
      <xsl:when test="given-names">
        <xsl:apply-templates select="surname"/>
        <xsl:text>, </xsl:text>
        <xsl:call-template name="firstnames">
          <xsl:with-param name="nodetotal" select="$nodetotal"/>
          <xsl:with-param name="position" select="$position"/>
          <xsl:with-param name="names" select="given-names"/>
          <xsl:with-param name="pgtype">
            <xsl:choose>
              <xsl:when test="parent::person-group[@person-group-type]">
                <xsl:value-of select="parent::person-group/@person-group-type"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'author'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:if test="suffix">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="suffix"/>
        </xsl:if>
      </xsl:when>

      <!-- if no given-names -->
      <xsl:otherwise>
        <xsl:apply-templates select="surname"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <!-- if have aff -->
      <xsl:when test="following-sibling::aff"/>

      <!-- if don't have aff -->
      <xsl:otherwise>
        <xsl:choose>

          <!-- if part of person-group -->
          <xsl:when test="parent::person-group/@person-group-type">
            <xsl:choose>

              <!-- if author -->
              <xsl:when test="parent::person-group/@person-group-type='author'">
                <xsl:choose>
                  <xsl:when test="$nodetotal=$position">. </xsl:when>
                  <xsl:when test="$penult=$position">
                    <xsl:choose>
                      <xsl:when test="following-sibling::etal">, </xsl:when>
                      <xsl:otherwise>; </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>; </xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <!-- if not author -->
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$nodetotal=$position"/>
                  <xsl:when test="$penult=$position">
                    <xsl:choose>
                      <xsl:when test="following-sibling::etal">, </xsl:when>
                      <xsl:otherwise>; </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>; </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <!-- if not part of person-group -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$nodetotal=$position">. </xsl:when>
              <xsl:when test="$penult=$position">
                <xsl:choose>
                  <xsl:when test="following-sibling::etal">, </xsl:when>
                  <xsl:otherwise>; </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>; </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>


  <xsl:template match="collab" mode="book">
    <xsl:apply-templates/>
    <xsl:if test="@collab-type='compilers'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:if test="@collab-type='assignee'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="etal" mode="book">
    <xsl:text>et al.</xsl:text>
    <xsl:choose>
      <xsl:when test="parent::person-group/@person-group-type">
        <xsl:choose>
          <xsl:when test="parent::person-group/@person-group-type='author'">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- affiliations -->

  <xsl:template match="aff" mode="book">
    <xsl:variable name="nodetotal" select="count(../*)"/>
    <xsl:variable name="position" select="position()"/>

    <xsl:text> (</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>

    <xsl:choose>
      <xsl:when test="$nodetotal=$position">. </xsl:when>
      <xsl:otherwise>, </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- publication info -->

  <xsl:template match="article-title" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="article-title" mode="book">
    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="../fpage or ../lpage">
        <xsl:text>; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="article-title" mode="editedbook">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="article-title" mode="conf">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="../conf-name">
        <xsl:text>. </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="article-title" mode="inconf">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>



  <xsl:template match="source" mode="nscitation">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="source" mode="book">
    <xsl:choose>

      <xsl:when test="../trans-source">
        <xsl:apply-templates/>
        <xsl:choose>
          <xsl:when test="../volume | ../edition">
            <xsl:text>. </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="source" mode="conf">
    <xsl:apply-templates/>
    <xsl:text>; </xsl:text>
  </xsl:template>

  <xsl:template match="trans-source" mode="book">
    <xsl:text> [</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]. </xsl:text>
  </xsl:template>

  <xsl:template match="volume" mode="nscitation">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="volume | edition" mode="book">
    <xsl:apply-templates/>
    <xsl:if test="@collab-type='compilers'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:if test="@collab-type='assignee'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <!-- dates -->

  <xsl:template match="month" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="month" mode="book">
    <xsl:variable name="month" select="."/>
    <xsl:choose>
      <xsl:when test="$month='01' or $month='1' or $month='January'">Jan</xsl:when>
      <xsl:when test="$month='02' or $month='2' or $month='February'">Feb</xsl:when>
      <xsl:when test="$month='03' or $month='3' or $month='March'">Mar</xsl:when>
      <xsl:when test="$month='04' or $month='4' or $month='April'">Apr</xsl:when>
      <xsl:when test="$month='05' or $month='5' or $month='May'">May</xsl:when>
      <xsl:when test="$month='06' or $month='6' or $month='June'">Jun</xsl:when>
      <xsl:when test="$month='07' or $month='7' or $month='July'">Jul</xsl:when>
      <xsl:when test="$month='08' or $month='8' or $month='August'">Aug</xsl:when>
      <xsl:when test="$month='09' or $month='9' or $month='September'">Sep</xsl:when>
      <xsl:when test="$month='10' or $month='October'">Oct</xsl:when>
      <xsl:when test="$month='11' or $month='November'">Nov</xsl:when>
      <xsl:when test="$month='12' or $month='December'">Dec</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$month"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="../day">
      <xsl:text> </xsl:text>
      <xsl:value-of select="../day"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="../time-stamp">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="../time-stamp"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="../access-date"/>
      <xsl:otherwise>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="day" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="year" mode="nscitation">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="year" mode="book">
    <xsl:choose>
      <xsl:when test="../month or ../season or ../access-date">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="time-stamp" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="time-stamp" mode="book"/>


  <xsl:template match="access-date" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="access-date" mode="book">
    <xsl:text> [</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]. </xsl:text>
  </xsl:template>



  <xsl:template match="season" mode="book">
    <xsl:apply-templates/>
    <xsl:if test="@collab-type='compilers'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:if test="@collab-type='assignee'">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>
    <xsl:text>. </xsl:text>
  </xsl:template>



  <!-- pages -->

  <xsl:template match="fpage" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="fpage" mode="book">
    <xsl:text>p. </xsl:text>
    <xsl:apply-templates/>

    <xsl:if test="../lpage">
      <xsl:text>.</xsl:text>
    </xsl:if>

  </xsl:template>


  <xsl:template match="lpage" mode="book">
    <xsl:choose>
      <xsl:when test="../fpage">
        <xsl:text>-</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <xsl:text> p.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="lpage" mode="nscitation">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- misc stuff -->

  <xsl:template match="pub-id" mode="nscitation">
    <xsl:text> [</xsl:text>
    <xsl:value-of select="@pub-id-type"/>

    <xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="annotation" mode="nscitation">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>

  <xsl:template match="comment" mode="nscitation">
    <xsl:if test="not(self::node()='.')">
      <br/>
      <small>
        <xsl:apply-templates/>
      </small>
    </xsl:if>
  </xsl:template>

  <xsl:template match="conf-name | conf-date" mode="conf">
    <xsl:apply-templates/>
    <xsl:text>; </xsl:text>
  </xsl:template>

  <xsl:template match="conf-loc" mode="conf">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>


  <!-- All formatting elements in citations processed normally -->
  <xsl:template match="bold | italic | monospace | overline | sc | strike | sub |sup | underline" mode="nscitation">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:template match="bold | italic | monospace | overline | sc | strike | sub |sup | underline" mode="none">
    <xsl:apply-templates select="."/>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  "firstnames"                                                 -->
  <!-- ============================================================= -->

  <!-- called by match="name" in book mode,
     as part of citation handling
     when given-names is not all-caps -->

  <xsl:template name="firstnames">
    <xsl:param name="nodetotal"/>
    <xsl:param name="position"/>
    <xsl:param name="names"/>
    <xsl:param name="pgtype"/>

    <xsl:variable name="length" select="string-length($names)-1"/>
    <xsl:variable name="gnm" select="substring($names,$length,2)"/>
    <xsl:variable name="GNM">
      <xsl:call-template name="capitalize">
        <xsl:with-param name="str" select="substring($names,$length,2)"/>
      </xsl:call-template>
    </xsl:variable>

    <!--
<xsl:text>Value of $names = [</xsl:text><xsl:value-of select="$names"/><xsl:text>]</xsl:text>
<xsl:text>Value of $length = [</xsl:text><xsl:value-of select="$length"/><xsl:text>]</xsl:text>
<xsl:text>Value of $gnm = [</xsl:text><xsl:value-of select="$gnm"/><xsl:text>]</xsl:text>
<xsl:text>Value of $GNM = [</xsl:text><xsl:value-of select="$GNM"/><xsl:text>]</xsl:text>
-->

    <xsl:if test="$names">
      <xsl:choose>

        <xsl:when test="$gnm=$GNM">
          <xsl:apply-templates select="$names"/>
          <xsl:choose>
            <xsl:when test="$nodetotal!=$position">
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:when test="$pgtype!='author'">
              <xsl:text>.</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <xsl:apply-templates select="$names"/>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:if>

  </xsl:template>



  <!-- ============================================================= -->
  <!-- mode=none                                                     -->
  <!-- ============================================================= -->

  <!-- This mode assumes no punctuation is provided in the XML.
     It is used, among other things, for the citation/ref
     when there is no significant text node inside the ref.        -->
  <xsl:template match="name" mode="none">
    <xsl:choose>
      <xsl:when test="parent::person-group[@person-group-type='translator']">
        <xsl:choose>
          <xsl:when test="not(preceding-sibling::name)">
            <xsl:value-of select="surname"/>
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="surname"/>
            <xsl:text>, </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="given-names"/>
        <xsl:choose>
          <xsl:when test="not(following-sibling::name)">
            <xsl:text> (trans.), </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>, </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="parent::person-group[@person-group-type='editor']">
        <xsl:choose>
          <xsl:when test="not(preceding-sibling::name)">
            <xsl:value-of select="surname"/>
            <xsl:text>, </xsl:text>
          </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="surname"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="given-names"/>
        <xsl:choose>
          <xsl:when test="not(following-sibling::name)">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>; </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="given-names"/>
        <xsl:choose>
          <xsl:when test="not(following-sibling::name)">
            <xsl:text> (ed</xsl:text>
            <xsl:if test="following-sibling::name | preceding-sibling::name">s</xsl:if>
            <xsl:text>.), </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
            <xsl:when test="count(preceding-sibling::name) = 1">
            <xsl:text> and </xsl:text>
            </xsl:when>
            <xsl:otherwise>
            <xsl:text>, </xsl:text>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="surname"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="given-names"/>
        <xsl:choose>
          <xsl:when test="not(following-sibling::name)">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>; </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="uri" mode="none">
    <xsl:text> </xsl:text>
    <a href="{self::uri}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="uri">
    <xsl:text> </xsl:text>
    <a href="{self::uri}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="article-title" mode="none">
    <xsl:apply-templates/>
    <xsl:if test="../trans-title">
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:text>.&#160;</xsl:text>
  </xsl:template>

  <xsl:template match="chapter-title" mode="none">
    <xsl:text></xsl:text>
  </xsl:template>

  <xsl:template match="volume" mode="none">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="edition" mode="none">
    <xsl:choose>
      <xsl:when test="parent::element-citation[@publication-type='database']">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="supplement" mode="none">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="issue" mode="none">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="publisher-loc" mode="none">
    <xsl:if test="not(preceding-sibling::publisher-name)">
    <xsl:apply-templates/>
    <xsl:text>: </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="conf-name" mode="none">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="conf-date" mode="none">
    <xsl:apply-templates/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="conf-loc" mode="none">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="publisher-name" mode="none">
    <xsl:choose>
    <xsl:when test="not(following-sibling::publisher-loc)">
        <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="following-sibling::publisher-loc"/>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="following-sibling::fpage">
        <xsl:text>, </xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="following-sibling::pub-id[@pub-id-type='doi']">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>. </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="person-group" mode="none">
    <xsl:variable name="gnms" select="string(descendant::given-names)"/>
    <xsl:variable name="GNMS">
      <xsl:call-template name="capitalize">
        <xsl:with-param name="str" select="$gnms"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$gnms=$GNMS">
        <xsl:apply-templates/>
            <xsl:if test="not(preceding-sibling::person-group)">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="..//year"/>
            <xsl:text>).</xsl:text>
            </xsl:if>
      </xsl:when>

      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="self::person-group/@person-group-type='author'">
            <strong>
              <xsl:apply-templates select="node()" mode="none"/>
            </strong>
            <xsl:if test="not(preceding-sibling::person-group)">
            <xsl:text>. (</xsl:text>
            <xsl:value-of select="..//year"/>
            <xsl:text>).</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:when test="self::person-group/@person-group-type='editor'">
            <strong>
              <xsl:apply-templates select="node()" mode="none"/>
            </strong>
            <xsl:if test="not(preceding-sibling::person-group)">
            <xsl:text>. (</xsl:text>
            <xsl:value-of select="..//year"/>
            <xsl:text>).</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="node()" mode="none"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:text>&#160;</xsl:text>
    <xsl:choose>
      <xsl:when test="self::person-group/@person-group-type='author'">
        <xsl:if test="../chapter-title">
          <xsl:value-of select="../chapter-title"/>
          <xsl:text>&#160;In:&#160;</xsl:text>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="collab" mode="none">
    <strong>

      <xsl:apply-templates/>
    </strong>
    <xsl:if test="@collab-type">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@collab-type"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="following-sibling::collab">
        <xsl:text>; </xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="source" mode="none">
    <xsl:choose>
      <xsl:when test="parent::element-citation[@publication-type='thesis']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="parent::element-citation[@publication-type='webpage']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="following-sibling::edition">
        <xsl:text>. </xsl:text>
      </xsl:when>
      <xsl:when test="following-sibling::publisher-name">
        <xsl:text>. </xsl:text>
      </xsl:when>
      <xsl:when test="following-sibling::volume">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="following-sibling::issue">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:choose>
      <xsl:when test="../access-date">
        <xsl:if test="../edition">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="../edition" mode="plain"/>
          <xsl:text></xsl:text>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </xsl:when>

      <xsl:when test="../volume | ../fpage">
        <xsl:if test="../edition">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="../edition" mode="plain"/>
          <xsl:text></xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:if test="../edition">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="../edition" mode="plain"/>
          <xsl:text> ed</xsl:text>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose> -->
  </xsl:template>

  <xsl:template match="trans-title" mode="none">
    <xsl:text> [</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]. </xsl:text>
  </xsl:template>

  <xsl:template match="month" mode="none">
    <xsl:variable name="month" select="."/>
    <xsl:choose>
      <xsl:when test="$month='01' or $month='1' ">Jan</xsl:when>
      <xsl:when test="$month='02' or $month='2' ">Feb</xsl:when>
      <xsl:when test="$month='03' or $month='3' ">Mar</xsl:when>
      <xsl:when test="$month='04' or $month='4' ">Apr</xsl:when>
      <xsl:when test="$month='05' or $month='5' ">May</xsl:when>
      <xsl:when test="$month='06' or $month='6'">Jun</xsl:when>
      <xsl:when test="$month='07' or $month='7'">Jul</xsl:when>

      <xsl:when test="$month='08' or $month='8' ">Aug</xsl:when>
      <xsl:when test="$month='09' or $month='9' ">Sep</xsl:when>
      <xsl:when test="$month='10' ">Oct</xsl:when>
      <xsl:when test="$month='11' ">Nov</xsl:when>
      <xsl:when test="$month='12' ">Dec</xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$month"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="../day">
      <xsl:text> </xsl:text>
      <xsl:value-of select="../day"/>
    </xsl:if>

    <xsl:if test="../year">
      <xsl:text> </xsl:text>
      <xsl:value-of select="../year"/>
    </xsl:if>

  </xsl:template>

  <xsl:template match="day" mode="none"/>

  <xsl:template match="year" mode="none">
    <!--
    <xsl:choose>
      <xsl:when test="../month or ../season or ../access-date">
        <xsl:apply-templates mode="none"/>
        <xsl:text> </xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates mode="none"/>
        <xsl:if test="../volume or ../issue">
          <xsl:text>;</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    -->
  </xsl:template>

  <xsl:template match="access-date" mode="none">
    <xsl:text> [</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>];</xsl:text>
  </xsl:template>

  <xsl:template match="season" mode="none">
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </xsl:template>

  <xsl:template match="fpage" mode="none">
    <xsl:variable name="fpgct" select="count(../fpage)"/>
    <xsl:variable name="lpgct" select="count(../lpage)"/>
    <xsl:variable name="hermano" select="name(following-sibling::node())"/>
    <xsl:choose>
      <xsl:when test="preceding-sibling::fpage">
        <xsl:choose>
          <xsl:when test="following-sibling::fpage">
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>

            <xsl:if test="$hermano='lpage'">
              <xsl:text>&#8211;</xsl:text>
              <xsl:apply-templates select="following-sibling::lpage[1]" mode="none"/>
            </xsl:if>
            <xsl:text>,</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <xsl:if test="$hermano='lpage'">
              <xsl:text>&#8211;</xsl:text>
              <xsl:apply-templates select="following-sibling::lpage[1]" mode="none"/>
            </xsl:if>
            <xsl:text>.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="preceding-sibling::publisher-name">
            <xsl:choose>
              <xsl:when test="following-sibling::lpage[1]">
                <xsl:text>pp. </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>p. </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="parent::element-citation[@publication-type='newspaper']">
            <xsl:choose>
              <xsl:when test="following-sibling::lpage[1]">
                <xsl:text>, pp. </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>, p. </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="parent::element-citation[@publication-type='conf-proc']">
            <xsl:choose>
              <xsl:when test="following-sibling::lpage[1]">
                <xsl:text>, pp. </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>, p. </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:text>: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:choose>
          <xsl:when test="$hermano='lpage'">
            <xsl:text>&#8211;</xsl:text>
            <xsl:apply-templates select="following-sibling::lpage[1]" mode="write"/>
            <xsl:choose>
              <xsl:when test="following-sibling::pub-id[@pub-id-type='doi']">
                <xsl:text>, </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>. </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$hermano='fpage'">
            <xsl:text>,</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="lpage" mode="none"/>

  <xsl:template match="lpage" mode="write">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="gov" mode="none">
    <xsl:choose>
      <xsl:when test="../trans-title">
        <xsl:apply-templates/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates/>
          <xsl:text>. </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="patent" mode="none">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="pub-id[@pub-id-type='doi']" mode="none">
    <xsl:text>DOI:&#160;</xsl:text>
      <a href="http://dx.doi.org/{current()}" target="_blank">
      <xsl:text>http://dx.doi.org/</xsl:text>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="pub-id[@pub-id-type='pmid']" mode="none"> [<a href="http://www.ncbi.nlm.nih.gov/pubmed/{current()}" target="_blank">
      <xsl:text>PubMed</xsl:text>
    </a>]
  </xsl:template>

  <xsl:template match="pub-id" mode="none">
    <xsl:text> [</xsl:text>
    <span class="pub-id-type-{@pub-id-type}">
      <xsl:value-of select="@pub-id-type"/>
    </span>
    <xsl:text>: </xsl:text>
      <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="comment" mode="none">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>.</xsl:text>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  57. "CITATION-TAG-ENDS"                                      -->
  <!-- ============================================================= -->


  <xsl:template name="citation-tag-ends">

    <xsl:apply-templates select="series" mode="citation"/>

    <!-- If language is not English -->
    <!-- XX review logic -->
    <xsl:if test="article-title[@xml:lang!='en']
               or article-title[@xml:lang!='EN']">
    </xsl:if>

    <xsl:apply-templates select="comment" mode="citation"/>

    <xsl:apply-templates select="annotation" mode="citation"/>

  </xsl:template>

      <xsl:template name="capitalize">
    <xsl:param name="str"/>
    <xsl:value-of
      select="translate($str,
                          'abcdefghjiklmnopqrstuvwxyz',
                          'ABCDEFGHJIKLMNOPQRSTUVWXYZ')"
    />
  </xsl:template>

    <!-- START video handling -->

    <xsl:template match="media">
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <xsl:choose>
            <xsl:when test="@mimetype = 'video'">
                <div class="media" data-doi="{$data-doi}">
                    <xsl:apply-templates select="." mode="testing"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="testing"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- media caption -->
    <xsl:template match="media/caption">
        <div class="media-caption">
            <span class="media-label">
                <xsl:value-of select="preceding-sibling::label"/>
            </span>
            <xsl:text> </xsl:text>

            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="media/caption/title">
        <span class="caption-title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- END video handling -->

    <!-- START sub-article -->

    <xsl:template match="sub-article">
        <xsl:variable name="data-doi" select="child::front-stub/article-id[@pub-id-type='doi']/text()"/>
        <div data-doi="{$data-doi}">
            <!-- determine the attribute -->
            <xsl:attribute name="id">
                <xsl:if test="@article-type='article-commentary'">
                    <xsl:text>decision-letter</xsl:text>
                </xsl:if>
                <xsl:if test="@article-type='reply'">
                    <xsl:text>author-response</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>

        </div>
        <div class="panel-separator"></div>
    </xsl:template>

    <!-- sub-article body -->
    <xsl:template match="sub-article/body">
        <div>
            <xsl:attribute name="class">
                <xsl:if test="../@article-type='article-commentary'">
                    <xsl:text>janeway-article-decision-letter</xsl:text>
                </xsl:if>
                <xsl:if test="../@article-type='reply'">
                    <xsl:text>janeway-article-author-response</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <div class="article fulltext-view">
                <xsl:apply-templates/>
            </div>
        </div>
        <div>
            <xsl:attribute name="class">
                <xsl:if test="../@article-type='article-commentary'">
                    <xsl:text>janeway-article-decision-letter-doi</xsl:text>
                </xsl:if>
                <xsl:if test="../@article-type='reply'">
                    <xsl:text>janeway-article-author-response-doi</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <strong>DOI:</strong>
            <xsl:text> </xsl:text>

            <xsl:variable name="doino" select="preceding-sibling::*//article-id"/>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('/lookup/doi/', $doino)"/>
                </xsl:attribute>
                <xsl:value-of select="concat('http://dx.doi.org/', $doino)"/>
            </a>
        </div>
    </xsl:template>

    <!-- START sub-article author contrib information -->

    <xsl:template match="sub-article//contrib-group">
        <div class="acta-article-editors">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="sub-article//contrib-group/contrib">
        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="concat('acta-article-decision-reviewing', @contrib-type)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="contrib[@contrib-type='editor']/name/given-names | contrib[@contrib-type='editor']/name/surname">
        <span class="nlm-given-names">
            <xsl:value-of select="given-names"/>
        </span>
        <xsl:text> </xsl:text>
        <span class="nlm-surname">
            <xsl:value-of select="surname"/>
        </span>
        <xsl:if test="parent::suffix">
            <xsl:text> </xsl:text>
            <span class="nlm-surname">
                <xsl:value-of select="parent::suffix"/>
            </span>
        </xsl:if>
        <xsl:text>, </xsl:text>
    </xsl:template>

    <xsl:template match="contrib[@contrib-type='editor']//aff">
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="contrib[@contrib-type='editor']//role | contrib[@contrib-type='editor']//institution | contrib[@contrib-type='editor']//country">
        <span class="nlm-{name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="not(parent::aff) or (parent::aff and following-sibling::*)">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- END sub-article author contrib information -->

    <!-- box text -->
    <xsl:template match="boxed-text">
        <xsl:variable name="data-doi" select="child::object-id[@pub-id-type='doi']/text()"/>
        <xsl:choose>
            <xsl:when test="$data-doi != ''">
                <div class="boxed-text">
                    <xsl:attribute name="data-doi">
                        <xsl:value-of select="$data-doi"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="." mode="testing"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="testing"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="boxed-text/label">
        <span class="boxed-text-label">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="inline-graphic">
        <xsl:variable name="ig-variant">
            <xsl:choose>
                <xsl:when test="//article/@article-type = 'research-article'">
                    <xsl:value-of select="'research-'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'nonresearch-'"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="ancestor::boxed-text">
                    <xsl:value-of select="'box'"/>
                </xsl:when>
                <xsl:when test="ancestor::fig">
                    <xsl:value-of select="'fig'"/>
                </xsl:when>
                <xsl:when test="ancestor::table-wrap">
                    <xsl:value-of select="'table'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'other'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        [inline-graphic-<xsl:value-of select="@xlink:href"/>-<xsl:value-of select="$ig-variant"/>]
    </xsl:template>

    <xsl:template name="appendices-main-text">
        <xsl:apply-templates select="//back/app-group/app" mode="testing"/>
    </xsl:template>

    <xsl:template match="app" mode="testing">
        <div class="section app">
            <xsl:if test="@id">
                <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="title">
                <h3><xsl:value-of select="title"/></h3>
            </xsl:if>
            <xsl:apply-templates mode="testing"/>
        </div>
    </xsl:template>

    <!-- START - general format -->

    <!-- list elements start-->

    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@list-type = 'simple' or @list-type = 'bullet'">
                <ul>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="@list-type = 'simple'">
                                <xsl:value-of select="'list-simple'"/>
                            </xsl:when>
                            <xsl:when test="@list-type = 'bullet'">
                                <xsl:value-of select="'list-unord'"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ol>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="@list-type = 'order'">
                                <xsl:value-of select="'list-ord'"/>
                            </xsl:when>
                            <xsl:when test="@list-type = 'roman-lower'">
                                <xsl:value-of select="'list-romanlower'"/>
                            </xsl:when>
                            <xsl:when test="@list-type = 'roman-upper'">
                                <xsl:value-of select="'list-romanupper'"/>
                            </xsl:when>
                            <xsl:when test="@list-type = 'alpha-lower'">
                                <xsl:value-of select="'list-alphalower'"/>
                            </xsl:when>
                            <xsl:when test="@list-type = 'alpha-upper'">
                                <xsl:value-of select="'list-alphaupper'"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </ol>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="list-item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="bold">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="italic">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="underline">
        <span class="underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="monospace">
        <span class="monospace">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="styled-content">
        <span class="styled-content">
            <xsl:if test="@style">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="sup">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="sub">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>

    <xsl:template match="break">
        <br/>
    </xsl:template>

      <xsl:template match="verse-group">
        <pre>
          <xsl:apply-templates/>
        </pre>
      </xsl:template>

      <xsl:template match="verse-line">
        <xsl:apply-templates/>
      </xsl:template>

      <xsl:template match="title">
          <strong>
            <xsl:apply-templates/>
          </strong>
      </xsl:template>

    <xsl:template match="disp-quote">
        <xsl:text disable-output-escaping="yes">&lt;blockquote class="disp-quote"&gt;</xsl:text>
            <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/blockquote&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="code">
        <xsl:choose>
            <xsl:when test="@xml:space = 'preserve'">
                <pre>
                    <code>
                        <xsl:apply-templates/>
                    </code>
                </pre>
            </xsl:when>
            <xsl:otherwise>
                <code>
                    <xsl:apply-templates/>
                </code>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- END - general format -->

    <xsl:template match="sub-article//title-group | sub-article/front-stub | fn-group[@content-type='competing-interest']/fn/p | //history//*[@publication-type='journal']/article-title">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="caption | table-wrap/table | table-wrap-foot | fn | bold | italic | underline | monospace | styled-content | sub | sup | sec/title | ext-link | app/title | disp-formula | inline-formula | list | list-item | disp-quote | code" mode="testing">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- nodes to remove -->
    <xsl:template match="aff/label"/>
    <xsl:template match="fn/label"/>
    <xsl:template match="disp-formula/label"/>
    <xsl:template match="app/title"/>
    <xsl:template match="fn-group[@content-type='competing-interest']/title"/>
    <xsl:template match="permissions/copyright-year | permissions/copyright-holder"/>
    <xsl:template match="fn-group[@content-type='author-contribution']/title"/>
    <xsl:template match="author-notes/fn[@fn-type='con']/label"/>
    <xsl:template match="author-notes/fn[@fn-type='other']/label"/>
    <xsl:template match="author-notes/corresp/label"/>
    <xsl:template match="abstract/title"/>
    <xsl:template match="ref/label"/>
    <xsl:template match="fig/graphic"/>
    <xsl:template match="fig-group//object-id | fig-group//graphic | fig//label"/>
    <xsl:template match="ack/title"/>
    <xsl:template match="ref-list/title"/>
    <xsl:template match="ref//year | ref//article-title | ref//fpage | ref//volume | ref//source | ref//pub-id | ref//lpage | ref//comment | ref//supplement | ref//person-group[@person-group-type='editor'] | ref//edition | ref//publisher-loc | ref//publisher-name | ref//ext-link"/>
    <xsl:template match="person-group[@person-group-type='author']"/>
    <xsl:template match="media/label"/>
    <xsl:template match="sub-article//article-title"/>
    <xsl:template match="sub-article//article-id"/>
    <xsl:template match="object-id | table-wrap/label"/>
    <xsl:template match="funding-group//institution-wrap/institution-id"/>
    <xsl:template match="table-wrap/graphic"/>
    <xsl:template match="author-notes/fn[@fn-type='present-address']/label"/>
    <xsl:template match="author-notes/fn[@fn-type='deceased']/label"/>

    <xsl:template name="camel-case-word">
        <xsl:param name="text"/>
        <xsl:value-of select="translate(substring($text, 1, 1), $smallcase, $uppercase)" /><xsl:value-of select="translate(substring($text, 2, string-length($text)-1), $uppercase, $smallcase)" />
    </xsl:template>

    <xsl:template name="month-long">
        <xsl:param name="month"/>
        <xsl:variable name="month-int" select="number(month)"/>
        <xsl:choose>
            <xsl:when test="$month-int = 1">
                <xsl:value-of select="'January'"/>
            </xsl:when>
            <xsl:when test="$month-int = 2">
                <xsl:value-of select="'February'"/>
            </xsl:when>
            <xsl:when test="$month-int = 3">
                <xsl:value-of select="'March'"/>
            </xsl:when>
            <xsl:when test="$month-int = 4">
                <xsl:value-of select="'April'"/>
            </xsl:when>
            <xsl:when test="$month-int = 5">
                <xsl:value-of select="'May'"/>
            </xsl:when>
            <xsl:when test="$month-int = 6">
                <xsl:value-of select="'June'"/>
            </xsl:when>
            <xsl:when test="$month-int = 7">
                <xsl:value-of select="'July'"/>
            </xsl:when>
            <xsl:when test="$month-int = 8">
                <xsl:value-of select="'August'"/>
            </xsl:when>
            <xsl:when test="$month-int = 9">
                <xsl:value-of select="'September'"/>
            </xsl:when>
            <xsl:when test="$month-int = 10">
                <xsl:value-of select="'October'"/>
            </xsl:when>
            <xsl:when test="$month-int = 11">
                <xsl:value-of select="'November'"/>
            </xsl:when>
            <xsl:when test="$month-int = 12">
                <xsl:value-of select="'December'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="citation">
        <xsl:variable name="year"><xsl:call-template name="year"/></xsl:variable>
        <xsl:variable name="citationid"><xsl:call-template name="citationid"/></xsl:variable>
        <xsl:value-of select="concat(//journal-meta/journal-title-group/journal-title, ' ', $year, ';', $citationid)"/>
    </xsl:template>

    <xsl:template name="year">
        <xsl:choose>
            <xsl:when test="//article-meta/pub-date[@date-type='pub']/year">
                <xsl:value-of select="//article-meta/pub-date[@date-type='pub']/year"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//article-meta/permissions/copyright-year"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="volume">
        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="//article-meta/volume">
                    <xsl:value-of select="//article-meta/volume"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="year"><call-template name="year"/></xsl:variable>
                    <xsl:value-of select="$year - 2011"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$value"/>
    </xsl:template>

    <xsl:template name="citationid">
        <xsl:variable name="volume"><xsl:call-template name="volume"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="//article-meta/pub-date[@pub-type='collection']/year">
                <xsl:value-of select="concat($volume, ':', //article-meta/elocation-id)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//article-meta/article-id[@pub-id-type='doi']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>
