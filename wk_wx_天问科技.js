/*
@jzack

天问科技-7日打卡【微信小程序】

赚钱天天乐 同一家得 满一元 提现秒到支付宝 【仅写了签到和查余额】后续补充提现

抓包 taokeout.jutuike.com 域名header 里面XX-Token 的值 多账户 @ 或者 回车 分开 

数据填入 TWtoken 变量里面
cron: 10 10 * * *
定时一天一次
*/
const $ = new Env("天问科技-7日打卡");
let envSplitor = ['@', '\n']
let result, resurq, resurp, abcd = [], ooOoo = [], oOoo = 0, userCount = 0, OooOo = 'TWtoken'
let userCookie = ($.isNode() ? process.env[OooOo] : $.getdata(OooOo)) || '';
///////////////////////////////////////////////////////////////////
const _0x4bc5fc=_0x3c70;function _0x166e(){const _0x95c39=['\x69\x6f\x6e\x3d\x33\x2e\x34\x2e\x39\x26','\x61\x63\x30\x61\x38\x35\x35','\x61\x70\x70\x69\x64\x3d\x77\x78\x30\x66','\x36\x65\x34\x62\x63\x35\x65\x36\x61\x37','\x66\x62\x61\x63\x37\x32\x61\x61\x32\x37','\x73\x69\x67\x6e\x3d\x66\x65\x33\x34\x36','\x31\x30\x34\x38\x32\x34\x39\x30\x77\x68\x69\x55\x63\x4e','\x31\x38\x39\x6f\x6b\x44\x5a\x52\x75','\x31\x32\x34\x38\x32\x39\x34\x47\x78\x56\x69\x50\x74','\x32\x33\x31\x38\x36\x39\x39\x39\x59\x77\x46\x50\x67\x43','\x38\x37\x49\x51\x46\x71\x6f\x71','\x37\x70\x44\x61\x6a\x78\x67','\x38\x34\x38\x34\x34\x65\x48\x78\x73\x62\x72','\x33\x33\x30\x32\x50\x43\x51\x50\x67\x4f','\x32\x38\x38\x37\x32\x38\x48\x76\x6e\x72\x4b\x42','\x33\x33\x35\x39\x39\x35\x30\x58\x65\x52\x41\x62\x6e','\x38\x30\x74\x49\x77\x48\x54\x7a'];_0x166e=function(){return _0x95c39;};return _0x166e();}function _0x3c70(_0x5d1e5c,_0x406c5a){const _0xb273d2=_0x166e();return _0x3c70=function(_0x3365ca,_0x351222){_0x3365ca=_0x3365ca-(0x217e+0x1*0x250d+-0x1b1*0x29);let _0x48c14a=_0xb273d2[_0x3365ca];return _0x48c14a;},_0x3c70(_0x5d1e5c,_0x406c5a);}(function(_0x2176e1,_0xa2ca){const _0x23fbaf=_0x3c70,_0x210ffc=_0x2176e1();while(!![]){try{const _0x44a37c=-parseInt(_0x23fbaf(0x141))/(0x2*0x694+0xabc*0x3+-0x2d5b)*(-parseInt(_0x23fbaf(0x133))/(-0xec9+0x1a0c+-0x1*0xb41))+parseInt(_0x23fbaf(0x13e))/(-0x1*0x177f+0xb11+-0x27d*-0x5)*(parseInt(_0x23fbaf(0x140))/(-0x1*0x156b+-0x87a+0x1de9))+-parseInt(_0x23fbaf(0x132))/(0xce*0x26+-0xd0c+0x1183*-0x1)+parseInt(_0x23fbaf(0x13c))/(0x103b+-0x18f+-0x32*0x4b)*(parseInt(_0x23fbaf(0x13f))/(0xbb8+0x71*-0x8+-0x829))+-parseInt(_0x23fbaf(0x142))/(0x17*-0x8+-0x1*0x1bc5+-0x31*-0x95)*(parseInt(_0x23fbaf(0x13b))/(-0x1*-0x416+0x1490+-0x189d))+-parseInt(_0x23fbaf(0x13a))/(-0x67*0x3+-0x321+0x460)+parseInt(_0x23fbaf(0x13d))/(-0x838+-0x160a+0x1e4d);if(_0x44a37c===_0xa2ca)break;else _0x210ffc['push'](_0x210ffc['shift']());}catch(_0x8aa09c){_0x210ffc['push'](_0x210ffc['shift']());}}}(_0x166e,-0xd99*-0x97+0x7b16e+0x2*-0x364bf));let o0O=_0x4bc5fc(0x136)+_0x4bc5fc(0x137)+'\x64\x32\x30\x64\x26\x64\x65\x76\x69\x63'+'\x65\x3d\x78\x63\x78\x26\x76\x65\x72\x73'+_0x4bc5fc(0x134)+_0x4bc5fc(0x139)+_0x4bc5fc(0x138)+'\x61\x64\x63\x39\x35\x65\x66\x34\x63\x62'+_0x4bc5fc(0x135);
class UserInfo {
    constructor(str) {this.ooo = ++oOoo, this.ooO = `账号 [${this.ooo}] `, this.Ooo=str}
    async OoO() {await this.Oo()}
    async oOo() {await httpRequest('post', popu(`https://taokeout.jutuike.com/Profit/myProfit`, await this._o(), o0O))
        if (resurp.statusCode==200)
        result.code==1&&console.log(`${this.ooO}总收益 [${result.data.accumulate_proft}] 余额 [${result.data.balance}]`)}
    async oO() {await httpRequest('post', popu(`https://taokeout.jutuike.com/punch/punchTheClock`, await this._o(), o0O))
        if (resurp.statusCode==200)
        result.code==1&&console.log(`${this.ooO}${result.msg}`)}
    async Oo() {await httpRequest('post', popu(`https://taokeout.jutuike.com/punch/getPunchNum`, await this._o(), o0O))
        if (resurp.statusCode==200)
        result.code==1&&(result.data.counter==1&&(console.log(`${this.ooO}今日你已经打卡了`), await this.oOo()), result.data.counter==0&&await this.oO())}
async _o() {
return this.h={"Accept-Encoding":"gzip,compress,br,deflate","Content-Type":"application/x-www-form-urlencoded",Connection:"keep-alive",Referer:"https://servicewechat.com/wx0f6e4bc5e6a7d20d/2/page-frame.html",Host:"taokeout.jutuike.com","User-Agent":"Mozilla/5.0 (iPhone; CPU iPhone OS 14_8 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.20(0x18001442) NetType/WIFI Language/zh_CN","XX-Token":this.Ooo};}
}(async()=>{if(await checkEnv()){for(let a of ooOoo)abcd.push(a.OoO());await Promise.all(abcd)}})().catch(a=>console.log(a)).finally(()=>$.done());
async function checkEnv(){if(userCookie){let e=envSplitor[0];for(let f of envSplitor)if(userCookie.indexOf(f)>-1){e=f;break}for(let l of userCookie.split(e))l&&ooOoo.push(new UserInfo(l));userCount=ooOoo.length}else console.log(`未找到任何账号`);return console.log(`找到 ${userCount}个账号`),!0}
function popu(e,t,n=""){e.replace("//","/").split("/")[1];let l={url:e,headers:t,timeout:12e3};return n&&(l.body=n,l.headers["Content-Length"]=n?.length||0),l}async function httpRequest(e,t){return result=null,resurq=null,resurp=null,new Promise(n=>{$.send(e,t,async(e,t,l)=>{try{if(resurq=t,resurp=l,e);else if(l.body){if("object"==typeof l.body)result=l.body;else try{result=JSON.parse(l.body)}catch(o){result=l.body}}}catch(y){console.log(y)}finally{n()}})})}
function Env(e,s){return"undefined"!=typeof process&&JSON.stringify(process.env).indexOf("GITHUB")>-1&&process.exit(0),new class{constructor(e,s){this.name=e,this.notifyStr="",this.startTime=(new Date).getTime(),Object.assign(this,s),console.log(`${this.name} 开始运行：
`)}isNode(){return"undefined"!=typeof module&&!!module.exports}isQuanX(){return"undefined"!=typeof $task}isSurge(){return"undefined"!=typeof $httpClient&&"undefined"==typeof $loon}isLoon(){return"undefined"!=typeof $loon}getdata(e){let s=this.getval(e);if(/^@/.test(e)){let[,i,n]=/^@(.*?)\.(.*?)$/.exec(e),r=i?this.getval(i):"";if(r)try{let o=JSON.parse(r);s=o?this.lodash_get(o,n,""):s}catch(a){s=""}}return s}setdata(e,s){let i=!1;if(/^@/.test(s)){let[,n,r]=/^@(.*?)\.(.*?)$/.exec(s),o=this.getval(n);try{let a=JSON.parse(n?"null"===o?null:o||"{}":"{}");this.lodash_set(a,r,e),i=this.setval(JSON.stringify(a),n)}catch(l){let h={};this.lodash_set(h,r,e),i=this.setval(JSON.stringify(h),n)}}else i=this.setval(e,s);return i}getval(e){return this.isSurge()||this.isLoon()?$persistentStore.read(e):this.isQuanX()?$prefs.valueForKey(e):this.isNode()?(this.data=this.loaddata(),this.data[e]):this.data&&this.data[e]||null}setval(e,s){return this.isSurge()||this.isLoon()?$persistentStore.write(e,s):this.isQuanX()?$prefs.setValueForKey(e,s):this.isNode()?(this.data=this.loaddata(),this.data[s]=e,this.writedata(),!0):this.data&&this.data[s]||null}send(e,s,i=()=>{}){if("get"!=e&&"post"!=e&&"put"!=e&&"delete"!=e){console.log(`无效的http方法：${e}`);return}if("get"==e&&s.headers?(delete s.headers["Content-Type"],delete s.headers["Content-Length"]):s.body&&s.headers&&(s.headers["Content-Type"]||(s.headers["Content-Type"]="application/x-www-form-urlencoded")),this.isSurge()||this.isLoon()){this.isSurge()&&this.isNeedRewrite&&(s.headers=s.headers||{},Object.assign(s.headers,{"X-Surge-Skip-Scripting":!1}));let n={method:e,url:s.url,headers:s.headers,timeout:s.timeout,data:s.body};"get"==e&&delete n.data,$axios(n).then(e=>{let{status:s,request:n,headers:r,data:o}=e;i(null,n,{statusCode:s,headers:r,body:o})}).catch(e=>console.log(e))}else if(this.isQuanX())s.method=e.toUpperCase(),this.isNeedRewrite&&(s.opts=s.opts||{},Object.assign(s.opts,{hints:!1})),$task.fetch(s).then(e=>{let{statusCode:s,request:n,headers:r,body:o}=e;i(null,n,{statusCode:s,headers:r,body:o})},e=>i(e));else if(this.isNode()){this.got=this.got?this.got:require("got");let{url:r,...o}=s;this.instance=this.got.extend({followRedirect:!1}),this.instance[e](r,o).then(e=>{let{statusCode:s,request:n,headers:r,body:o}=e;i(null,n,{statusCode:s,headers:r,body:o})},e=>{let{message:s,response:n}=e;i(s,n,n&&n.body)})}}time(e){let s={"M+":(new Date).getMonth()+1,"d+":(new Date).getDate(),"h+":(new Date).getHours(),"m+":(new Date).getMinutes(),"s+":(new Date).getSeconds(),"q+":Math.floor(((new Date).getMonth()+3)/3),S:(new Date).getMilliseconds()};for(let i in/(y+)/.test(e)&&(e=e.replace(RegExp.$1,((new Date).getFullYear()+"").substr(4-RegExp.$1.length))),s)RegExp("("+i+")").test(e)&&(e=e.replace(RegExp.$1,1==RegExp.$1.length?s[i]:("00"+s[i]).substr((""+s[i]).length)));return e}async showmsg(){if(!this.notifyStr)return;let e=this.name+" 运行通知\n\n"+this.notifyStr;if($.isNode()){var s=require("./sendNotify");console.log("\n============== 推送 =============="),await s.sendNotify(this.name,e)}else this.msg(e)}logAndNotify(e){console.log(e),this.notifyStr+=e,this.notifyStr+="\n"}msg(e=t,s="",i="",n){let r=e=>{if(!e)return e;if("string"==typeof e)return this.isLoon()?e:this.isQuanX()?{"open-url":e}:this.isSurge()?{url:e}:void 0;if("object"==typeof e){if(this.isLoon()){let s;return{openUrl:e.openUrl||e.url||e["open-url"],mediaUrl:e.mediaUrl||e["media-url"]}}if(this.isQuanX()){let i;return{"open-url":e["open-url"]||e.url||e.openUrl,"media-url":e["media-url"]||e.mediaUrl}}if(this.isSurge())return{url:e.url||e.openUrl||e["open-url"]}}};this.isMute||(this.isSurge()||this.isLoon()?$notification.post(e,s,i,r(n)):this.isQuanX()&&$notify(e,s,i,r(n)));let o=["","============== 系统通知 =============="];o.push(e),s&&o.push(s),i&&o.push(i),console.log(o.join("\n"))}getMin(e,s){return e<s?e:s}getMax(e,s){return e<s?s:e}padStr(e,s,i="0"){let n=String(e),r=s>n.length?s-n.length:0,o="";for(let a=0;a<r;a++)o+=i;return o+n}json2str(e,s,i=!1){let n=[];for(let r of Object.keys(e).sort()){let o=e[r];o&&i&&(o=encodeURIComponent(o)),n.push(r+"="+o)}return n.join(s)}str2json(e,s=!1){let i={};for(let n of e.split("#")){if(!n)continue;let r=n.indexOf("=");if(-1==r)continue;let o=n.substr(0,r),a=n.substr(r+1);s&&(a=decodeURIComponent(a)),i[o]=a}return i}randomString(e,s="abcdef0123456789"){let i="";for(let n=0;n<e;n++)i+=s.charAt(Math.floor(Math.random()*s.length));return i}randomList(e){return e[Math.floor(Math.random()*e.length)]}wait(e){return new Promise(s=>setTimeout(s,e))}done(e={}){let s=((new Date).getTime()-this.startTime)/1e3;console.log(`
${this.name} 运行结束，共运行了 ${s} 秒！`),(this.isSurge()||this.isQuanX()||this.isLoon())&&$done(e)}}(e,s)}