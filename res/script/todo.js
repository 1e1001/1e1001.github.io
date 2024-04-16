//port of https://github.com/niutech/x-frame-bypass/
//licensed APACHE 2.0
addEventListener('load',function(){
var P=['',
'https://api.codetabs.com/v1/proxy/?quest=',
'https://cors-anywhere.herokuapp.com/',
'https://yacdn.org/proxy/',
],U,H=[],I=0
i.readOnly=false
i.className+=' w'
f.srcdoc=''
f.sandbox='allow-forms allow-modals allow-pointer-lock allow-popups allow-popups-to-escape-sandbox allow-presentation allow-same-origin allow-scripts allow-top-navigation-by-user-activation'
function q(t){return t.replaceAll('&','&amp;').replaceAll('<','&lt;')}function p(u,a,i){
return fetch(P[i]+u,a).then(function(r){if(!r.ok)throw new Error(r.status+' '+r.statusText)
return r}).catch(function(e){if(i==P.length-1){f.srcdoc="<h1>Loading Failed</h1><p>"+e+"</p>"
throw e}return p(u,a,i+1)})}f.l=function(u,a){console.log('load',u)
u=new URL(i.value=u)
var P=u.protocol+'//'+(u.username||u.password?u.username+(u.password?':'+u.password:'')+'@':''),S=(u.port?':'+u.port:'')+u.pathname+u.search+u.hash
o.innerHTML=q(P)+'<b>'+q(u.hostname)+'</b>'+q(S)
u=u.href
if(!(a||{}).z){H.length=I
if(H[I-1]!=u){H.push(u)
++I}}nb.classList[I<=1?'add':'remove']('g')
nf.classList[I==H.length?'add':'remove']('g')
console.log(I, H)
U=u
if(!u||!u.startsWith('http'))throw new Error('Not an http(s) url: '+u)
nr.innerText="\uE5CD"
p(u,a,0).then(function(r){return r.text()}).then(function(d){console.log('done',f)
// this doesn't work for pages without a head, oh well!
if(d)nr.innerText="\uE5D5",f.srcdoc=d.replace(/<head([^>]*)>/i,'<head$1><base href="'+u+'"/><script type="text/javascript">addEventListener("load",function(e){var p=frameElement\nwhile(p.parentNode)p=p.parentNode\np.getElementsByTagName("title")[0].innerText=document.getElementsByTagName("title")[0].innerText+" — Browser"})\ndocument.addEventListener("click",function(e){if(frameElement&&document.activeElement&&document.activeElement.href){e.preventDefault()+frameElement.l(document.activeElement.href)}})\ndocument.addEventListener("submit",function(e){if(frameElement&&document.activeElement&&document.activeElement.form&&document.activeElement.form.action){e.preventDefault()\nif(document.activeElement.form.method==="post")frameElement.l(document.activeElement.form.action,{method:"post",body:new FormData(document.activeElement.form)})else frameElement.l(document.activeElement.form.action+"?"+new URLSearchParams(new FormData(document.activeElement.form)))}})</script>')}).catch(function(e){console.error('Cannot load:',e)})}
var O=new MutationObserver(function(m){
for(var i=0;i<m.length;++i)if(m[i].type='attributes'&m[i].attributeName=='src')f.l(f.src)})
console.log('f',f)
try{O.observe(f,{attributes:true})}catch(e){}i.onkeydown=function(e){if(e.key=='Enter'){try{f.l(i.value)
i.blur()}catch(e){i.value=U
alert("invalid url")}}}
i.onblur=function(){i.value=U}
nb.onclick=function(e){e.preventDefault()
I>1&&f.l(H[--I-1],{z:1})}
nr.onclick=function(e){e.preventDefault()
nr.innerText=="\uE5D5"&&f.l(U)}
nh.onclick=function(e){e.preventDefault()
f.l('https://michael.malinov.com/NOTDONE.HTM')}
nf.onclick=function(e){e.preventDefault()
if(I<H.length)f.l(H[I++],{z:1})}
f.l(i.value==='~'?location.origin+"/NOTDONE.HTM":i.value)})
