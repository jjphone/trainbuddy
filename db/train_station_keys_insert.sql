DROP TABLE IF EXISTS station_keys;
CREATE TABLE station_keys (
  key varchar(30),
  value varchar(30), 
  label varchar(30),
  key_chars varchar(100),
  rule int,
  start_at int,

  PRIMARY KEY (key)
) ;


insert into station_keys values 
('allw / allawah','allw', 'allw / allawah','<b>all</b>a<b>w</b>ah',1,0),
('arnc / arncliffe','arnc', 'arnc / arncliffe',' <b>arnc</b>liffe',1,0),
('artm / artarmon','artm', 'artm / artarmon',' <b>art</b>ar<b>m</b>on',1,0),
('ashf / ashfield','ashf', 'ashf / ashfield',' <b>ashf</b>ield',1,0),
('aubn / auburn','aubn', 'aubn / auburn',' <b>aub</b>ur<b>n</b>',1,0),
('bans / banksia','bans', 'bans / banksia',' <b>ban</b>k<b>s</b>ia',1,0),
('bant / bankstown','bant', 'bant / bankstown',' <b>ban</b>ks<b>t</b>own',1,0),
('barp / bardwell park','barp', 'barp / bardwell park',' <b>bar</b>dwell <b>p</b>ark',2,0),
('belm / belmore','belm', 'belm / belmore',' <b>belm</b>ore',1,0),
('berl / berala','berl', 'berl / berala',' <b>ber</b>a<b>l</b>a',1,0),
('bevh / beverly hill','bevh', 'bevh / beverly hill',' <b>bev</b>erly <b>h</b>ill',2,0),
('bexn / bexley north','bexn', 'bexn / bexley north',' <b>bex</b>ley <b>n</b>orth',2,0),
('birr / birrong','birr', 'birr / birrong',' <b>birr</b>ong',1,0),
('blat / blacktown','blat', 'blat / blacktown',' <b>bla</b>ck<b>t</b>own',1,0),
('bonj / bondi junction','bonj', 'bonj / bondi junction',' <b>bon</b>di <b>j</b>unction',2,0),
('burw / burwood','burw', 'burw / burwood',' <b>burw</b>ood',1,0),
('cabm / cabramatta','cabm', 'cabm / cabramatta',' <b>cab</b>ra<b>m</b>atta',9,0),
('cmla / camellia','cmla', 'cmla / camellia',' <b>c</b>a<b>m</b>e<b>l</b>li<b>a</b>',9,0),
('cams / campsie','cams', 'cams / campsie',' <b>cam</b>p<b>s</b>ie',1,0),
('cnlv / canley vale','cnlv', 'cnlv / canley vale',' <b>c</b>a<b>nl</b>ey <b>v</b>ale',9,0),
('canb / canterbury','canb', 'canb / canterbury',' <b>can</b>ter<b>b</b>ury',1,0),
('carf / carlingford','carf', 'carf / carlingford',' <b>car</b>ling<b>f</b>ord',1,0),
('cart / carlton','cart', 'cart / carlton',' <b>car</b>l<b>t</b>on',1,0),
('carm / carramar','carm', 'carm / carramar',' <b>car</b>ra<b>m</b>ar',1,0),
('casl / casula','casl', 'casl / casula',' <b>cas</b>u<b>l</b>a',1,0),
('cent / central','cent', 'cent / central',' <b>cent</b>ral',1,0),
('chaw / chatswood','chaw', 'chaw / chatswood',' <b>cha</b>ts<b>w</b>ood',1,0),
('cheh / chester hill','cheh', 'cheh / chester hill',' <b>che</b>ster <b>h</b>ill',2,0),
('cirq / circular quay','cirq', 'cirq / circular quay',' <b>cir</b>cular <b>q</b>uay',5,0),
('clyd / clyde','clyd', 'clyd / clyde',' <b>clyd</b>e',1,0),
('conw / concord west','conw', 'conw / concord west',' <b>con</b>cord <b>w</b>est',2,0),
('crod / croydon','crod', 'crod / croydon',' <b>cro</b>y<b>d</b>on',1,0),
('dens / denistone','dens', 'dens / denistone',' <b>den</b>i<b>s</b>tone',1,0),
('doma / domestic airport','doma', 'doma / domestic airport',' <b>dom</b>estic <b>a</b>irport',5,0),
('dulh / dulwich hill','dulh', 'dulh / dulwich hill',' <b>dul</b>wic<b>h</b> hill',2,0),
('dnds / dundas','dnds', 'dnds / dundas',' <b>d</b>u<b>nd</b>a<b>s</b>',9,0),
('eath / east hill','eath', 'eath / east hill',' <b>ea</b>s<b>t</b> <b>h</b>ill',9,0),
('easw / eastwood','easw', 'easw / eastwood',' <b>eas</b>t<b>w</b>ood',1,0),
('edgc / edgecliff','edgc', 'edgc / edgecliff',' <b>edg</b>e<b>c</b>liff',1,0),
('eppg / epping','eppg', 'eppg / epping',' <b>epp</b>in<b>g</b>',1,0),
('ersv / erskineville','ersv', 'ersv / erskineville',' <b>ers</b>kine<b>v</b>ille',1,0),
('faif / fairfield','faif', 'faif / fairfield',' <b>fai</b>r<b>f</b>ield',1,0),
('flet / flemington','flet', 'flet / flemington',' <b>fle</b>ming<b>t</b>on',1,0),
('glef / glenfield','glef', 'glef / glenfield',' <b>gle</b>n<b>f</b>ield',1,0),
('grav / granville','grav', 'grav / granville',' <b>gra</b>n<b>v</b>ille',1,0),
('gsqu / green square','gsqu', 'gsqu / green square',' <b>g</b>reen <b>squ</b>are',9,0),
('guif / guildford','guif', 'guif / guildford',' <b>gui</b>ld<b>f</b>ord',1,0),
('harp / harris park','harp', 'harp / harris park',' <b>har</b>ris <b>p</b>ark',5,0),
('holw / holsworthy','holw', 'holw / holsworthy',' <b>hol</b>s<b>w</b>orthy',1,0),
('homb / homebush','homb', 'homb / homebush',' <b>hom</b>e<b>b</b>ush',1,0),
('hurp / hurlstone park','hurp', 'hurp / hurlstone park',' <b>hur</b>lstone <b>p</b>ark',5,0),
('hurv / hurstville','hurv', 'hurv / hurstville',' <b>hur</b>st<b>v</b>ille',1,0),
('inta / international airport','inta', 'inta / international airport',' <b>int</b>ern<b>a</b>tional airport',5,0),
('kinc / kings cross','kinc', 'kinc / kings cross',' <b>kin</b>gs <b>c</b>ross',5,0),
('kgrv / kingsgrove','kgrv', 'kgrv / kingsgrove',' <b>k</b>ings<b>gr</b>o<b>v</b>e',9,0),
('kogr / kograph','kogr', 'kogr / kograph',' <b>kogr</b>aph',1,0),
('lakb / lakemba','lakb', 'lakb / lakemba',' <b>lak</b>em<b>b</b>a',1,0),
('leif / leightonfield','leif', 'leif / leightonfield',' <b>lei</b>ghton<b>f</b>ield',1,0),
('lews / lewisham','lews', 'lews / lewisham',' <b>lew</b>i<b>s</b>ham',1,0),
('lidc / lidcombe','lidc', 'lidc / lidcombe',' <b>lidc</b>ombe',1,0),
('livp / liverpool','livp', 'livp / liverpool',' <b>liv</b>er<b>p</b>ool',1,0),
('mact / macdonaldtown','mact', 'mact / macdonaldtown',' <b>mac</b>donald<b>t</b>own',1,0),
('mqrp / macquarie park','mqrp', 'mqrp / macquarie park',' <b>m</b>ac<b>q</b>ua<b>r</b>ie <b>p</b>ark',9,0),
('maqu / macquarie university','maqu', 'maqu / macquarie university',' <b>ma</b>c<b>qu</b>arie university',9,0),
('marv / marrickville','marv', 'marv / marrickville',' <b>mar</b>rick<b>v</b>ille',1,0),
('marp / martin place','marp', 'marp / martin place',' <b>mar</b>tin <b>p</b>lace',2,0),
('masc / mascot','masc', 'masc / mascot',' <b>masc</b>ot',1,0),
('meab / meadowbank','meab', 'meab / meadowbank',' <b>mea</b>dow<b>b</b>ank',1,0),
('merl / merrylands','merl', 'merl / merrylands',' <b>mer</b>ry<b>l</b>ands',1,0),
('milp / milsons point','milp', 'milp / milsons point',' <b>mil</b>sons <b>p</b>oint',2,0),
('musm / museum','musm', 'musm / museum',' <b>mus</b>eu<b>m</b>',1,0),
('narw / narwee','narw', 'narw / narwee',' <b>narw</b>ee',1,0),
('newt / newtown','newt', 'newt / newtown',' <b>newt</b>own',1,0),
('nsyd / north sydney','nsyd', 'nsyd / north sydney',' <b>n</b>orth <b>syd</b>ney',3,0),
('nryd / north ryde','nryd', 'nryd / north ryde',' <b>n</b>orth <b>ryd</b>e',3,0),
('nstf / north strathfield','nstf', 'nstf / north strathfield',' <b>n</b>orth <b>st</b>rath<b>f</b>ield',3,0),
('olyp / olympic park','olyp', 'olyp / olympic park',' <b>oly</b>mpic <b>p</b>ark',2,0),
('padt / padstow','padt', 'padt / padstow',' <b>pad</b>s<b>t</b>ow',1,0),
('pann / panania','pann', 'pann / panania',' <b>pan</b>a<b>n</b>ia',1,0),
('parm / parramatta','parm', 'parm / parramatta',' <b>par</b>ra<b>m</b>atta',1,0),
('penh / pendle hill','penh', 'penh / pendle hill',' <b>pen</b>dle <b>h</b>ill',2,0),
('pets / petersham','pets', 'pets / petersham',' <b>pet</b>er<b>s</b>ham',1,0),
('punb / punchbowl','punb', 'punb / punchbowl',' <b>pun</b>ch<b>b</b>owl',1,0),
('redf / redfern','redf', 'redf / redfern',' <b>redf</b>ern',1,0),
('regp / regents parks','regp', 'regp / regents parks',' <b>reg</b>ents <b>p</b>arks',2,0),
('revb / revesby','revb', 'revb / revesby',' <b>rev</b>es<b>b</b>y',1,0),
('rhod / rhodes','rhod', 'rhod / rhodes',' <b>rhod</b>es',1,0),
('rivw / riverwood','rivw', 'rivw / riverwood',' <b>riv</b>er<b>w</b>ood',1,0),
('rocd / rockdale','rocd', 'rocd / rockdale',' <b>roc</b>k<b>d</b>ale',1,0),
('rosh / rose hill','rosh', 'rosh / rose hill',' <b>ros</b>e <b>h</b>ill',2,0),
('rdlm / rydalmere','rdlm', 'rdlm / rydalmere',' <b>r</b>y<b>d</b>a<b>lm</b>ere',9,0),
('seft / sefton','seft', 'seft / sefton',' <b>seft</b>on',1,0),
('sevh / seven hill','sevh', 'sevh / seven hill',' <b>sev</b>en <b>h</b>ill',5,0),
('sjam / st james','sjam', 'sjam / st james',' <b>s</b>t <b>jam</b>es',3,0),
('sleo / st leonards','sleo', 'sleo / st leonards',' <b>s</b>t <b>leo</b>nards',3,0),
('spet / st peter','spet', 'spet / st peter',' <b>s</b>t <b>pet</b>er',3,0),
('stam / stanmore','stam', 'stam / stanmore',' <b>sta</b>n<b>m</b>ore',1,0),
('strf / strathfield','strf', 'strf / strathfield',' <b>str</b>ath<b>f</b>ield',1,0),
('sumh / summer hill','sumh', 'sumh / summer hill',' <b>sum</b>mer <b>h</b>ill',2,0),
('sydn / sydenham','sydn', 'sydn / sydenham',' <b>syd</b>e<b>n</b>ham',1,0),
('telp / telopea','telp', 'telp / telopea',' <b>tel</b>o<b>p</b>ea',1,0),
('temp / tempe','temp', 'temp / tempe',' <b>temp</b>e',1,0),
('toob / toongabbie','toob', 'toob / toongabbie',' <b>too</b>ngab<b>b</b>ie',1,0),
('towh / town hall','towh', 'towh / town hall',' <b>tow</b>n <b>h</b>all',2,0),
('turl / turrella','turl', 'turl / turrella',' <b>tur</b>rel<b>l</b>a',1,0),
('vilw / villawood','vilw', 'vilw / villawood',' <b>vil</b>la<b>w</b>ood',1,0),
('warf / warwick farm','warf', 'warf / warwick farm',' <b>war</b>wick <b>f</b>arm',2,0),
('wavt / waverton','wavt', 'wavt / waverton',' <b>wav</b>er<b>t</b>on',1,0),
('wewv / wentworthville','wewv', 'wewv / wentworthville',' <b>we</b>nt<b>w</b>orth<b>v</b>ille',9,0),
('wesm / westmead','wesm', 'wesm / westmead',' <b>wes</b>t<b>m</b>ead',1,0),
('wryd / west ryde','wryd', 'wryd / west ryde',' <b>w</b>est <b>ryd</b>e',3,0),
('wilp / wiley park','wilp', 'wilp / wiley park',' <b>wil</b>ey <b>p</b>ark',2,0),
('wolc / wolli creek','wolc', 'wolc / wolli creek',' <b>wol</b>li <b>c</b>reek',2,0),
('wscf / wollstonecraft','wscf', 'wscf / wollstonecraft',' <b>w</b>oll<b>s</b>tone<b>c</b>ra<b>f</b>t',9,0),
('wyny / wynyard','wyny', 'wyny / wynyard',' <b>wyny</b>ard',1,0),
('yagn / yagoona','yagn', 'yagn / yagoona',' <b>yag</b>oo<b>n</b>a',1,0),
('yenr / yennora','yenr', 'yenr / yennora',' <b>yen</b>no<b>r</b>a',1,0);