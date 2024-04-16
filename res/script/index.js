// scroll
document.documentElement.onwheel=function(e){if(innerWidth/visualViewport.width<=1.01)e.currentTarget.scrollLeft+=e.deltaY}
// link animations
matchMedia('(prefers-reduced-motion)').matches||addEventListener('load',function(){var e=document.getElementsByTagName('a'),t=0,i=0
for(;i<e.length;++i){if(e[i].getAttribute('data-a'))e[i].onclick=function(e){e.preventDefault()
var q=this,a=q.getAttribute('data-a').split('@@'),p=q.getClientRects()[0],l=document.createElement('div'),i=document.createElement('span'),j=0,h=q.href
if(!h)return
am.classList.add('a')
ah.classList.add('a')
l.id='a'
l.className=q.getAttribute("data-t")||q.parentNode.getAttribute("data-t")
for(;j<a[2];++j)q=q.parentNode
q.style.opacity=0
i.innerHTML=a[1]
l.append(i)
l.style='--b:'+a[0]+';--x:'+p.x+'px;--y:'+p.y+'px;--w:'+p.width+'px;--h:'+p.height+'px'
document.body.append(l)
t&&clearTimeout(t)
onpagehide=function(){l.remove()
q.style.opacity='unset'
onpagehide=null}
t=setTimeout(function(){am.classList.remove('a')
ah.classList.remove('a')
location=h},650)}}})
// cube
addEventListener('load',function(l,i,j){l='0123567',i=0
while(i<l.length)j=window['f'+l[i++]],j.style.cursor='pointer',j.onclick=function(){19507063==(tco.innerText=(l=l<<3|this.id.slice(1)))&&(tcl.href='/todo/')}
l=1})
// weather
fetch("https://api.weather.gov/stations/KBFI/observations/latest").then(function(v){return v.json()}).then(function(v){var p=v.properties
function m(p,f){return p.value?f(p.value):"?"}
function Ud(v){return v+"°C"}
function Ua(v){return ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"][Math.round(v/22.5)%16]}
function Uq(v){return v.toFixed(1)+"%"}
function Us(v){return v+" km/h"}
function Up(v){return (v/1000).toFixed(2)+" kPa"}
function Uv(v){return (v/1000).toFixed(2)+" km"}
tw.innerHTML=
"<p style='float:left'><b>Redmond, WA</b>"+
"<p style='float:right'>"+new Date(p.timestamp).toLocaleTimeString("en-US",{hour:'2-digit',minute:'2-digit'})+
"<h1 style='font-size:2.5em;line-height:1.1'>"+m(p.temperature,Ud)+"</h1><table>"+
"<tr><th>Humidity</th><td>"+m(p.relativeHumidity,Uq)+"</td></tr>"+
"<tr><th>Wind</th><td>"+m(p.windDirection,Ua)+" "+m(p.windSpeed,Us)+"</td></tr>"+
"<tr><th>Barometer</th><td>"+m(p.barometricPressure,Up)+"</td></tr>"+
"<tr><th>Sea level</th><td>"+m(p.seaLevelPressure,Up)+"</td></tr>"+
"<tr><th>Dew Point</th><td>"+m(p.dewpoint,Ud)+"</td></tr>"+
"<tr><th>Visibility</th><td>"+m(p.visibility,Uv)+"</td></tr>"+
"</table>"});
