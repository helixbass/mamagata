(window.webpackJsonp=window.webpackJsonp||[]).push([[4],{150:function(e,t,a){"use strict";a.r(t),a.d(t,"pageQuery",function(){return p});var n=a(0),r=a.n(n),i=a(152),o=a(155),c=a(160),l=a(161),s=a(157),u=a(158),d=a(153),m=Object(o.flow)(Object(c.addProps)(function(e){var t=e.post,a=t.frontmatter.title,n=t.fields.slug;return{title:a||n}}),function(e){var t=e.post,a=t.frontmatter,n=a.date,o=a.description,c=t.fields.slug,l=t.excerpt,s=e.title;return r.a.createElement("div",null,r.a.createElement("h3",{style:{marginBottom:Object(d.a)(.25)}},r.a.createElement(i.a,{style:{boxShadow:"none"},to:c},s)),r.a.createElement("small",null,n),r.a.createElement("p",{dangerouslySetInnerHTML:{__html:o||l}}))});t.default=function(e){var t=e.data,a=e.location,n=t.site.siteMetadata.title,i=t.allMarkdownRemark.edges;return r.a.createElement(s.a,{location:a,title:n},r.a.createElement(u.a,{title:"All posts",keywords:["blog","gatsby","javascript","react"]}),r.a.createElement(l.a,null),i.map(function(e){var t=e.node,a=e.node.fields.slug;return r.a.createElement(m,{post:t,key:a})}))};var p="75663657"},152:function(e,t,a){"use strict";a.d(t,"b",function(){return u});var n=a(0),r=a.n(n),i=a(4),o=a.n(i),c=a(33),l=a.n(c);a.d(t,"a",function(){return l.a});a(154);var s=r.a.createContext({}),u=function(e){return r.a.createElement(s.Consumer,null,function(t){return e.data||t[e.query]&&t[e.query].data?(e.render||e.children)(e.data?e.data.data:t[e.query].data):r.a.createElement("div",null,"Loading (StaticQuery)")})};u.propTypes={data:o.a.object,query:o.a.string.isRequired,render:o.a.func,children:o.a.func}},153:function(e,t,a){"use strict";a.d(t,"a",function(){return l}),a.d(t,"b",function(){return s});var n=a(163),r=a.n(n),i=a(164),o=a.n(i);o.a.baseLineHeight=1.62,o.a.overrideThemeStyles=function(){return{"a.gatsby-resp-image-link":{boxShadow:"none"},a:{color:"#1ca086"},h1:{marginBottom:"1.7rem"},h3:{marginTop:"1.33rem"},h4:{marginBottom:"0.85rem"},code:{fontSize:"0.95rem"},"pre code":{fontSize:"0.85rem"}}};var c=new r.a(o.a);var l=c.rhythm,s=c.scale},154:function(e,t,a){var n;e.exports=(n=a(156))&&n.default||n},156:function(e,t,a){"use strict";a.r(t);a(34);var n=a(0),r=a.n(n),i=a(4),o=a.n(i),c=a(55),l=a(2),s=function(e){var t=e.location,a=l.default.getResourcesForPathnameSync(t.pathname);return a?r.a.createElement(c.a,Object.assign({location:t,pageResources:a},a.json)):null};s.propTypes={location:o.a.shape({pathname:o.a.string.isRequired}).isRequired},t.default=s},157:function(e,t,a){"use strict";a(34);var n=a(0),r=a.n(n),i=a(152),o=a(155),c=a(160),l=a(153),s=function(e){var t=e.title;return r.a.createElement(i.a,{style:{boxShadow:"none",textDecoration:"none",color:"inherit"},to:"/"},t)},u=Object(o.flow)(Object(c.addProps)(function(e){var t=e.location,a=e.title;return{header:"/blog/"===t.pathname?r.a.createElement("h1",{style:Object.assign({},Object(l.b)(1.5),{marginBottom:Object(l.a)(1.5),marginTop:0})},r.a.createElement(s,{title:a})):r.a.createElement("h3",{style:{fontFamily:"Montserrat, sans-serif",marginTop:0}},r.a.createElement(s,{title:a}))}}),function(e){var t=e.header,a=e.children;return r.a.createElement("div",{style:{marginLeft:"auto",marginRight:"auto",maxWidth:Object(l.a)(24),padding:Object(l.a)(1.5)+" "+Object(l.a)(.75)}},r.a.createElement("header",null,t),r.a.createElement("main",null,a),r.a.createElement("footer",null,"© ",(new Date).getFullYear(),", Built with"," ",r.a.createElement("a",{href:"https://www.gatsbyjs.org"},"Gatsby")))});t.a=u},158:function(e,t,a){"use strict";var n=a(159),r=a(0),i=a.n(r),o=a(4),c=a.n(o),l=a(166),s=a.n(l);function u(e){var t=e.description,a=e.lang,r=e.meta,o=e.keywords,c=e.title,l=n.data.site,u=t||l.siteMetadata.description;return i.a.createElement(s.a,{htmlAttributes:{lang:a},title:c,titleTemplate:"%s | "+l.siteMetadata.title,meta:[{name:"description",content:u},{property:"og:title",content:c},{property:"og:description",content:u},{property:"og:type",content:"website"},{name:"twitter:card",content:"summary"},{name:"twitter:creator",content:l.siteMetadata.author},{name:"twitter:title",content:c},{name:"twitter:description",content:u}].concat(o.length>0?{name:"keywords",content:o.join(", ")}:[]).concat(r)})}u.defaultProps={lang:"en",meta:[],keywords:[],description:""},u.propTypes={description:c.a.string,lang:c.a.string,meta:c.a.arrayOf(c.a.object),keywords:c.a.arrayOf(c.a.string),title:c.a.string.isRequired},t.a=u},159:function(e){e.exports={data:{site:{siteMetadata:{title:"Helixbassment",description:"Articles on React, development, etc.",author:"Julian Rosse"}}}}},161:function(e,t,a){"use strict";var n=a(162),r=a(0),i=a.n(r),o=a(152),c=a(153),l="2760998521";t.a=function(){return i.a.createElement(o.b,{query:l,render:function(e){var t=e.site.siteMetadata.author;return i.a.createElement("div",{style:{display:"flex",marginBottom:Object(c.a)(2.5)}},i.a.createElement("p",null,"Written by ",i.a.createElement("strong",null,t)," who lives and works in NYC."))},data:n})}},162:function(e){e.exports={data:{site:{siteMetadata:{author:"Julian Rosse",social:{twitter:"helixbass"}}}}}}}]);
//# sourceMappingURL=component---src-pages-index-js-36ceac845f19548f6332.js.map