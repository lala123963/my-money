This file contains bidirectional Unicode text that may be interpreted or compiled differently than what appears below. To review, open the file in an editor that reveals hidden Unicode characters. Learn more about bidirectional Unicode characters
/*
粉丝福利红包一次性
cron:49 17,18 * * *
============Quantumultx===============
[task_local]
#粉丝福利红包一次性
19 15,18 * * * jd_fanshb.js, tag=粉丝福利红包一次性, enabled=true
 */

const $ = new Env('粉丝福利红包一次性');
var OＯ0$='jsjiami.com.v6',OＯ0$_=['‮OＯ0$'],O00O=[OＯ0$,'woxswq/Cn8OQ','KB96wofDmw==','IsKrOcKiw78=','V8K/w6c8wqY=','w5FlwpQ=','5Lq55Lmc5p6s5Yun5Zms6Ky26ZST5pWs5oyn5LmW56iw77yv6K6I5qGC5p626IS66Lie6KyB5aWA57+G57iO5oCp5YSo','d009LsO9','asOUTmbCgg==','w5dQw5M=','wpnDtcOa','5Lmc5LuF5p+h5Ym95Zi36K6m6Zek5pSp5o6H5Lm356qL772u6Kys5qKl5pyz6ISv6Lu46K6E5aW357ya57qf5oKk5Yed','JMKLw6l6w5nDjcKEwrXCrDAxwrzDsDbCjApJesKuwpgZWGJ+a8KZwoLCo1PCo8KoIyrCtjh/wp/DvMKrwpsowrVw','wrM9wozCow==','Nn4FwpnDmw==','AS/CiMKODg==','wp1PcibDlA==','woDCuMKewq86','woNNfMOyw7w=','wqFvSg==','J8OMO28=','w6HClRPDv3Q=','w4B7A8KqZA==','w44fD8OYwojCpw==','LFbCo8KLwr8INTFww4tpw6E=','wrvDtjjCj8O5woM=','w57DtsKGwrgcdmUywoAow58Iwqg=','R0nCtUNrbg==','Y3jCpwzDjcKrwrorLA==','wogjwofDqA==','wqpzX8O4w4wpw6k=','wpTDpMKbwro=','w5XCtDQ=','w5hkwoU=','w4svw64pPQ==','Pwp8','wqtlNg3DpMKgcg==','wpfCvMKYwrg+bWs=','NABvw57ChGd/','PCh2NMKeSsO1w5ld','Q1vCiw==','w7JbPcOxPcOe','Q8KNEiLCtsKd','OcOJL8Krw7/CmMOqZg==','CUA9','w5NLw4ATw44vTQ09XGvCji00LcOMGHNQw55aXD8JX8OTw7LCuxJbwpXCtMKdFhLDklZSw5HDhxTCjsO/','XsKxW3M=','XXQKZg==','SMKXGQ==','wqB3JQE=','w4hhwqLCsQ==','w4BlHcKq','w7wBw40V','w7VIwo02w4Q=','wpJkwr7Ch8O7esK5QQ==','asOgw48=','wrEVwp5Jwpc/SOW8ouWmlOOAqeS6puS7vOi0peWOrg==','fsOAw6IBw7NVw7kM','D8OOVHzDucOFw4nCo07Dug==','OhZXw5XCgnpw','wp3Cn8Kfag==','wonDosKP','wpvDu8OQSg==','44GD5o6156Sh44KrwoZ8ccKPwqXDheW2rOWkueaVnw==','w5lCwr3DlyY=','JsOoE8KBwoHDgMK1Ng==','wohRM8Oh','wqVzDAbDocKx','EFnDkhvCjsKh5be05aau5pazCcKFwqA=','5Liw5Li66LeP5Y6k','b8Ohw4wIw64=','wrHDosKNwqBYw4BubA==','WeiukumHluaUiueanuW9huiOqeWMssKvw48xY37DlA==','w7/Ciw3Dvw==','w4dNwrDDhg==','D2bCiRc=','w6x3QA==','wrzDpBvChQ==','w5R5wr3DniEz','FEokwrLCpcKrwq00HW0=','LVrCoQ==','RcOSw6oW','HCZtPMKf','wrFc5aaX6Laywpdj5Yye5ZqSw4PDrQ==','QcKLEDM=','LndIEA==','RMKEw7Yxwr8=','wrthKx0=','w7HDl13Dng==','XsKvJAw=','5ayw772C6Iy15b+N772C','RHDDsHY=','6K235Yun6Zqo5oWO5Z2zwqvDt8K9wqPCrui9h+WGkOagteS/juaUi+WEreWvlcOX5buZ6K2G6YG16L2z6Ie85p+T5Y+G6I+p5Y+fw63Cgj/Ch8KSw4c=','BBXDkQ==','awzCjsKbSQI9wr7CrcKQwprDmcO8w7rDm8KGCg==','wrR+ZQfChA==','w7pRN8OqecOaDMODAzI=','EF5kwrzCj8OqwroyFg==','w48YNcOHwp/DuDtVKjbCt8O+w7vCi8KAwr/CnUDDtmHDr8OefFvDj3BYwrzCt8OjwrJ6wo0RwrHDkcOFOxrCqMKSQGjCgMKcwqDDtENgchM0wq0Vw64LwqPDkhDDtMOoEyPDt8Kww53Dsw==','VWnCgA==','wp9HBzXCpQ==','w40Wwrgcw60=','woPDoMO+asKu','XXRrGcKN','LhZIEMOH','w5jCrjbDnjfCucKCQ8K9SMOww4XCqsK0TMKxCizCjsOTw67DncKtbMKfw7bDh8OMJsO4w7t1w6JZwqHDg8KLRcKJHwUfVkbDsSc7PDFTV0nCh8OLDg9RflzDtXvCpsOEw4LCsSsn','wpZzw6Q=','w6hlKwHChFDCtzgCRMKUIsKjw7Zpw6/CqcK8BcOHwqpgwr0kU13CgkQsXhp3DiDCjmB7MsKzw5pxworCtHhCwr5eaBM7QcKBw6x6w65aZE4Mw7bCrcOwBHZvBxvCsMOzSMOvES8+woAYwq8ALMKZJlPDusO1','AipUw6vDlQ==','wptowqk=','woNTHcKNw7w=','eMK7w5UXw7s=','woguM8O/Lw==','BU4pwr3CrsKqwr0=','YSVONcKq','VcKVw7kzwo4cw7k=','T0XDrkzDtg==','w7JbwrzCgXU=','PHnDrEA=','wr9MX8OUw5cvw4XCp8O/w5Q=','w6Uwwo7CizLCk8OR','ZMOuw4sGw5PDgMKu','YCtd','MBZWDsOH','R8KFHT3ClsKBwoc=','ShIV','IxPCoA==','w79VP8O/','w41pwqYcw60=','w4Ehw6UfKnw=','wrjCnlRl','w5FXFw4=','wqjDrVvCg8Oz','ZxPCgsKbSEM1wrLCvcKZ','TWXCpBXDlcKow7ZuagRww7ptTMOaFMKFw7oaw5bDrE/Cp8OcZsONX8O4YUXDjhbCkksQLQB8SMOkw5pqwrZDPWPCssOWwrhcw6F8woF9wobCtQfDuEPDpy4TOw8awpVrwq3Ch8OCDcKDH0nDpMOZw7BQwrDCmgPCtcO1UkzCvcKbw6TDhQjDoyLClzYaw4RqUlwaP1Bjw40gXsOAT8OcKFfCih7CmMOcwqnDkcO1wqYowpsGIlLDkcKDwpXDqMO1MDXCvcOUwqTCjQsT','woPDoMKfdMKu','O8KOwrNgw47DmcOIw7XCow==','Rk7Cj1x8MX5pwp3Do8Kcw4bDlcOfwqjCsMKOJsOYwo3CqMKRw6XDiAPDrFJ3U8KmdjLCgx3DnsONw6dUwqIAeT4Tw6Y3wpJYM3zCt8Kkw69xYhHDlB11w73DlsOsABAwD8OzIcOCwqsuPcOpwqvCkm8xD3XCuTzCvcODCw==','wrdrbw==','CsKAAMKNTWjDqMOpw53CjsO9T2jClSp5wpJfw6fCh8OKwr4Dw5TCsUjClsOpPcOCw6MBwqPDvMOyFAokwofCpsKQwqF3Q8KOU8OqCsKQwqw1wqNJwqvCrcKvwqk8KMKwGcK7GBjDrcOnw4fCnFxkw6BLw7/DnGIyMSPCr8OgY0NGw64=','XsOQOgwt','w5dJwq0=','w7/ClRPDvxU=','wogwM8O/Tg==','w54ew7AzImt3TsKDFA==','FH84wr/CkcKhwp04CHc=','w6ZHLS5fwqsfwrtsdQ==','aTJCMMKc','TSjCn8Khwp4=','w4PCijDDhz7DpsOpCcK5Wg==','AS/ClsOvDg==','w4xMwpbDmMOn','w7ETw4E=','w7Mdw4vDsg==','woNTHcOs','QxUKBw==','wpEQwp4=','LsOXP3rCtMOFfMO3LG/DmDXDmsKIwpJkw7g=','wrNcwpLCo8KF','woNNHcOsw6I=','KsOHw4U/woU=','w55lYsKqGw==','fwrDixw/','wrY7OzjCrQ==','wqHDqcK9wo0Q','ACJP','WTR6OsKZSsOww7J1wokiwrYmw6JQw6xDw7HDmwfDnUfDmjYxwo3DnwHCusOswrI3CAwYJ8OTw4/Dt8OgVyfDtsKSMsKXZHhCwqdVagPCscKww55GAsKpwpPDrC3Cr8K7HRTDtcObMCU+w7zCiw/DjgfDn0rCigDCjHzDug==','w5jCrjbDnjfCucKCQ8K9SMOww4XCqsK0TMKxCizCjsOTw67DncKtbMKfw7bDh8OMJsO4w7t1w6JZwqHDg8KLRcKJHxAYUkPDlxksLTVVU17ClsOPCANMcUjDpSPDqsOSw5LCtipsw4dAwonCnHkCwphrwpJpw5jCmR/CgxA=','B2l4','ZlrCpT0eVsOhwromwrbCjsOAJMOuFMKWEcKYw7Z6cMOQwp3CmMKbIcK+CHzCm1t4wq3DmcKAWMOtYCBbwoPDnzbDvAXCkcKFw5zClcKqF2HCtHHDl8OrPMK5O2geQ1jDpsOfw5fCi8KgbzHDgsKifsOkw5oKZy/CiMO7wrbDqXM=','QRnCncKCCU44w7TDvsOSw4vCjcKxwr/Cq8KMF1XCosOtRWXDhy5kJ8KqwqYUMkDCvsKAw7DChTLCoMOibUlDfcKWZ8KJw6AIw4FCJ8OmwrYhw6FfbMOxwpY2w7PCg8KLwo7DscObw43CqsKyEcKqHsOxWWTDmGfCssOHLMKkZsKHTsOEFzvDgMKJwq9sOjRfwrxgwrfDssOdWXQ2ZCxSGsK8KSAmw53Cn8OGSMOeW2nDp8KbJsOgw5PDtcKYUCpvBXbDm8KRdFJlw58+dcOI','axPCkw==','wqx2w47Cqw==','w6F9w6nDvW4=','wqvDnsOYwp1Z','w4Ehw6U=','CcO5w601w4dM','R8Ocw6A2w49G','KGAbwoc=','HCpKworDlQ==','w7l4OA==','5LiX5Lij5p655YuC5ZuV6L+B5Zq856mY5pSv5o2X','HMO5HMKWwqzDlQ==','IkjCtT0=','wrZEO1k=','Q2XCsRfDkMKhw6QLGw==','KMOdJmbDscKGecOmI2zDl27DlcOXw51owqbCicOhdRnCsC94V8KCwpXCpwTChcKHwqk=','EsOrBsKfwqbDgsK5J23CqMOaeMO3wrXClcKOwrlNw5dDw6tcG8OIMwzCicOUO1DCssKzUg==','wp7DucOFwrF4','w4wJJMOHw4HCo3gTKyI=','S8K5w58jw7BsWcKNwrRRPmjDnw==','wqZ4TMONw51xw6jCksOkw5jCpl/Dk8ObVhImwpLChwzDuxvDhTrCosKUa1DDm8K5w4XCiMK/dMORw5vCkMOrTcORaMKnQ8O4woJydxXCu8O9ER7ClxjCihJmdF8nDV1GwoxFE8KUwqgyRXxuRcOMAmM/wrzDjh/DkHLCt0RgwpjDvMObw5vCjcOUwpIBRcKXd0orAMOYw5/CjcKFwonDucO0w5/CuMKdZMOUUBzCq8Oiw5QMdAF7bcOdBsOwRsKLWMK/w4rDsy8aVEx0dUbDsHkew6R9w7XDmBLDsE5MUAcuJG7DiMKRwr4FGcOyw44=','woQOE8ObdjIDcsOg','wrZaWjjDjA==','Nn56w6bDmw==','wpYwLcKAUA==','KGAbwpnDmw==','w6diTjF3w4nDvMKgwo/CscK1woEWDBLDih4=','XsKvOnNM','AMO4w7w=','w7powobDpw1dYlzDlDsywrIV','bDktNMO/BhAlW10SM2c=','AEo+wrLCisKwwrg=','wqwXwq/Cqw4=','woDCtsKfwqg=','PMOKJ8ODwoA=','w7x+wrJqCQ==','5a2t77+V6I2b5b2L772F','woPDlDnCrw==','EXjCiRc=','Y8KPDA==','w45+woHDmCsxwqc0woE=','SBwfBA==','wpBtwonDu+iuqeaxmuWkgei0pu++meiui+ait+acmee8kOi3rumGh+isiA==','woPCtUbCscOM','RBHDsHY=','dMOUTmbCnA==','wrXDgMOYwp1Z','w6F9wojCgm4=','woXDi3E2w6cmwqY=','w7x+w40VaA==','UzbCn8K/','w48oaA4U','w6/DhXjDhUZsLw==','VsK0DD/CqcKKwqfDrBfCkw==','wobDisOPRsKXwqVBwqIsw6c=','w7XDpkbDg1tgBcKqw5nCsQ==','w79jw6nDvW4=','w6JkIMOzLsOeJMOPBjQ=','w5VWw5cIw7N0D0c=','w7JPwoo4w5LDisO9wqY=','wplzJxvDi8K1fsOv','wrrCqsKNfsKi','cGcUfcOR','w6xFw4PCgQ==','ZRzCpMKKwrAYGg==','wqApwpHDsFdgwrrCnw==','YcOqw5wJw7fDmsKr','wqwXwq/Cq28=','wpDDi3Exw6k2wqI=','eMKlwqpow7s=','ES56NMK5TsOrw7Y=','WTdfJMKMTsOswr4=','5LiR5LiW5p++5YiQ5Zit6L6C5ZiQ56io5paI5o23','asOgw48ow6TDnA==','LghIEMK4','wqgDFsOVfCM=','fcODLMKn','eMOEw4sJwpo=','Y8ODMsK5cg==','w71bNQ==','QMKcBA==','wp3CtSfDkMOM','SjsjUiamui.WcMHwCom.XDvn6BlIe=='];if(function(_0x51550e,_0x50d10b,_0x32e7da){function _0x80c957(_0x4e2bff,_0x419747,_0x70d10d,_0x360f8d,_0x488b57,_0x26f57c){_0x419747=_0x419747>>0x8,_0x488b57='po';var _0x5e8817='shift',_0x7067f5='push',_0x26f57c='‮';if(_0x419747<_0x4e2bff){while(--_0x4e2bff){_0x360f8d=_0x51550e[_0x5e8817]();if(_0x419747===_0x4e2bff&&_0x26f57c==='‮'&&_0x26f57c['length']===0x1){_0x419747=_0x360f8d,_0x70d10d=_0x51550e[_0x488b57+'p']();}else if(_0x419747&&_0x70d10d['replace'](/[SUuWMHwCXDnBlIe=]/g,'')===_0x419747){_0x51550e[_0x7067f5](_0x360f8d);}}_0x51550e[_0x7067f5](_0x51550e[_0x5e8817]());}return 0x104f8a;};return _0x80c957(++_0x50d10b,_0x32e7da)>>_0x50d10b^_0x32e7da;}(O00O,0x112,0x11200),O00O){OＯ0$_=O00O['length']^0x112;};function O0QQ(_0xe2b339,_0x408fba){_0xe2b339=~~'0x'['concat'](_0xe2b339['slice'](0x1));var _0x2c6821=O00O[_0xe2b339];if(O0QQ['O0QQO0']===undefined){(function(){var _0x3b1b2b=typeof window!=='undefined'?window:typeof process==='object'&&typeof require==='function'&&typeof global==='object'?global:this;var _0x1cabcc='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';_0x3b1b2b['atob']||(_0x3b1b2b['atob']=function(_0x27aa2a){var _0x197678=String(_0x27aa2a)['replace'](/=+$/,'');for(var _0xbf65f9=0x0,_0x2ab6f4,_0x17b507,_0x1457a4=0x0,_0x177d5f='';_0x17b507=_0x197678['charAt'](_0x1457a4++);~_0x17b507&&(_0x2ab6f4=_0xbf65f9%0x4?_0x2ab6f4*0x40+_0x17b507:_0x17b507,_0xbf65f9++%0x4)?_0x177d5f+=String['fromCharCode'](0xff&_0x2ab6f4>>(-0x2*_0xbf65f9&0x6)):0x0){_0x17b507=_0x1cabcc['indexOf'](_0x17b507);}return _0x177d5f;});}());function _0x240827(_0x5a99ab,_0x408fba){var _0x37e1c7=[],_0x1bd891=0x0,_0xb754b6,_0x2bac55='',_0x28c41e='';_0x5a99ab=atob(_0x5a99ab);for(var _0x2c9d29=0x0,_0x57cbc1=_0x5a99ab['length'];_0x2c9d29<_0x57cbc1;_0x2c9d29++){_0x28c41e+='%'+('00'+_0x5a99ab['charCodeAt'](_0x2c9d29)['toString'](0x10))['slice'](-0x2);}_0x5a99ab=decodeURIComponent(_0x28c41e);for(var _0x44e16c=0x0;_0x44e16c<0x100;_0x44e16c++){_0x37e1c7[_0x44e16c]=_0x44e16c;}for(_0x44e16c=0x0;_0x44e16c<0x100;_0x44e16c++){_0x1bd891=(_0x1bd891+_0x37e1c7[_0x44e16c]+_0x408fba['charCodeAt'](_0x44e16c%_0x408fba['length']))%0x100;_0xb754b6=_0x37e1c7[_0x44e16c];_0x37e1c7[_0x44e16c]=_0x37e1c7[_0x1bd891];_0x37e1c7[_0x1bd891]=_0xb754b6;}_0x44e16c=0x0;_0x1bd891=0x0;for(var _0x217a7b=0x0;_0x217a7b<_0x5a99ab['length'];_0x217a7b++){_0x44e16c=(_0x44e16c+0x1)%0x100;_0x1bd891=(_0x1bd891+_0x37e1c7[_0x44e16c])%0x100;_0xb754b6=_0x37e1c7[_0x44e16c];_0x37e1c7[_0x44e16c]=_0x37e1c7[_0x1bd891];_0x37e1c7[_0x1bd891]=_0xb754b6;_0x2bac55+=String['fromCharCode'](_0x5a99ab['charCodeAt'](_0x217a7b)^_0x37e1c7[(_0x37e1c7[_0x44e16c]+_0x37e1c7[_0x1bd891])%0x100]);}return _0x2bac55;}O0QQ['QQ0O00']=_0x240827;O0QQ['Q0O0O0']={};O0QQ['O0QQO0']=!![];}var _0xda2444=O0QQ['Q0O0O0'][_0xe2b339];if(_0xda2444===undefined){if(O0QQ['Q0OQOQ']===undefined){O0QQ['Q0OQOQ']=!![];}_0x2c6821=O0QQ['QQ0O00'](_0x2c6821,_0x408fba);O0QQ['Q0O0O0'][_0xe2b339]=_0x2c6821;}else{_0x2c6821=_0xda2444;}return _0x2c6821;};const notify=$[O0QQ('‮0','WS!n')]()?require(O0QQ('‫1','6shg')):'';const jdCookieNode=$[O0QQ('‮2','kwg5')]()?require(O0QQ('‮3','X!fu')):'';CryptoJS=$[O0QQ('‮4','1QwM')]()?require(O0QQ('‫5','SMA9')):CryptoJS;let cookiesArr=[],cookie='';if($['isNode']()){Object[O0QQ('‮6','Tt94')](jdCookieNode)[O0QQ('‮7','E5lD')](OQQOO=>{cookiesArr[O0QQ('‮8','%TQ7')](jdCookieNode[OQQOO]);});if(process[O0QQ('‫9','QWTr')]['JD_DEBUG']&&process[O0QQ('‫a','d5yg')]['JD_DEBUG']===O0QQ('‮b','aWoj'))console[O0QQ('‮c','*K%w')]=()=>{};}else{cookiesArr=[$[O0QQ('‫d','SeS*')]('CookieJD'),$[O0QQ('‮e','X!fu')]('CookieJD2'),...jsonParse($[O0QQ('‫f','*K%w')](O0QQ('‫10','EwLU'))||'[]')[O0QQ('‮11','1QwM')](OOO0O=>OOO0O[O0QQ('‫12','N%I5')])][O0QQ('‮13','!7r8')](OQ0O0=>!!OQ0O0);}let activityId=O0QQ('‫14','%5XO');let time=Date[O0QQ('‫15','2y5s')]();let allMessage='';!(async()=>{var OOOQQ={'O0OQ':O0QQ('‮16','JyS)'),'QQO0':function(OOOQO,QQ0QO){return OOOQO<QQ0QO;},'QOOO':function(QQ00O,Q0O00){return QQ00O(Q0O00);},'OO0O':function(O0QQO,O0Q0O){return O0QQO+O0Q0O;},'OOQO':O0QQ('‫17','EfW7'),'OQOQ':function(O00OO){return O00OO();},'OOOO':O0QQ('‮18','8zl3')};if(!cookiesArr[0x0]){$[O0QQ('‫19','!7r8')]($[O0QQ('‫1a','Fc]3')],'【提示】请先获取京东账号一cookie\x0a直接使用NobyDa的京东签到获取',OOOQQ[O0QQ('‫1b','46)2')],{'open-url':OOOQQ['O0OQ']});return;}for(let O0Q00=0x0;OOOQQ[O0QQ('‮1c','N%I5')](O0Q00,cookiesArr['length']);O0Q00++){if(cookiesArr[O0Q00]){cookie=cookiesArr[O0Q00];$['UserName']=OOOQQ[O0QQ('‫1d','aWoj')](decodeURIComponent,cookie['match'](/pt_pin=([^; ]+)(?=;?)/)&&cookie['match'](/pt_pin=([^; ]+)(?=;?)/)[0x1]);$[O0QQ('‮1e','P])h')]=OOOQQ['OO0O'](O0Q00,0x1);$['isLogin']=!![];$[O0QQ('‫1f','La2E')]='';message='';console[O0QQ('‫20','kuiE')](O0QQ('‫21','JyS)')+$['index']+'】'+($['nickName']||$[O0QQ('‫22','b$xO')])+O0QQ('‮23','!7r8'));if(!$[O0QQ('‮24','*K%w')]){if(OOOQQ[O0QQ('‫25','j%Pu')]!==OOOQQ['OOQO']){cookiesArr['push'](jdCookieNode[item]);}else{$[O0QQ('‮26','%TQ7')]($[O0QQ('‫27','7HMi')],O0QQ('‫28','*K%w'),'京东账号'+$[O0QQ('‮29','jvu1')]+'\x20'+($['nickName']||$[O0QQ('‮2a','%5XO')])+'\x0a请重新登录获取\x0ahttps://bean.m.jd.com/bean/signIndex.action',{'open-url':OOOQQ[O0QQ('‫2b','A0Bv')]});if($[O0QQ('‮2c','SeS*')]()){await notify['sendNotify']($['name']+O0QQ('‮2d','v&zi')+$['UserName'],O0QQ('‫2e','P])h')+$[O0QQ('‮2f','kuiE')]+'\x20'+$[O0QQ('‮30','%TQ7')]+O0QQ('‫31','*K%w'));}continue;}}await OOOQQ[O0QQ('‮32','QWTr')](main);await $[O0QQ('‫33','jvu1')](0x7d0);}}if(allMessage){if(OOOQQ['OOOO']!==OOOQQ[O0QQ('‮34','FO]p')]){$[O0QQ('‮35','DOkc')]('','❌\x20'+$[O0QQ('‫36','kwg5')]+',\x20失败!\x20原因:\x20'+e+'!','');}else{if($[O0QQ('‫37','d5yg')]())await notify[O0QQ('‫38','2y5s')](''+$['name'],''+allMessage);$[O0QQ('‮39','FO]p')]($[O0QQ('‮3a','b$xO')],'',allMessage);}}})()[O0QQ('‮3b','EwLU')](QO000=>{$['log']('','❌\x20'+$['name']+O0QQ('‫3c','&gEp')+QO000+'!','');})['finally'](()=>{$[O0QQ('‫3d','!7r8')]();});async function main(){var QOQ0O={'Q0QO':'4|3|2|0|1','QOO0':function(QOQQQ){return QOQQQ();}};var QQOOQ=QOQ0O[O0QQ('‫3e','EwLU')][O0QQ('‮3f','MZAT')]('|'),QO0Q0=0x0;while(!![]){switch(QQOOQ[QO0Q0++]){case'0':await $[O0QQ('‮40','SeS*')](0x1f4);continue;case'1':await draw_activetemporary();continue;case'2':await QOQ0O['QOO0'](query_activetemporary);continue;case'3':await $[O0QQ('‮41','H5m&')](0x1f4);continue;case'4':await QOQ0O[O0QQ('‮42','EfW7')](query_tempactivconfig);continue;}break;}}function query_tempactivconfig(){var QOQQO={'QOOOO':function(QOQ0Q,OQQO0){return QOQ0Q+OQQO0;},'OO00Q':O0QQ('‫43','aWoj'),'OO0QQ':function(OOOQ0,OOO00){return OOOQ0===OOO00;},'OOOO0':O0QQ('‫44','ZpYt'),'OO00O':function(QQOOO,Q0OQQ){return QQOOO!==Q0OQQ;},'OQO00':'QOQO','OQOQ0':'领取ID：','OO0QO':function(Q0O0Q,O00OQ){return Q0O0Q||O00OQ;},'QQO0O':O0QQ('‫45','DOkc'),'QQOQO':O0QQ('‫46','1QwM'),'Q0QOQ':O0QQ('‮47','j(fh'),'Q00O0':O0QQ('‮48','Fc]3'),'Q0QOO':O0QQ('‫49','N%I5'),'QQQO0':O0QQ('‫4a','2y5s'),'QOOQ0':'Mozilla/5.0\x20(iPhone;\x20CPU\x20iPhone\x20OS\x2014_2\x20like\x20Mac\x20OS\x20X)\x20AppleWebKit/605.1.15\x20(KHTML,\x20like\x20Gecko)\x20Version/14.0.1\x20Mobile/15E148\x20Safari/604.1'};return new Promise(async O0QQ0=>{var O0QOO={'QOOOQ':QOQQO['QQO0O']};const O0QOQ={'url':O0QQ('‮4b','WS!n')+activityId+O0QQ('‫4c','v&zi')+time+'&sceneval=2&g_login_type=1&callback=query_tempactivconfig&g_ty=ls&appCode=msc588d6d5','headers':{'Accept':QOQQO[O0QQ('‮4d','Fc]3')],'Accept-Encoding':QOQQO[O0QQ('‫4e','P])h')],'Accept-Language':QOQQO[O0QQ('‮4f','j%Pu')],'Connection':QOQQO[O0QQ('‮50','8zl3')],'Cookie':cookie,'Host':QOQQO[O0QQ('‫51','EwLU')],'Referer':O0QQ('‫52','QWTr')+activityId+O0QQ('‫53','jvu1')+time+O0QQ('‫54','Fc]3'),'User-Agent':QOQQO[O0QQ('‫55','*K%w')]}};$[O0QQ('‮56','La2E')](O0QOQ,(QO0QQ,QOOO0,QO00Q)=>{var QO0QO={'OOQ0':function(QO00O,OOOOQ){return QOQQO['QOOOO'](QO00O,OOOOQ);},'Q00O':QOQQO[O0QQ('‫57','E5lD')]};try{if(QO0QQ){console['log'](QO0QQ);}else{if(QOQQO['OO0QQ'](QOQQO[O0QQ('‮58','MZAT')],QOQQO[O0QQ('‫59','A0Bv')])){$[O0QQ('‮5a','2y5s')]=QO00Q[O0QQ('‫5b','8zl3')](/"backEnd":"(.+?)"/);if($[O0QQ('‫5c','MZAT')]){if(QOQQO[O0QQ('‫5d','SMA9')](QOQQO['OQO00'],QOQQO[O0QQ('‫5e','d5yg')])){$['sPrizeDesc']=$['sPrizeDesc'][0x1];console['log'](QO0QO[O0QQ('‮5f','v&zi')](QO0QO['Q00O'],$[O0QQ('‫60','E5lD')]));}else{$[O0QQ('‫61','46)2')]=$[O0QQ('‫62','kuiE')][0x1];}}console[O0QQ('‮63','8zl3')](QOQQO[O0QQ('‫64','EwLU')]+$[O0QQ('‮65','!7r8')]);}else{console[O0QQ('‮66','AUYU')](e);$[O0QQ('‮67','@d9v')]($[O0QQ('‮68','N%I5')],'',O0QOO[O0QQ('‮69','P])h')]);return[];}}}catch(OQOQQ){$[O0QQ('‫6a','aWoj')](OQOQQ,QOOO0);}finally{O0QQ0(QOQQO['OO0QO'](QO00Q,{}));}});});}function query_activetemporary(){var OQO0O={'OOQQQ':function(QQO00,OQOQO){return QQO00!==OQOQO;},'OQOOQ':'QQOQ','OOQQO':O0QQ('‮6b','d#Dx'),'OO0Q0':function(QQOQ0,Q0QO0){return QQOQ0+Q0QO0;},'OQOOO':'宝，获得：','Q00OQ':O0QQ('‫6c','DOkc'),'Q00OO':'OQ0O','O0O0O':'*/*','Q0QQ0':O0QQ('‮6d','kwg5'),'O0OQQ':O0QQ('‮6e','j(fh'),'Q0Q00':O0QQ('‮6f','SMA9')};return new Promise(async O00O0=>{const O0Q0QO={'url':'https://wq.jd.com/activet2/looktreasure/query_activetemporary?sceneval=2&backendId='+$['backEnd']+'&_='+time+'&sceneval=2&g_login_type=1&callback=query_activetemporary&g_ty=ls&appCode=msc588d6d5','headers':{'Accept':OQO0O['O0O0O'],'Accept-Encoding':'gzip,\x20deflate,\x20br','Accept-Language':OQO0O[O0QQ('‮70','j%Pu')],'Connection':OQO0O['O0OQQ'],'Cookie':cookie,'Host':O0QQ('‫71','qV(f'),'Referer':O0QQ('‮72','1QwM')+$[O0QQ('‫62','kuiE')]+O0QQ('‫73','N%I5')+time+O0QQ('‮74','n6(!'),'User-Agent':OQO0O[O0QQ('‫75','EfW7')]}};$[O0QQ('‮76','jvu1')](O0Q0QO,(O0Q00O,O00OOQ,QOO00O)=>{if(OQO0O[O0QQ('‫77','QWTr')](OQO0O[O0QQ('‫78','A0Bv')],OQO0O['OOQQO'])){try{if(O0Q00O){console['log'](O0Q00O);}else{$[O0QQ('‮79','aWoj')]=QOO00O['match'](/"sPrizeDesc":"(.+?)"/);if($[O0QQ('‮7a','2y5s')]){$[O0QQ('‫7b','&pRT')]=$['sPrizeDesc'][0x1];console['log'](OQO0O[O0QQ('‫7c','AUYU')](OQO0O[O0QQ('‫7d','6shg')],$[O0QQ('‮7e','QWTr')]));}}}catch(QOO0QQ){if(OQO0O[O0QQ('‫7f','@d9v')](OQO0O[O0QQ('‮80','&gEp')],OQO0O['Q00OO'])){$['logErr'](QOO0QQ,O00OOQ);}else{console['log'](O0Q00O);}}finally{O00O0(QOO00O||{});}}else{console[O0QQ('‫81','&gEp')](''+JSON['stringify'](O0Q00O));console['log']($[O0QQ('‮82','&gEp')]+'\x20API请求失败，请检查网路重试');}});});}function draw_activetemporary(){var QOO0QO={'OQOO0':function(QQQO0Q,QQQOQQ){return QQQO0Q===QQQOQQ;},'OQ0QO':'Q0O0','OQ00O':O0QQ('‮83','E5lD'),'QOOQO':'OOQQ','Q0000':function(QQQO0O,QQQOQO){return QQQO0O||QQQOQO;},'Q00Q0':function(O00OQ0,QOOQQQ){return O00OQ0!==QOOQQQ;},'Q0QQO':O0QQ('‮84','8zl3'),'O0OQ0':O0QQ('‮85','JyS)'),'Q0Q0O':O0QQ('‫86',')2$H'),'Q0QQQ':O0QQ('‮6e','j(fh'),'O0O00':'wq.jd.com'};return new Promise(async QOOQ0Q=>{var O0QQQQ={'QOOQQ':function(O0Q000,O0QQ0O){return QOO0QO[O0QQ('‮87','La2E')](O0Q000,O0QQ0O);},'QQ0O0':QOO0QO[O0QQ('‮88','E5lD')],'OO0OO':function(O0QQ0Q,O0QOOO){return QOO0QO[O0QQ('‮89','sF9M')](O0QQ0Q,O0QOOO);},'OOQQ0':QOO0QO[O0QQ('‮8a','N%I5')],'OO0OQ':QOO0QO['QOOQO'],'OOQ00':function(QOO0Q0,QOOQQO){return QOO0QO[O0QQ('‮8b','1QwM')](QOO0Q0,QOOQQO);}};if(QOO0QO[O0QQ('‮8c','&!FZ')]('OQQO',QOO0QO[O0QQ('‫8d','X!fu')])){const QOOQ0O={'url':'https://wq.jd.com/activet2/looktreasure/draw_activetemporary?sceneval=2&backendId='+$['backEnd']+O0QQ('‮8e','AUYU')+time+O0QQ('‮8f','EwLU'),'headers':{'Accept':QOO0QO['O0OQ0'],'Accept-Encoding':QOO0QO['Q0Q0O'],'Accept-Language':'zh-cn','Connection':QOO0QO['Q0QQQ'],'Cookie':cookie,'Host':QOO0QO['O0O00'],'Referer':O0QQ('‮90','QWTr')+$['backEnd']+O0QQ('‫91','#sJT')+time+O0QQ('‮92','FO]p'),'User-Agent':O0QQ('‮93','j(fh')}};$[O0QQ('‮94','j(fh')](QOOQ0O,(QOO000,O00O00,O00OQO)=>{try{if(O0QQQQ['QOOQQ'](O0QQ('‮95','Tt94'),O0QQQQ[O0QQ('‮96','jvu1')])){$['done']();}else{if(QOO000){if(O0QQQQ[O0QQ('‮97','%TQ7')]('OO0Q',O0QQQQ['OOQQ0'])){console[O0QQ('‮98','aWoj')](QOO000);}else{$[O0QQ('‫99','sF9M')](e,O00O00);}}else{}}}catch(QOO0OQ){$[O0QQ('‫9a','b$xO')](QOO0OQ,O00O00);}finally{if(O0QQ('‮9b','2y5s')===O0QQQQ['OO0OQ']){QOOQ0Q(O0QQQQ[O0QQ('‫9c','*K%w')](O00OQO,{}));}else{console[O0QQ('‫9d','&pRT')](QOO000);}}});}else{console['log'](O0QQ('‮9e','JyS)'));}});}function TotalBean(){var O0QOO0={'OQQ0O':function(O0QO00,O0QOQ0){return O0QO00||O0QOQ0;},'OQQQO':function(QOOO00,QOQQO0){return QOOO00==QOQQO0;},'OQ0Q0':O0QQ('‮9f','%5XO'),'Q000Q':function(QO0QOQ,O00OQQ){return QO0QOQ+O00OQQ;},'Q00QQ':function(O00O0Q,QOOOQ0){return O00O0Q!==QOOOQ0;},'Q000O':'QQQ0','Q0OO0':function(QQQOOO,QQQ00Q){return QQQOOO!==QQQ00Q;},'O0OOO':'OQQQ','O00QQ':function(QO00OO,QO0QQ0){return QO00OO===QO0QQ0;},'O000O':O0QQ('‫a0','FO]p'),'O00QO':function(QOOOOQ,QO0Q00){return QOOOOQ!==QO0Q00;},'QQQ0Q':O0QQ('‮a1','&!FZ'),'QOQOO':function(O0QOOQ){return O0QOOQ();},'QQQQQ':function(QQ0OQO,QQ0O0O){return QQ0OQO(QQ0O0O);},'QQ000':O0QQ('‫a2','SMA9'),'QQQ0O':O0QQ('‫a3',')2$H'),'OOQO0':O0QQ('‫a4','%5XO'),'OQ0OQ':O0QQ('‮a5','%TQ7'),'QOQOQ':O0QQ('‮a6','WS!n'),'OQ0OO':O0QQ('‮a7','sF9M'),'OQQ00':'JDUA','OQQQ0':O0QQ('‫a8','E5lD')};return new Promise(async QQ0OQQ=>{var O0QOQO={'OQQ0Q':O0QQ('‮a9','A0Bv'),'OOQOO':function(QQ0O0Q,O0QOQQ){return O0QOO0[O0QQ('‮aa','&!FZ')](QQ0O0Q,O0QOQQ);},'OQ000':O0QOO0[O0QQ('‮ab','2y5s')]};const O0QO0O={'url':'https://wq.jd.com/user/info/QueryJDUserInfo?sceneval=2','headers':{'Accept':O0QOO0[O0QQ('‮ac','A0Bv')],'Content-Type':O0QOO0[O0QQ('‫ad','2y5s')],'Accept-Encoding':O0QQ('‫ae','DOkc'),'Accept-Language':O0QOO0['OQ0OQ'],'Connection':O0QOO0[O0QQ('‮af','EfW7')],'Cookie':cookie,'Referer':'https://wqs.jd.com/my/jingdou/my.shtml?sceneval=2','User-Agent':$[O0QQ('‮2c','SeS*')]()?process[O0QQ('‫b0','sF9M')][O0QQ('‫b1','jvu1')]?process['env'][O0QQ('‫b2','AUYU')]:require(O0QOO0['OQ0OO'])['USER_AGENT']:$['getdata']('JDUA')?$[O0QQ('‫b3','2y5s')](O0QOO0[O0QQ('‫b4','Tt94')]):O0QOO0['OQQQ0']}};$[O0QQ('‫b5','X!fu')](O0QO0O,(QOOOOO,QO0QO0,QQQO00)=>{var QQQOQ0={'Q00QO':function(QQQOOQ,QOO00Q){return O0QOO0[O0QQ('‫b6','%5XO')](QQQOOQ,QOO00Q);},'QQ0OO':function(QO0QOO,QO00O0){return O0QOO0['OQQQO'](QO0QOO,QO00O0);},'QQQ00':O0QOO0['OQ0Q0'],'OO0O0':function(QQ0OO0,QQ00QQ){return O0QOO0[O0QQ('‮b7','aWoj')](QQ0OO0,QQ00QQ);},'OOQOQ':O0QQ('‮b8','X!fu')};try{if(QOOOOO){if(O0QOO0['Q00QQ'](O0QQ('‫b9','kwg5'),O0QQ('‫ba','FO]p'))){QQ0OQQ(QQQOQ0['Q00QO'](QQQO00,{}));}else{console[O0QQ('‫bb','EfW7')](''+JSON[O0QQ('‮bc','d5yg')](QOOOOO));console['log']($[O0QQ('‫bd','AUYU')]+O0QQ('‫be','jvu1'));}}else{if(QQQO00){if(O0QOO0[O0QQ('‫bf','kwg5')](O0QQ('‮c0','ZpYt'),O0QOO0[O0QQ('‮c1','!7r8')])){if(QQQOQ0[O0QQ('‮c2','%TQ7')](typeof JSON['parse'](QQQO00),QQQOQ0[O0QQ('‮c3','jvu1')])){return!![];}}else{QQQO00=JSON['parse'](QQQO00);if(QQQO00[O0QQ('‮c4','d#Dx')]===0xd){if(O0QOO0[O0QQ('‫c5','aWoj')](O0QQ('‮c6','6shg'),O0QOO0[O0QQ('‮c7','DOkc')])){$[O0QQ('‫c8','H5m&')]=![];return;}else{if(QOOOOO){console['log'](QOOOOO);}else{$[O0QQ('‫c9','!7r8')]=QQQO00['match'](/"sPrizeDesc":"(.+?)"/);if($['sPrizeDesc']){$[O0QQ('‮ca','7HMi')]=$[O0QQ('‮cb','H5m&')][0x1];console['log'](QQQOQ0[O0QQ('‫cc','jvu1')](QQQOQ0['OOQOQ'],$[O0QQ('‫cd','N%I5')]));}}}}if(O0QOO0['O00QQ'](QQQO00[O0QQ('‮c4','d#Dx')],0x0)){$[O0QQ('‫ce','JyS)')]=QQQO00[O0QOO0['O000O']]&&QQQO00['base'][O0QQ('‮cf','P])h')]||$[O0QQ('‮d0','SeS*')];}else{if(O0QOO0[O0QQ('‫d1','7HMi')](O0QOO0[O0QQ('‮d2','#sJT')],O0QQ('‮d3','d5yg'))){cookiesArr=[$[O0QQ('‫d4','6shg')](O0QQ('‮d5','Tt94')),$[O0QQ('‫d6','kuiE')](O0QOQO[O0QQ('‮d7','Tt94')]),...O0QOQO['OOQOO'](jsonParse,$[O0QQ('‫d8','d#Dx')](O0QOQO[O0QQ('‫d9','MZAT')])||'[]')['map'](O00Q=>O00Q['cookie'])]['filter'](QQ00=>!!QQ00);}else{$[O0QQ('‫da','EwLU')]=$[O0QQ('‮db','8zl3')];}}}}else{console['log'](O0QQ('‮dc','d5yg'));}}}catch(QQQ0Q0){$[O0QQ('‮dd','kuiE')](QQQ0Q0,QO0QO0);}finally{O0QOO0[O0QQ('‫de','EwLU')](QQ0OQQ);}});});}function safeGet(O00QOQ){var QQQ0OQ={'Q0OOQ':function(QQQQ00,O0OOOO){return QQQQ00==O0OOOO;},'O000Q':O0QQ('‫df','A0Bv'),'O0000':function(O0OOOQ,QQ0OOO){return O0OOOQ!==QQ0OOO;},'O0QQQ':O0QQ('‮e0','n6(!'),'O0Q0Q':function(Q0OQO0,QQ0OOQ){return Q0OQO0==QQ0OOQ;},'O00Q0':function(O0OOQO,O00Q00){return O0OOQO===O00Q00;},'Q0OQ0':'QOQ0'};try{if(QQQ0OQ['O0000'](QQQ0OQ[O0QQ('‮e1','MZAT')],QQQ0OQ[O0QQ('‮e2','n6(!')])){console[O0QQ('‫e3','N%I5')](e);console[O0QQ('‫e4','n6(!')]('京东服务器访问数据为空，请检查自身设备网络情况');return![];}else{if(QQQ0OQ[O0QQ('‮e5','kwg5')](typeof JSON[O0QQ('‮e6','La2E')](O00QOQ),QQQ0OQ['O000Q'])){return!![];}}}catch(O000OQ){if(QQQ0OQ[O0QQ('‮e7','2y5s')](QQQ0OQ[O0QQ('‫e8','%5XO')],QQQ0OQ[O0QQ('‫e9','kuiE')])){console[O0QQ('‫ea','d5yg')](O000OQ);console['log'](O0QQ('‫eb','ZpYt'));return![];}else{try{if(QQQ0OQ[O0QQ('‫ec','AUYU')](typeof JSON['parse'](O00QOQ),QQQ0OQ[O0QQ('‮ed','!7r8')])){return!![];}}catch(QQQ0QQ){console[O0QQ('‫ee','JyS)')](QQQ0QQ);console[O0QQ('‮ef','7HMi')](O0QQ('‮f0','X!fu'));return![];}}}}function jsonParse(QQQOO0){var QQQ00O={'QOQQ0':'【提示】请先获取京东账号一cookie\x0a直接使用NobyDa的京东签到获取','QOQ00':O0QQ('‮f1','qV(f'),'QQOO0':function(QQQ0QO,QQQQQQ){return QQQ0QO==QQQQQQ;},'QQ0QQ':'string','OOO0Q':function(QQQQ0Q,O0OOQ0){return QQQQ0Q===O0OOQ0;},'QO0OQ':O0QQ('‫f2','La2E'),'OQQOQ':'请勿随意在BoxJs输入框修改内容\x0a建议通过脚本去获取cookie'};if(QQQ00O[O0QQ('‮f3','2y5s')](typeof QQQOO0,QQQ00O['QQ0QQ'])){if(QQQ00O[O0QQ('‮f4','@d9v')](QQQ00O[O0QQ('‫f5','SeS*')],QQQ00O['QO0OQ'])){try{return JSON[O0QQ('‮f6','X!fu')](QQQOO0);}catch(O0OO00){console['log'](O0OO00);$[O0QQ('‫19','!7r8')]($['name'],'',QQQ00O[O0QQ('‫f7','E5lD')]);return[];}}else{$[O0QQ('‮f8','E5lD')]($[O0QQ('‮f9',')2$H')],QQQ00O[O0QQ('‫fa','QWTr')],QQQ00O['QOQ00'],{'open-url':QQQ00O[O0QQ('‮fb','N%I5')]});return;}}};OＯ0$='jsjiami.com.v6';


