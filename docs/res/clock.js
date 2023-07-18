if(!window.matchMedia(`(prefers-reduced-motion:reduce)`).matches){
var canvas=document.createElement("canvas")
canvas.width=200
canvas.height=76
canvas.className="img-pixel"
canvas.style.width="100%"
document.getElementById("clock-id").replaceWith(canvas);
var ctx=canvas.getContext("2d")
var sheet=new Image()
sheet.src="/res/media/clock-idb.png"
function digit_at(d,x,y){ctx.drawImage(sheet,d*17,0,17,27,x,y,17,27)}
function frame(){
requestAnimationFrame(frame)
ctx.drawImage(sheet,0,27,200,76,0,0,200,76)
var time=new Date(),n
digit_at((n=time.getFullYear())%10,81,8)
digit_at((n=n/10|0)%10,15,8)
digit_at((n=n/10|0)%10,36,8)
digit_at((n=n/10|0)%10,60,8)
digit_at((n=time.getMonth()+1)%10,131,8)
digit_at((n=n/10|0),110,8)
digit_at((n=time.getDate())%10,176,8)
digit_at((n=n/10|0),155,8)
digit_at((n=time.getHours())%10,36,41)
digit_at((n=n/10|0),15,41)
digit_at((n=time.getMinutes())%10,81,41)
digit_at((n=n/10|0),60,41)
digit_at((n=time.getSeconds())%10,131,41)
if(n%2==0){
ctx.drawImage(sheet,170,6,4,15,54,47,4,15)
ctx.drawImage(sheet,170,6,4,15,104,47,4,15)
ctx.drawImage(sheet,170,6,4,15,149,47,4,15)}
digit_at((n=n/10|0),110,41)
digit_at((n=time.getMilliseconds()/10|0)%10,176,41)
digit_at((n=n/10|0)%10,155,41)
}sheet.onload=frame}
