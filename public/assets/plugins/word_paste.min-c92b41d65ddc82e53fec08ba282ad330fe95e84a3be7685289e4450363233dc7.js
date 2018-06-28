/*!
 * froala_editor v2.8.1 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2018 Froala Labs
 */


!function(r){"function"==typeof define&&define.amd?define(["jquery"],r):"object"==typeof module&&module.exports?module.exports=function(e,t){return t===undefined&&(t="undefined"!=typeof window?require("jquery"):require("jquery")(e)),r(t)}:r(window.jQuery)}(function(S){S.extend(S.FE.DEFAULTS,{wordDeniedTags:[],wordDeniedAttrs:[],wordAllowedStyleProps:["font-family","font-size","background","color","width","text-align","vertical-align","background-color","padding","margin","height","margin-top","margin-left","margin-right","margin-bottom","text-decoration","font-weight","font-style","text-indent"],wordPasteModal:!0}),S.FE.PLUGINS.wordPaste=function(A){var l,i,a="word_paste";function t(e){var t=A.opts.wordAllowedStyleProps;e||(A.opts.wordAllowedStyleProps=[]),0===i.indexOf("<colgroup>")&&(i="<table>"+i+"</table>"),i=function(e,t){!function(e){for(var t=e.split("v:shape"),r=1;r<t.length;r++){var i=t[r],n=i.split(' id="')[1];if(n&&1<n.length){n=n.split('"')[0];var l=i.split(' o:spid="')[1];l&&1<l.length&&(l=l.split('"')[0],c[n]=l)}}}(e=e.replace(/[.\s\S\w\W<>]*(<html[^>]*>[.\s\S\w\W<>]*<\/html>)[.\s\S\w\W<>]*/i,"$1"));var r=(new DOMParser).parseFromString(e,"text/html"),i=r.head,n=r.body,a=function(e){var t={},r=e.getElementsByTagName("style");if(r.length){var i=r[0],n=i.innerHTML.match(/[\S ]+\s+{[\s\S]+?}/gi);if(n)for(var l=0;l<n.length;l++){var a=n[l],s=a.replace(/([\S ]+\s+){[\s\S]+?}/gi,"$1"),o=a.replace(/[\S ]+\s+{([\s\S]+?)}/gi,"$1");s=s.replace(/^[\s]|[\s]$/gm,""),o=o.replace(/^[\s]|[\s]$/gm,""),s=s.replace(/\n|\r|\n\r/g,""),o=o.replace(/\n|\r|\n\r/g,"");for(var d=s.split(", "),g=0;g<d.length;g++)t[d[g]]=o}}return t}(i);g(n,function(e){if(e.nodeType==Node.TEXT_NODE&&/\n|\u00a0|\r/.test(e.data)){if(!/\S| /.test(e.data))return e.data==S.FE.UNICODE_NBSP?(e.data="\u200b",!0):1==e.data.length&&10==e.data.charCodeAt(0)?(e.data=" ",!0):(y(e),!1);e.data=e.data.replace(/\n|\r/gi," ")}return!0}),g(n,function(e){return e.nodeType!=Node.ELEMENT_NODE||"V:IMAGEDATA"!=e.tagName&&"IMG"!=e.tagName||function(e,t){if(!t)return;var r;if("IMG"==e.tagName){var i=e.getAttribute("src");if(!i||-1==i.indexOf("file://"))return;if(0===i.indexOf("file://")&&A.helpers.isURL(e.getAttribute("alt")))return e.setAttribute("src",e.getAttribute("alt"));(r=c[e.getAttribute("v:shapes")])||(r=e.getAttribute("v:shapes"))}else r=e.parentNode.getAttribute("o:spid");if(e.removeAttribute("height"),!r)return;n=t,p={},u(n,"i","\\shppict"),u(n,"s","\\shp{");var n;var l=p[r.substring(7)];if(l){var a=function(e){for(var t=e.match(/[0-9a-f]{2}/gi),r=[],i=0;i<t.length;i++)r.push(String.fromCharCode(parseInt(t[i],16)));var n=r.join("");return btoa(n)}(l.image_hex),s="data:"+l.image_type+";base64,"+a;"IMG"===e.tagName?(e.src=s,e.setAttribute("data-fr-image-pasted",!0)):S(e.parentNode).before('<img data-fr-image-pasted="true" src="'+s+'" style="'+e.parentNode.getAttribute("style")+'">').remove()}}(e,t),!0});for(var l=n.querySelectorAll("ul > ul, ul > ol, ol > ul, ol > ol"),s=l.length-1;0<=s;s--)l[s].previousElementSibling&&"LI"===l[s].previousElementSibling.tagName&&l[s].previousElementSibling.appendChild(l[s]);g(n,function(t){if(t.nodeType==Node.TEXT_NODE)return t.data=t.data.replace(/<br>(\n|\r)/gi,"<br>"),!1;if(t.nodeType==Node.ELEMENT_NODE){if(C(t)){var r=t.parentNode,i=t.previousSibling,n=function e(t,r){var i=/[0-9a-zA-Z]./gi;var n=!1;t.firstElementChild&&t.firstElementChild.firstElementChild&&t.firstElementChild.firstElementChild.firstChild&&!(n=n||i.test(t.firstElementChild.firstElementChild.firstChild.data||""))&&t.firstElementChild.firstElementChild.firstElementChild&&t.firstElementChild.firstElementChild.firstElementChild.firstChild&&(n=n||i.test(t.firstElementChild.firstElementChild.firstElementChild.firstChild.data||""));var l=n?"ol":"ul";var a=m(t);var s="<"+l+"><li>"+h(t,r);var o=t.nextElementSibling;var d=t.parentNode;y(t);t=null;for(;o&&C(o);){var g=o.previousElementSibling,u=m(o);if(a<u)s+=e(o,r).outerHTML;else{if(u<a)break;s+="</li><li>"+h(o,r)}if(a=u,o.previousElementSibling||o.nextElementSibling||o.parentNode){var f=o;o=o.nextElementSibling,y(f),f=null}else o=g?g.nextElementSibling:d.firstElementChild}s+="</li></"+l+">";var p=document.createElement("div");p.innerHTML=s;var c=p.firstElementChild;return c}(t,a),l=null;return(l=i?i.nextSibling:r.firstChild)?r.insertBefore(n,l):r.appendChild(n),!1}return f(t,a)}return t.nodeType!=Node.COMMENT_NODE||(y(t),!1)}),g(n,function(e){if(e.nodeType==Node.ELEMENT_NODE){var t=e.tagName;if(!e.innerHTML&&-1==["BR","IMG"].indexOf(t)){for(var r=e.parentNode;r&&(y(e),!(e=r).innerHTML);)r=e.parentNode;return!1}!function(e){var t=e.getAttribute("style");if(!t)return;(t=w(t))&&";"!=t.slice(-1)&&(t+=";");var r=t.match(/(^|\S+?):.+?;{1,1}/gi);if(!r)return;for(var i={},n=0;n<r.length;n++){var l=r[n],a=l.split(":");2==a.length&&("text-align"==a[0]&&"SPAN"==e.tagName||(i[a[0]]=a[1]))}var s="";for(var o in i)if(i.hasOwnProperty(o)){if("font-size"==o&&"pt;"==i[o].slice(-3)){var d=null;try{d=parseFloat(i[o].slice(0,-3),10)}catch(g){}d&&(d=Math.round(1.33*d),i[o]=d+"px;")}s+=o+":"+i[o]}s&&e.setAttribute("style",s)}(e)}return!0});var o=n.outerHTML,d=A.opts.htmlAllowedStyleProps;return A.opts.htmlAllowedStyleProps=A.opts.wordAllowedStyleProps,o=A.clean.html(o,A.opts.wordDeniedTags,A.opts.wordDeniedAttrs,!1),A.opts.htmlAllowedStyleProps=d,o}(i=i.replace(/<span[\n\r ]*style='mso-spacerun:yes'>([\r\n\u00a0 ]*)<\/span>/g,function(e,t){for(var r="",i=0;i++<t.length;)r+="&nbsp;";return r}),A.paste.getRtfClipboard());var r=A.doc.createElement("DIV");r.innerHTML=i,A.html.cleanBlankSpaces(r),i=r.innerHTML,i=(i=A.paste.cleanEmptyTagsAndDivs(i)).replace(/\u200b/g,""),A.modals.hide(a),A.paste.clean(i,!0,!0),A.opts.wordAllowedStyleProps=t}function y(e){e.parentNode&&e.parentNode.removeChild(e)}function g(e,t){if(t(e))for(var r=e.firstChild;r;){var i=r,n=r.previousSibling;r=r.nextSibling,g(i,t),i.previousSibling||i.nextSibling||i.parentNode||!r||n==r.previousSibling||!r.parentNode?i.previousSibling||i.nextSibling||i.parentNode||!r||r.previousSibling||r.nextSibling||r.parentNode||(n?r=n.nextSibling?n.nextSibling.nextSibling:null:e.firstChild&&(r=e.firstChild.nextSibling)):r=n?n.nextSibling:e.firstChild}}function C(e){if(!e.getAttribute("style")||!/mso-list:[\s]*l/gi.test(e.getAttribute("style").replace(/\n/gi,"")))return!1;try{if(!e.querySelector('[style="mso-list:Ignore"]'))return!1}catch(t){return!1}return!0}function m(e){return e.getAttribute("style").replace(/\n/gi,"").replace(/.*level([0-9]+?).*/gi,"$1")}function h(e,t){var r=e.cloneNode(!0);if(-1!=["H1","H2","H3","H4","H5","H6"].indexOf(e.tagName)){var i=document.createElement(e.tagName.toLowerCase());i.setAttribute("style",e.getAttribute("style")),i.innerHTML=r.innerHTML,r.innerHTML=i.outerHTML}g(r,function(e){return e.nodeType==Node.ELEMENT_NODE&&("mso-list:Ignore"==e.getAttribute("style")&&e.parentNode.removeChild(e),f(e,t)),!0});var n=r.innerHTML;return n=n.replace(/<!--[\s\S]*?-->/gi,"")}function v(e,t){for(var r=document.createElement(t),i=0;i<e.attributes.length;i++){var n=e.attributes[i].name;r.setAttribute(n,e.getAttribute(n))}return r.innerHTML=e.innerHTML,e.parentNode.replaceChild(r,e),r}function N(e){var t=e.parentNode,r=e.getAttribute("align");r&&(t&&"TD"==t.tagName?t.setAttribute("style",t.getAttribute("style")+"text-align:"+r+";"):e.style["text-align"]=r,e.removeAttribute("align"))}function w(e){return e.replace(/\n|\r|\n\r|&quot;/g,"")}function x(e,t,r){if(t){var i=e.getAttribute("style");i&&";"!=i.slice(-1)&&(i+=";"),t&&";"!=t.slice(-1)&&(t+=";"),t=t.replace(/\n/gi,"");var n=null;n=r?(i||"")+t:t+(i||""),e.setAttribute("style",n)}}var p=null;function u(e,t,r){for(var i=e.split(r),n=1;n<i.length;n++){var l=i[n];if(1<(l=l.split("shplid")).length){l=l[1];for(var a="",s=0;s<l.length&&"\\"!=l[s]&&"{"!=l[s]&&" "!=l[s]&&"\r"!=l[s]&&"\n"!=l[s];)a+=l[s],s++;var o=l.split("bliptag");if(o&&o.length<2)continue;var d=null;if(-1!=o[0].indexOf("pngblip")?d="image/png":-1!=o[0].indexOf("jpegblip")&&(d="image/jpeg"),!d)continue;var g,u=o[1].split("}");if(u&&u.length<2)continue;if(2<u.length&&-1!=u[0].indexOf("blipuid"))g=u[1].split(" ");else{if((g=u[0].split(" "))&&g.length<2)continue;g.shift()}var f=g.join("");p[t+a]={image_hex:f,image_type:d}}}}function f(e,t){var r=e.tagName,i=r.toLowerCase();e.firstElementChild&&("I"==e.firstElementChild.tagName?v(e.firstElementChild,"em"):"B"==e.firstElementChild.tagName&&v(e.firstElementChild,"strong"));if(-1!=["SCRIPT","APPLET","EMBED","NOFRAMES","NOSCRIPT"].indexOf(r))return y(e),!1;var n=-1,l=["META","LINK","XML","ST1:","O:","W:","FONT"];for(n=0;n<l.length;n++)if(-1!=r.indexOf(l[n]))return e.innerHTML&&(e.outerHTML=e.innerHTML),y(e),!1;if("TD"!=r){var a=e.getAttribute("class");if(t&&a){var s=(a=w(a)).split(" ");for(n=0;n<s.length;n++){var o=[],d="."+s[n];o.push(d),d=i+d,o.push(d);for(var g=0;g<o.length;g++)t[o[g]]&&x(e,t[o[g]])}e.removeAttribute("class")}t&&t[i]&&x(e,t[i])}if(-1!=["P","H1","H2","H3","H4","H5","H6","PRE"].indexOf(r)){var u=e.getAttribute("class");if(u&&(t&&t[r.toLowerCase()+"."+u]&&x(e,t[r.toLowerCase()+"."+u]),-1!=u.toLowerCase().indexOf("mso"))){var f=w(u);(f=f.replace(/[0-9a-z-_]*mso[0-9a-z-_]*/gi,""))?e.setAttribute("class",f):e.removeAttribute("class")}var p=e.getAttribute("style");if(p){var c=p.match(/text-align:.+?[; "]{1,1}/gi);c&&c[c.length-1].replace(/(text-align:.+?[; "]{1,1})/gi,"$1")}N(e)}if("TR"==r&&function(e,t){A.node.clearAttributes(e);for(var r=e.firstElementChild,i=0,n=!1,l=null;r;){r.firstElementChild&&-1!=r.firstElementChild.tagName.indexOf("W:")&&(r.innerHTML=r.firstElementChild.innerHTML),(l=r.getAttribute("width"))||n||(n=!0),i+=parseInt(l,10),(!r.firstChild||r.firstChild&&r.firstChild.data==S.FE.UNICODE_NBSP)&&(r.firstChild&&y(r.firstChild),r.innerHTML="<br>");for(var a=r.firstElementChild,s=1==r.children.length;a;)"P"!=a.tagName||C(a)||s&&N(a),a=a.nextElementSibling;if(t){var o=r.getAttribute("class");if(o){var d=(o=w(o)).match(/xl[0-9]+/gi);if(d){var g="."+d[0];t[g]&&x(r,t[g])}}t.td&&x(r,t.td)}var u=r.getAttribute("style");u&&(u=w(u))&&";"!=u.slice(-1)&&(u+=";");var f=r.getAttribute("valign");if(!f&&u){var p=u.match(/vertical-align:.+?[; "]{1,1}/gi);p&&(f=p[p.length-1].replace(/vertical-align:(.+?)[; "]{1,1}/gi,"$1"))}var c=null;if(u){var m=u.match(/text-align:.+?[; "]{1,1}/gi);m&&(c=m[m.length-1].replace(/text-align:(.+?)[; "]{1,1}/gi,"$1")),"general"==c&&(c=null)}var h=null;if(u){var v=u.match(/background:.+?[; "]{1,1}/gi);v&&(h=v[v.length-1].replace(/background:(.+?)[; "]{1,1}/gi,"$1"))}var b=r.getAttribute("colspan"),E=r.getAttribute("rowspan");b&&r.setAttribute("colspan",b),E&&r.setAttribute("rowspan",E),f&&(r.style["vertical-align"]=f),c&&(r.style["text-align"]=c),h&&(r.style["background-color"]=h),l&&r.setAttribute("width",l),r=r.nextElementSibling}for(r=e.firstElementChild;r;)l=r.getAttribute("width"),n?r.removeAttribute("width"):r.setAttribute("width",100*parseInt(l,10)/i+"%"),r=r.nextElementSibling}(e,t),"A"!=r||e.attributes.getNamedItem("href")||e.attributes.getNamedItem("name")||!e.innerHTML||(e.outerHTML=e.innerHTML),"TD"!=r&&"TH"!=r||e.innerHTML||(e.innerHTML="<br>"),"TABLE"==r&&(e.style.width="100%"),e.getAttribute("lang")&&e.removeAttribute("lang"),e.getAttribute("style")&&-1!=e.getAttribute("style").toLowerCase().indexOf("mso")){var m=w(e.getAttribute("style"));(m=m.replace(/[0-9a-z-_]*mso[0-9a-z-_]*:.+?(;{1,1}|$)/gi,""))?e.setAttribute("style",m):e.removeAttribute("style")}return!0}var c={};return{_init:function(){A.events.on("paste.wordPaste",function(e){return i=e,A.opts.wordPasteModal?function(){if(!l){var e='<h4><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 74.95 73.23" style="height: 25px; vertical-align: text-bottom; margin-right: 5px; display: inline-block"><defs><style>.a{fill:#2a5699;}.b{fill:#fff;}</style></defs><path class="a" d="M615.15,827.22h5.09V834c9.11.05,18.21-.09,27.32.05a2.93,2.93,0,0,1,3.29,3.25c.14,16.77,0,33.56.09,50.33-.09,1.72.17,3.63-.83,5.15-1.24.89-2.85.78-4.3.84-8.52,0-17,0-25.56,0v6.81h-5.32c-13-2.37-26-4.54-38.94-6.81q0-29.8,0-59.59c13.05-2.28,26.11-4.5,39.17-6.83Z" transform="translate(-575.97 -827.22)"/><path class="b" d="M620.24,836.59h28.1v54.49h-28.1v-6.81h22.14v-3.41H620.24v-4.26h22.14V873.2H620.24v-4.26h22.14v-3.41H620.24v-4.26h22.14v-3.41H620.24v-4.26h22.14v-3.41H620.24V846h22.14v-3.41H620.24Zm-26.67,15c1.62-.09,3.24-.16,4.85-.25,1.13,5.75,2.29,11.49,3.52,17.21,1-5.91,2-11.8,3.06-17.7,1.7-.06,3.41-.15,5.1-.26-1.92,8.25-3.61,16.57-5.71,24.77-1.42.74-3.55,0-5.24.09-1.13-5.64-2.45-11.24-3.47-16.9-1,5.5-2.29,10.95-3.43,16.42q-2.45-.13-4.92-.3c-1.41-7.49-3.07-14.93-4.39-22.44l4.38-.18c.88,5.42,1.87,10.82,2.64,16.25,1.2-5.57,2.43-11.14,3.62-16.71Z" transform="translate(-575.97 -827.22)"/></svg> '+A.language.translate("Word Paste Detected")+"</h4>",t=(n='<div class="fr-word-paste-modal" style="padding: 20px 20px 10px 20px;">',n+='<p style="text-align: left;">'+A.language.translate("The pasted content is coming from a Microsoft Word document. Do you want to keep the format or clean it up?")+"</p>",n+='<div style="text-align: right; margin-top: 50px;"><button class="fr-remove-word fr-command">'+A.language.translate("Clean")+'</button> <button class="fr-keep-word fr-command">'+A.language.translate("Keep")+"</button></div>",n+="</div>"),r=A.modals.create(a,e,t),i=r.$body;l=r.$modal,r.$modal.addClass("fr-middle"),A.events.bindClick(i,"button.fr-remove-word",function(){var e=l.data("instance")||A;e.wordPaste.clean()}),A.events.bindClick(i,"button.fr-keep-word",function(){var e=l.data("instance")||A;e.wordPaste.clean(!0)}),A.events.$on(S(A.o_win),"resize",function(){A.modals.resize(a)})}var n;A.modals.show(a),A.modals.resize(a)}():t(!0),!1})},clean:t}}});
