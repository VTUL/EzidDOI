{**
 * @file plugins/importexport/ezid/templates/unregisteredArticles.tpl
 *
 * Copyright (c) 2013-2014 Simon Fraser University Library
 * Copyright (c) 2003-2014 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Select all unregistered objects for export.
 *}
{strip}
{assign var="pageTitle" value="plugins.importexport.ezid.export.selectUnregistered"}
{assign var="pageCrumbTitle" value="plugins.importexport.ezid.export.selectUnregistered"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">{literal}
  function toggleChecked() {
    var elements = document.getElementById('exportAllForm').elements;
    for (var i=0; i < elements.length; i++) {
      if (elements[i].name == 'articleId[]') {
        elements[i].checked = !elements[i].checked;
      }
    }
  }
{/literal}</script>

<br/>

<div id="allUnregistered">
  <form action="{plugin_url path="process"}" method="post" id="exportAllForm">
    <input type="hidden" name="target" value="all" />
    <table width="100%" class="listing">
      <tr>
        <td colspan="6" class="headseparator">&nbsp;</td>
      </tr>
      <tr class="heading" valign="bottom">
        <td width="5%">&nbsp;</td>
        <td width="25%">{translate key="issue.issue"}</td>
        <td width="40%">{translate key="article.title"}</td>
        <td width="25%">{translate key="article.authors"}</td>
        <td width="5%">{translate key="common.action"}</td>
      </tr>
      <tr>
        <td colspan="5" class="headseparator">&nbsp;</td>
      </tr>

      {assign var=noObjects value=true}
      {foreach from=$articles item=articleData}
        {assign var=article value=$articleData.article}
        {if $article->getPubId('doi')}
          {assign var=noObjects value=false}
          {assign var=issue value=$articleData.issue}
          {capture assign="updateOrRegister"}{translate key="plugins.importexport.common.register"}{/capture}
          {capture assign="updateOrRegisterDescription"}{translate key="plugins.importexport.common.registerDescription"}{/capture}
          <tr valign="top">
            <td><input type="checkbox" name="articleId[]" value="{$article->getId()}" checked="checked" /></td>
            <td><a href="{url page="issue" op="view" path=$issue->getId()}" class="action">{$issue->getIssueIdentification()|strip_tags}</a></td>
            <td><a href="{url page="article" op="view" path=$article->getId()}" class="action">{$article->getLocalizedTitle()|strip_unsafe_html}</a></td>
            <td>{$article->getAuthorString()|escape}</td>
            <td align="right"><nobr>
              {if $hasCredentials}
                <a href="{plugin_url path="process" articleId=$article->getId() params=$testMode target="article" register=true}" title="{$updateOrRegisterDescription}" class="action">{$updateOrRegister}</a>
              {/if}
              <a href="{plugin_url path="process" articleId=$article->getId() params=$testMode target="article" export=true}" title="{translate key="plugins.importexport.common.exportDescription"}" class="action">{translate key="common.export"}</a>
            </nobr>
          </td>
        </tr>
          <tr>
            <td colspan="5" class="separator">&nbsp;</td>
          </tr>
        {/if}
      {/foreach}
      {if $noObjects}
        <tr>
          <td colspan="5" class="nodata">{translate key="plugins.importexport.ezid.export.noUnregistered"}</td>
        </tr>
        <tr>
          <td colspan="5" class="endseparator">&nbsp;</td>
        </tr>
      {/if}
    </table>
    <p>
      {if !empty($testMode)}<input type="hidden" name="testMode" value="1" />{/if}
      {if $hasCredentials}
        <input type="submit" name="register" value="{translate key="plugins.importexport.common.register"}" title="{translate key="plugins.importexport.common.registerDescription.multi"}" class="button defaultButton"/>
        &nbsp;
      {/if}
      <input type="button" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" />
    </p>
    <p>
      {if $hasCredentials}
        {translate key="plugins.importexport.common.register.warning"}
      {else}
        {capture assign="settingsUrl"}{plugin_url path="settings"}{/capture}
        {translate key="plugins.importexport.common.register.noCredentials" settingsUrl=$settingsUrl}
      {/if}
    </p>
  </form>
</div>

{include file="common/footer.tpl"}
