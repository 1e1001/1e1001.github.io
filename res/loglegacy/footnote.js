(function(){
var f=document.getElementsByClassName("footnote"),z=document.createElement("p"),k,h
z.tabIndex="0"
z.id="footnote-preview"
z.style.display="none"
function b(e){var o=e.relatedTarget
e.target.onblur=null
if(z.contains(o))o.onblur=b
else{var l=z.children[0]
z.style.display="none"
l.onclick=null
setTimeout(function(){l.href="#rev"+h},0)
if(k!=z)while(z.childNodes.length)k.append(z.childNodes[0])}}
z.onkeyup=function(e){
if(e.key=="Escape")window["rev"+h].focus()}
window.content.append(z)
for(var i=0;i<f.length;++i){
if(f[i].id[0]=="f")continue
f[i].onclick=function(e){e.preventDefault()
var o=e.target
h=o.id.slice(3),k=window["foot"+h].parentNode
if(k!=z)while(k.childNodes.length)z.append(k.childNodes[0])
var l=z.children[0]
l.href="#foot"+h,l.onclick=function(){l.onblur=null
b({relatedTarget:document.documentElement,target:l})}
z.style.display="block",z.onblur=b
z.style.setProperty("--x",o.offsetLeft+"px")
z.style.setProperty("--y",o.offsetTop+"px")
z.focus()
return false}}})()
