!function(e){var t={};function i(s){if(t[s])return t[s].exports;var n=t[s]={i:s,l:!1,exports:{}};e[s].call(n.exports,n,n.exports,i);n.l=!0;return n.exports}i.m=e;i.c=t;i.d=function(e,t,s){i.o(e,t)||Object.defineProperty(e,t,{configurable:!1,enumerable:!0,get:s})};i.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};i.d(t,"a",t);return t};i.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)};i.p="//static.hsappstatic.net/MessagesWidgetShell/static-1.1846/";i(i.s=15)}([function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.getCookie=u;t.getHostnameWithoutWww=d;t.setCookie=l;t.getUtkFromCookie=h;var s=o(i(1)),n=i(6),a=i(9);function o(e){return e&&e.__esModule?e:{default:e}}var r={HUBSPOT:"hubspotutk",MESSAGES:"messagesUtk",IS_OPEN:"hs-messages-is-open",HIDE_WELCOME_MESSAGE:"hs-messages-hide-welcome-message",HUBSPOT_API_CSRF:"hubspotapi-csrf",TRACKING_CODE:"__hstc"};t.default=r;function u(e){var t=null;if(document.cookie&&""!==document.cookie)for(var i=document.cookie.split(";"),s=0;s<i.length;s++){var n=i[s].trim();if(n.substring(0,e.length+1)===e+"="){t=n.substring(e.length+1);break}}return t}function d(){return window.location.hostname.replace(/^www\./,"")}function l(e,t){var i=arguments.length>2&&void 0!==arguments[2]?arguments[2]:s.default.TWO_YEARS,n=[e+"="+t,"expires="+new Date(Date.now()+i).toGMTString(),"domain="+("."+d()),"path=/"].join(";");document.cookie=n}function h(e){var t=(0,n.getUuid)(),i=u(e);return(0,a.isUtk)(i)?i:t}},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});var s=864e5,n={TWO_MINUTES:12e4,THIRTY_MINUTES:18e5,ONE_DAY:s,TWO_YEARS:365*s*2};t.default=n;e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.warn=s;function s(e){window.console&&console.warn(e)}},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});var s=53;function n(e){var t=e.portalId,i=window.location.hostname;return/^(?:app|local)\.hubspot(?:qa)?\.com$/.test(i)&&t===s}t.default=n;e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.getWrappedIsMobile=r;var s=n(i(8));function n(e){return e&&e.__esModule?e:{default:e}}var a=/WebKit/i;function o(e,t){return e.test(t)}function r(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:navigator.userAgent,t=e.split("[FBAN");void 0!==t[1]&&(e=t[0]);void 0!==(t=e.split("Twitter"))[1]&&(e=t[0]);var i=new s.default.Class(e);i.other.webkit=o(a,e);i.safari=i.apple.device&&i.other.webkit&&!i.other.opera&&!i.other.chrome;return i}t.default=r()},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});var s={IFRAME_RESIZE:"iframe-resize",OPEN_CHANGE:"open-change",CLOSED_WELCOME_MESSAGE:"closed-welcome-message",REQUEST_WIDGET:"request-widget",STORE_MESSAGES_COOKIE:"store-messages-cookie",WIDGET_DATA:"widget-data",REQUEST_OPEN:"request-open",BROWSER_WINDOW_RESIZE:"browser-window-resize"};t.default=s;e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.getUuid=a;function s(){var e=(new Date).getTime();return"xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx".replace(/[xy]/g,function(t){var i=(e+16*Math.random())%16|0;e=Math.floor(e/16);return("x"===t?i:3&i|8).toString(16)})}function n(){var e=window.crypto||window.msCrypto,t=new Uint16Array(8);e.getRandomValues(t);var i=function(e){for(var t=e.toString(16);t.length<4;)t="0"+t;return t};return i(t[0])+i(t[1])+i(t[2])+i(t[3])+i(t[4])+i(t[5])+i(t[6])+i(t[7])}function a(){var e=window.crypto||window.msCrypto;return void 0!==e&&void 0!==e.getRandomValues&&void 0===window.Uint16Array?n():s()}},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.EVENTS=t.EXPECTED_WIDGET_WILL_NOT_LOAD_CODES=void 0;var s=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var i=arguments[t];for(var s in i)Object.prototype.hasOwnProperty.call(i,s)&&(e[s]=i[s])}return e},n=function(){function e(e,t){for(var i=0;i<t.length;i++){var s=t[i];s.enumerable=s.enumerable||!1;s.configurable=!0;"value"in s&&(s.writable=!0);Object.defineProperty(e,s.key,s)}}return function(t,i,s){i&&e(t.prototype,i);s&&e(t,s);return t}}(),a=v(i(4)),o=v(i(5)),r=i(0),u=v(r),d=v(i(1)),l=i(10),h=i(2),c=v(i(11)),p=v(i(12)),f=v(i(13)),m=v(i(3)),g=v(i(14));function v(e){return e&&e.__esModule?e:{default:e}}function w(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}var b="hubspot-messages-iframe-container",E="help-widget",_={ACTIVE:"hs-messages-widget-open",MOBILE:"hs-messages-mobile",SHADOW:"shadow",INTERNAL:"internal"},I=[200,304],O=t.EXPECTED_WIDGET_WILL_NOT_LOAD_CODES=[204,404],y="X-HubSpot-Messages-Uri",S=t.EVENTS={messagesInitialized:function(e){(0,c.default)("initialized",{messageWillRender:e})}},M=function(){function e(t){var i=t.portalId,s=t.messagesEnv;w(this,e);this.portalId=parseInt(i,10);this.messagesEnv=s;this.isMobile=a.default.any;this.mobileSafari=a.default.safari;this.windowsPhone=a.default.windows.phone;this.isOpen=!1;this.widgetData=null;this.iframeSrc=null;this.queryParams=null;this.handleMessage=this.handleMessage.bind(this);this.requestWidgetOpen=this.requestWidgetOpen.bind(this);this.handleWindowResize=this.handleWindowResize.bind(this);var n=(0,r.getUtkFromCookie)(u.default.MESSAGES),o=(0,r.getCookie)(u.default.HUBSPOT);this.messagesUtk=n;this.hubspotUtk=o}n(e,[{key:"getApiDomain",value:function(){return"https://api.hubspot"+("qa"===this.messagesEnv?"qa":"")+".com"}},{key:"getInternalRequestUrl",value:function(){return this.getApiDomain()+"/messages/v2/message/public/hubspot-app?portalId="+(0,p.default)()}},{key:"getPublicRequestUrl",value:function(){var e=this.getApiDomain()+"/messages/v2/message/public?portalId="+this.portalId,t=this.messagesUtk,i=this.hubspotUtk;t&&(e=e+"&messagesUtk="+t);i&&(e=e+"&hubspotUtk="+i);return e}},{key:"setIFrameDomainOverride",value:function(e){this.iFrameDomainOverride=e}},{key:"getIFrameDomain",value:function(){var e="qa"===this.messagesEnv?"qa":"";return this.iFrameDomainOverride?this.iFrameDomainOverride:"https://app.hubspot"+e+".com"}},{key:"getRequestUrl",value:function(){return(0,m.default)({portalId:this.portalId})?this.getInternalRequestUrl():this.getPublicRequestUrl()}},{key:"getIFrameSrc",value:function(){var e=(0,r.getCookie)(u.default.IS_OPEN)||!1,t=(0,r.getHostnameWithoutWww)(),i=encodeURIComponent(window.location.href),s=this.messagesUtk,n=this.hubspotUtk;this.queryParams={mobile:this.isMobile,mobileSafari:this.mobileSafari,open:e,hideWelcomeMessage:this.shouldHideWelcomeMessage(),domain:t,messagesUtk:s,url:i};n&&(this.queryParams.hubspotUtk=n);return this.getIFrameDomain()+"/conversations-visitors/"+this.portalId+"/threads/utk/"+s+"?"+(0,f.default)(this.queryParams)}},{key:"loadIFrame",value:function(){if(!document.getElementById(b)){var e=document.createElement("div");e.id=b;(0,m.default)({portalId:this.portalId})&&e.classList.add(_.INTERNAL);var t=document.createElement("div");t.className=_.SHADOW;e.appendChild(t);var i=document.createElement("iframe");this.iframeSrc=this.getIFrameSrc();i.src=this.iframeSrc;(0,m.default)({portalId:this.portalId})&&(i.id=E);e.appendChild(i);i.addEventListener("load",this.handleWindowResize);document.body.appendChild(e)}}},{key:"sendStartupRequest",value:function(){var e=this,t=this.getRequestUrl(),i=new XMLHttpRequest;i.addEventListener("readystatechange",function(){if(4===i.readyState)if(I.indexOf(i.status)>-1){e.widgetData=JSON.parse(i.responseText);if(null!==e.widgetData){e.loadIFrame();S.messagesInitialized(!0)}}else{S.messagesInitialized(!1);O.indexOf(i.status)<0&&(0,h.warn)("Initial messages API call failed")}});i.open("GET",t);i.setRequestHeader(y,window.location.href);(0,m.default)({portalId:this.portalId})&&(0,l.addAuthToRequest)(i);i.send()}},{key:"handleResize",value:function(e){var t=e.height,i=e.width,s=document.getElementById(b);if(this.isMobile&&this.isOpen){s.style.width="100%";s.style.height="100%"}else if(t&&i){s.style.width=i+"px";s.style.height=t+"px"}}},{key:"handleOpenChange",value:function(e){var t=document.documentElement,i=document.getElementById(b).getElementsByClassName(_.SHADOW)[0];this.isOpen=e;(0,r.setCookie)(u.default.IS_OPEN,this.isOpen,d.default.THIRTY_MINUTES);if(this.isOpen){t.classList.add(_.ACTIVE);i.classList.add("active")}else{t.classList.remove(_.ACTIVE);i.classList.remove("active")}if(this.isMobile&&this.isOpen){var s=window.innerHeight,n=window.innerWidth;this.handleResize({height:s,width:n})}}},{key:"isOriginAllowed",value:function(e){return this.getIFrameDomain()===e}},{key:"postMessageToIframe",value:function(e){var t=document.querySelector("#"+b+" iframe");t&&t.contentWindow.postMessage(JSON.stringify(e),this.iframeSrc)}},{key:"requestWidgetOpen",value:function(){this.postMessageToIframe({type:o.default.REQUEST_OPEN})}},{key:"handleMessage",value:function(e){var t=e.origin,i=e.data,n=e.source;if(this.isOriginAllowed(t)){var a=null;try{a=JSON.parse(i)}catch(e){return}var l=a,h=l.type,c=l.data;switch(h){case o.default.IFRAME_RESIZE:this.handleResize(c);break;case o.default.OPEN_CHANGE:this.handleOpenChange(c);break;case o.default.CLOSED_WELCOME_MESSAGE:(0,r.setCookie)(u.default.HIDE_WELCOME_MESSAGE,!0,d.default.THIRTY_MINUTES);break;case o.default.REQUEST_WIDGET:n.postMessage(JSON.stringify({type:o.default.WIDGET_DATA,data:s({},this.widgetData,this.queryParams)}),"*");this.setupExperimentalApi();this.throttleInProductInitialMessagePopups();break;case o.default.STORE_MESSAGES_COOKIE:(0,r.setCookie)(u.default.MESSAGES,c)}}}},{key:"registerMessageHandler",value:function(){window.addEventListener("message",this.handleMessage)}},{key:"handleWindowResize",value:function(){var e={height:window.innerHeight,width:window.innerWidth};this.postMessageToIframe({type:o.default.BROWSER_WINDOW_RESIZE,data:e})}},{key:"registerWindowResizeListener",value:function(){window.addEventListener("resize",this.handleWindowResize,{passive:!0})}},{key:"shouldHideWelcomeMessage",value:function(){return(0,r.getCookie)(u.default.HIDE_WELCOME_MESSAGE)||!1}},{key:"shouldRenderWidget",value:function(){var e=this.isMobile&&(0,g.default)({portalId:this.portalId}),t=!1;try{(0,p.default)();t=!0}catch(e){t=!1}var i=(0,m.default)({portalId:this.portalId})&&!t,s=window.disabledHsPopups&&window.disabledHsPopups.indexOf("LIVE_CHAT")>-1;if(e){window.hubspotMessagesWontLoadBecause="MOBILE_ON_PUBLIC_53";return!1}if(this.windowsPhone){window.hubspotMessagesWontLoadBecause="WINDOWS_PHONE";return!1}if(i){window.hubspotMessagesWontLoadBecause="MISSING_PORTAL_ID";return!1}if(s){window.hubspotMessagesWontLoadBecause="IS_EMBEDDED_MEETINGS";return!1}return!0}},{key:"setupExperimentalApi",value:function(){window.hubspot||(window.hubspot={});window.hubspot.messages||(window.hubspot.messages={});window.hubspot.messages.EXPERIMENTAL_API={requestWidgetOpen:this.requestWidgetOpen}}},{key:"throttleInProductInitialMessagePopups",value:function(){(0,m.default)({portalId:this.portalId})&&!this.shouldHideWelcomeMessage()&&(0,r.setCookie)(u.default.HIDE_WELCOME_MESSAGE,!0,d.default.ONE_DAY)}},{key:"start",value:function(){if(this.shouldRenderWidget()){this.isMobile&&document.documentElement.classList.add(_.MOBILE);this.registerMessageHandler();this.registerWindowResizeListener();this.sendStartupRequest()}else S.messagesInitialized(!1)}}]);return e}();t.default=M},function(e,t,i){"use strict";var s,n,a;!function(i){var o=/iPhone/i,r=/iPod/i,u=/iPad/i,d=/(?=.*\bAndroid\b)(?=.*\bMobile\b)/i,l=/Android/i,h=/(?=.*\bAndroid\b)(?=.*\bSD4930UR\b)/i,c=/(?=.*\bAndroid\b)(?=.*\b(?:KFOT|KFTT|KFJWI|KFJWA|KFSOWI|KFTHWI|KFTHWA|KFAPWI|KFAPWA|KFARWI|KFASWI|KFSAWI|KFSAWA)\b)/i,p=/Windows Phone/i,f=/(?=.*\bWindows\b)(?=.*\bARM\b)/i,m=/BlackBerry/i,g=/BB10/i,v=/Opera Mini/i,w=/(CriOS|Chrome)(?=.*\bMobile\b)/i,b=/(?=.*\bFirefox\b)(?=.*\bMobile\b)/i,E=new RegExp("(?:Nexus 7|BNTV250|Kindle Fire|Silk|GT-P1000)","i"),_=function(e,t){return e.test(t)},I=function(e){var t=e||navigator.userAgent,i=t.split("[FBAN");void 0!==i[1]&&(t=i[0]);void 0!==(i=t.split("Twitter"))[1]&&(t=i[0]);this.apple={phone:_(o,t),ipod:_(r,t),tablet:!_(o,t)&&_(u,t),device:_(o,t)||_(r,t)||_(u,t)};this.amazon={phone:_(h,t),tablet:!_(h,t)&&_(c,t),device:_(h,t)||_(c,t)};this.android={phone:_(h,t)||_(d,t),tablet:!_(h,t)&&!_(d,t)&&(_(c,t)||_(l,t)),device:_(h,t)||_(c,t)||_(d,t)||_(l,t)};this.windows={phone:_(p,t),tablet:_(f,t),device:_(p,t)||_(f,t)};this.other={blackberry:_(m,t),blackberry10:_(g,t),opera:_(v,t),firefox:_(b,t),chrome:_(w,t),device:_(m,t)||_(g,t)||_(v,t)||_(b,t)||_(w,t)};this.seven_inch=_(E,t);this.any=this.apple.device||this.android.device||this.windows.device||this.other.device||this.seven_inch;this.phone=this.apple.phone||this.android.phone||this.windows.phone;this.tablet=this.apple.tablet||this.android.tablet||this.windows.tablet;if("undefined"==typeof window)return this},O=function(){var e=new I;e.Class=I;return e};if(void 0!==e&&e.exports&&"undefined"==typeof window)e.exports=I;else if(void 0!==e&&e.exports&&"undefined"!=typeof window)e.exports=O();else{n=[],s=i.isMobile=O(),void 0!==(a="function"==typeof s?s.apply(t,n):s)&&(e.exports=a)}}(void 0)},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.isUtk=n;var s=t.UTK_REGEX=/[a-zA-Z\d]{32}/;function n(e){return s.test(e)}},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});t.addAuthToRequest=t.addCsrfHeader=void 0;var s=i(0),n=a(s);function a(e){return e&&e.__esModule?e:{default:e}}var o=t.addCsrfHeader=function(e){e.setRequestHeader("X-HubSpot-CSRF-hubspotapi",(0,s.getCookie)(n.default.HUBSPOT_API_CSRF))};t.addAuthToRequest=function(e){o(e);e.withCredentials=!0}},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});var s=Object.assign||function(e){for(var t=1;t<arguments.length;t++){var i=arguments[t];for(var s in i)Object.prototype.hasOwnProperty.call(i,s)&&(e[s]=i[s])}return e};t.default=a;var n="hubspot:messages:";function a(e,t){var i=void 0,a=""+n+e;"function"==typeof window.Event?i=s(new Event(a),t):(i=s(document.createEvent("Event"),t)).initEvent(a,!0,!0);window.dispatchEvent(i)}e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});function s(){return/^\/(?:[A-Za-z0-9-_]*)\/(\d+)(?:\/|$)/.exec(window.location.pathname)[1]}t.default=s;e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});function s(e){return Object.keys(e).reduce(function(t,i){t.push(i+"="+e[i]);return t},[]).join("&")}t.default=s;e.exports=t.default},function(e,t,i){"use strict";"use es6";Object.defineProperty(t,"__esModule",{value:!0});var s=n(i(3));function n(e){return e&&e.__esModule?e:{default:e}}var a=53;function o(e){var t=e.portalId;return t===a&&!(0,s.default)({portalId:t})}t.default=o;e.exports=t.default},function(e,t,i){"use strict";"use es6";var s=a(i(7)),n=i(2);i(16);function a(e){return e&&e.__esModule?e:{default:e}}var o=document.getElementById("hubspot-messages-loader"),r=new s.default({portalId:o.getAttribute("data-hsjs-portal"),messagesEnv:o.getAttribute("data-hsjs-env")});"undefined"!=typeof messagesConfig&&messagesConfig.iFrameDomain&&r.setIFrameDomainOverride(messagesConfig.iFrameDomain);if(void 0===window.hubspot_live_messages_running){window.hubspot_live_messages_running=!0;r.start()}else(0,n.warn)("duplicate instance of live chat exists on page")},function(e,t,i){"use strict";!function(e){var t=i(17),s=e.createElement("style");s.setAttribute("type","text/css");if(s.styleSheet)s.styleSheet.cssText=t;else{var n=document.createTextNode(t);s.appendChild(n)}var a=e.body.childNodes[0];e.body.insertBefore(s,a)}(document)},function(e,t){e.exports='html.hs-messages-widget-open.hs-messages-mobile,html.hs-messages-widget-open.hs-messages-mobile body{height:100%!important;overflow:hidden!important;position:relative!important}html.hs-messages-widget-open.hs-messages-mobile body{margin:0!important}#hubspot-messages-iframe-container{display:initial!important;z-index:2147483647;position:fixed!important;bottom:0!important;right:0!important}#hubspot-messages-iframe-container.internal{z-index:1016}#hubspot-messages-iframe-container.internal iframe{min-width:108px}#hubspot-messages-iframe-container .shadow{display:initial!important;z-index:-1;position:absolute;width:0;height:0;bottom:0;right:0;content:""}#hubspot-messages-iframe-container .shadow.active{width:400px;height:400px;background:radial-gradient(ellipse at bottom right,rgba(29,39,54,.16) 0,rgba(29,39,54,0) 72%)}#hubspot-messages-iframe-container iframe{display:initial!important;width:100%!important;height:100%!important;border:none!important;position:absolute!important;bottom:0!important;right:0!important;background:transparent!important}'}]);
//# sourceMappingURL=project.js.map