(function(){var d=document.documentElement,b=document.getElementById('lang');
function set(l){d.lang=l;d.dir=l==='ar'?'rtl':'ltr';document.title=l==='ar'?'إنس | Ins':'Ins | إنس';if(history.replaceState){history.replaceState(null,'',l==='en'?'#en':'#ar')}}
if(location.hash==='#en')set('en');
b.addEventListener('click',function(){set(d.lang==='ar'?'en':'ar')});})();
