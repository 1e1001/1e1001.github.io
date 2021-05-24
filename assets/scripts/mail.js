(function(){
  var e=document.getElementById("mail"),l,t="mailto:",i=1;
  if(e!==undefined){
    l=e.childNodes;
    for(;i<l.length-1;i++)t+=l[i].data?l[i].data:l[i].alt;
    e.onclick=e.onkeydown=function(e){console.log(e);var k=e.keyCode||e.which;if(e.type==="click"||k===13)window.open(t)};
    e.className="flink"
  }
})();
