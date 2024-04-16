addEventListener('load',function(){window.t.outerHTML+="<h2 id='p'>0% Complete</h2>"
var r=[
/^\/myfont\.html$/,function(){return'/font/'},
/^\/style\.html$/,function(){return'/style/'},
/^\/404.html$/,function(){return'#'},
],n=r.length,t=location.pathname,q,d,z
c.href="#"
c.onclick=function(){clearTimeout(z)
c.innerText="ERR_HANDLE_CANCEL"
setTimeout(function(){c.href="/"},0)}
function p(){return Math.random()*900+100}function o(i){
if(i==n)return(window.p.innerHTML='<a href='+(d=d||'/')+'>100% Complete</a>')&&setTimeout(function(){location=d},p())
if(q=r[i++].exec(t))d=o.call.apply(r[i],q)||d
window.p.innerHTML=Math.round(100*(Math.random()+i++)/r.length)+"% Complete"
z=setTimeout(o,p(),i)}z=setTimeout(o,p(),0)})