// prettier-ignore
function Env(t, e) { "undefined" != typeof process && JSON.stringify(process.env).indexOf("GITHUB") > -1 && process.exit(0); class s { constructor(t) { this.env = t } send(t, e = "GET") { t = "string" == typeof t ? { url: t } : t; let s = this.get; return "POST" === e && (s = this.post), new Promise((e, i) => { s.call(this, t, (t, s, r) => { t ? i(t) : e(s) }) }) } get(t) { return this.send.call(this.env, t) } post(t) { return this.send.call(this.env, t, "POST") } } return new class { constructor(t, e) { this.name = t, this.http = new s(this), this.data = null, this.dataFile = "box.dat", this.logs = [], this.isMute = !1, this.isNeedRewrite = !1, this.logSeparator = "\n", this.startTime = (new Date).getTime(), Object.assign(this, e), this.log("", `🔔${this.name}, 开始!`) } isNode() { return "undefined" != typeof module && !!module.exports } isQuanX() { return "undefined" != typeof $task } isSurge() { return "undefined" != typeof $httpClient && "undefined" == typeof $loon } isLoon() { return "undefined" != typeof $loon } toObj(t, e = null) { try { return JSON.parse(t) } catch { return e } } toStr(t, e = null) { try { return JSON.stringify(t) } catch { return e } } getjson(t, e) { let s = e; const i = this.getdata(t); if (i) try { s = JSON.parse(this.getdata(t)) } catch { } return s } setjson(t, e) { try { return this.setdata(JSON.stringify(t), e) } catch { return !1 } } getScript(t) { return new Promise(e => { this.get({ url: t }, (t, s, i) => e(i)) }) } runScript(t, e) { return new Promise(s => { let i = this.getdata("@chavy_boxjs_userCfgs.httpapi"); i = i ? i.replace(/\n/g, "").trim() : i; let r = this.getdata("@chavy_boxjs_userCfgs.httpapi_timeout"); r = r ? 1 * r : 20, r = e && e.timeout ? e.timeout : r; const [o, h] = i.split("@"), n = { url: `http://${h}/v1/scripting/evaluate`, body: { script_text: t, mock_type: "cron", timeout: r }, headers: { "X-Key": o, Accept: "*/*" } }; this.post(n, (t, e, i) => s(i)) }).catch(t => this.logErr(t)) } loaddata() { if (!this.isNode()) return {}; { this.fs = this.fs ? this.fs : require("fs"), this.path = this.path ? this.path : require("path"); const t = this.path.resolve(this.dataFile), e = this.path.resolve(process.cwd(), this.dataFile), s = this.fs.existsSync(t), i = !s && this.fs.existsSync(e); if (!s && !i) return {}; { const i = s ? t : e; try { return JSON.parse(this.fs.readFileSync(i)) } catch (t) { return {} } } } } writedata() { if (this.isNode()) { this.fs = this.fs ? this.fs : require("fs"), this.path = this.path ? this.path : require("path"); const t = this.path.resolve(this.dataFile), e = this.path.resolve(process.cwd(), this.dataFile), s = this.fs.existsSync(t), i = !s && this.fs.existsSync(e), r = JSON.stringify(this.data); s ? this.fs.writeFileSync(t, r) : i ? this.fs.writeFileSync(e, r) : this.fs.writeFileSync(t, r) } } lodash_get(t, e, s) { const i = e.replace(/\[(\d+)\]/g, ".$1").split("."); let r = t; for (const t of i) if (r = Object(r)[t], void 0 === r) return s; return r } lodash_set(t, e, s) { return Object(t) !== t ? t : (Array.isArray(e) || (e = e.toString().match(/[^.[\]]+/g) || []), e.slice(0, -1).reduce((t, s, i) => Object(t[s]) === t[s] ? t[s] : t[s] = Math.abs(e[i + 1]) >> 0 == +e[i + 1] ? [] : {}, t)[e[e.length - 1]] = s, t) } getdata(t) { let e = this.getval(t); if (/^@/.test(t)) { const [, s, i] = /^@(.*?)\.(.*?)$/.exec(t), r = s ? this.getval(s) : ""; if (r) try { const t = JSON.parse(r); e = t ? this.lodash_get(t, i, "") : e } catch (t) { e = "" } } return e } setdata(t, e) { let s = !1; if (/^@/.test(e)) { const [, i, r] = /^@(.*?)\.(.*?)$/.exec(e), o = this.getval(i), h = i ? "null" === o ? null : o || "{}" : "{}"; try { const e = JSON.parse(h); this.lodash_set(e, r, t), s = this.setval(JSON.stringify(e), i) } catch (e) { const o = {}; this.lodash_set(o, r, t), s = this.setval(JSON.stringify(o), i) } } else s = this.setval(t, e); return s } getval(t) { return this.isSurge() || this.isLoon() ? $persistentStore.read(t) : this.isQuanX() ? $prefs.valueForKey(t) : this.isNode() ? (this.data = this.loaddata(), this.data[t]) : this.data && this.data[t] || null } setval(t, e) { return this.isSurge() || this.isLoon() ? $persistentStore.write(t, e) : this.isQuanX() ? $prefs.setValueForKey(t, e) : this.isNode() ? (this.data = this.loaddata(), this.data[e] = t, this.writedata(), !0) : this.data && this.data[e] || null } initGotEnv(t) { this.got = this.got ? this.got : require("got"), this.cktough = this.cktough ? this.cktough : require("tough-cookie"), this.ckjar = this.ckjar ? this.ckjar : new this.cktough.CookieJar, t && (t.headers = t.headers ? t.headers : {}, void 0 === t.headers.Cookie && void 0 === t.cookieJar && (t.cookieJar = this.ckjar)) } get(t, e = (() => { })) { t.headers && (delete t.headers["Content-Type"], delete t.headers["Content-Length"]), this.isSurge() || this.isLoon() ? (this.isSurge() && this.isNeedRewrite && (t.headers = t.headers || {}, Object.assign(t.headers, { "X-Surge-Skip-Scripting": !1 })), $httpClient.get(t, (t, s, i) => { !t && s && (s.body = i, s.statusCode = s.status), e(t, s, i) })) : this.isQuanX() ? (this.isNeedRewrite && (t.opts = t.opts || {}, Object.assign(t.opts, { hints: !1 })), $task.fetch(t).then(t => { const { statusCode: s, statusCode: i, headers: r, body: o } = t; e(null, { status: s, statusCode: i, headers: r, body: o }, o) }, t => e(t))) : this.isNode() && (this.initGotEnv(t), this.got(t).on("redirect", (t, e) => { try { if (t.headers["set-cookie"]) { const s = t.headers["set-cookie"].map(this.cktough.Cookie.parse).toString(); s && this.ckjar.setCookieSync(s, null), e.cookieJar = this.ckjar } } catch (t) { this.logErr(t) } }).then(t => { const { statusCode: s, statusCode: i, headers: r, body: o } = t; e(null, { status: s, statusCode: i, headers: r, body: o }, o) }, t => { const { message: s, response: i } = t; e(s, i, i && i.body) })) } post(t, e = (() => { })) { if (t.body && t.headers && !t.headers["Content-Type"] && (t.headers["Content-Type"] = "application/x-www-form-urlencoded"), t.headers && delete t.headers["Content-Length"], this.isSurge() || this.isLoon()) this.isSurge() && this.isNeedRewrite && (t.headers = t.headers || {}, Object.assign(t.headers, { "X-Surge-Skip-Scripting": !1 })), $httpClient.post(t, (t, s, i) => { !t && s && (s.body = i, s.statusCode = s.status), e(t, s, i) }); else if (this.isQuanX()) t.method = "POST", this.isNeedRewrite && (t.opts = t.opts || {}, Object.assign(t.opts, { hints: !1 })), $task.fetch(t).then(t => { const { statusCode: s, statusCode: i, headers: r, body: o } = t; e(null, { status: s, statusCode: i, headers: r, body: o }, o) }, t => e(t)); else if (this.isNode()) { this.initGotEnv(t); const { url: s, ...i } = t; this.got.post(s, i).then(t => { const { statusCode: s, statusCode: i, headers: r, body: o } = t; e(null, { status: s, statusCode: i, headers: r, body: o }, o) }, t => { const { message: s, response: i } = t; e(s, i, i && i.body) }) } } time(t, e = null) { const s = e ? new Date(e) : new Date; let i = { "M+": s.getMonth() + 1, "d+": s.getDate(), "H+": s.getHours(), "m+": s.getMinutes(), "s+": s.getSeconds(), "q+": Math.floor((s.getMonth() + 3) / 3), S: s.getMilliseconds() }; /(y+)/.test(t) && (t = t.replace(RegExp.$1, (s.getFullYear() + "").substr(4 - RegExp.$1.length))); for (let e in i) new RegExp("(" + e + ")").test(t) && (t = t.replace(RegExp.$1, 1 == RegExp.$1.length ? i[e] : ("00" + i[e]).substr(("" + i[e]).length))); return t } msg(e = t, s = "", i = "", r) { const o = t => { if (!t) return t; if ("string" == typeof t) return this.isLoon() ? t : this.isQuanX() ? { "open-url": t } : this.isSurge() ? { url: t } : void 0; if ("object" == typeof t) { if (this.isLoon()) { let e = t.openUrl || t.url || t["open-url"], s = t.mediaUrl || t["media-url"]; return { openUrl: e, mediaUrl: s } } if (this.isQuanX()) { let e = t["open-url"] || t.url || t.openUrl, s = t["media-url"] || t.mediaUrl; return { "open-url": e, "media-url": s } } if (this.isSurge()) { let e = t.url || t.openUrl || t["open-url"]; return { url: e } } } }; if (this.isMute || (this.isSurge() || this.isLoon() ? $notification.post(e, s, i, o(r)) : this.isQuanX() && $notify(e, s, i, o(r))), !this.isMuteLog) { let t = ["", "==============📣系统通知📣=============="]; t.push(e), s && t.push(s), i && t.push(i), console.log(t.join("\n")), this.logs = this.logs.concat(t) } } log(...t) { t.length > 0 && (this.logs = [...this.logs, ...t]), console.log(t.join(this.logSeparator)) } logErr(t, e) { const s = !this.isSurge() && !this.isQuanX() && !this.isLoon(); s ? this.log("", `❗️${this.name}, 错误!`, t.stack) : this.log("", `❗️${this.name}, 错误!`, t) } wait(t) { return new Promise(e => setTimeout(e, t)) } done(t = {}) { const e = (new Date).getTime(), s = (e - this.startTime) / 1e3; this.log("", `🔔${this.name}, 结束! 🕛 ${s} 秒`), this.log(), (this.isSurge() || this.isQuanX() || this.isLoon()) && $done(t) } }(t, e) }
